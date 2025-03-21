function AddCircAtomicArray(rad, X0, Y0, VX0, VY0, InitDist, Temp, Type)
global C
global x y AtomSpacing
global nAtoms
global AtomType Vx Vy Mass0 Mass1

if Type == 0
    Mass = Mass0;
else
    Mass = Mass1;
end

L = (2*rad - 1) * AtomSpacing;
W = (2*rad - 1) * AtomSpacing;

xp = linspace(-L/2, L/2, 2*rad);
yp = linspace(-W/2, W/2, 2*rad);

numAtoms = 0;
for i = 1:2*rad
    for j = 1:2*rad
        if xp(i)^2 + yp(j)^2 <= (rad*AtomSpacing)^2
            numAtoms = numAtoms+1;
            x(nAtoms + numAtoms) = xp(i);
            y(nAtoms + numAtoms) = yp(j);
        end
    end
end

% Add small random perturbations and shift to (X0, Y0)
x(nAtoms + 1:nAtoms + numAtoms) = x(nAtoms + 1:nAtoms + numAtoms) + ...
    (rand(1, numAtoms) - 0.5) * AtomSpacing * InitDist + X0;
y(nAtoms + 1:nAtoms + numAtoms) = y(nAtoms + 1:nAtoms + numAtoms) + ...
    (rand(1, numAtoms) - 0.5) * AtomSpacing * InitDist + Y0;

AtomType(nAtoms + 1:nAtoms + numAtoms) = Type;

% Explosion effect
explosionRadius = rad * 5 * AtomSpacing; % Inner half of the circle explodes
V_explosion = 50 * sqrt(C.kb * Temp / Mass); % Adjust velocity magnitude

for k = (nAtoms + 1):(nAtoms + numAtoms)
    distFromCenter = sqrt((x(k) - X0)^2 + (y(k) - Y0)^2);

    if distFromCenter <= explosionRadius
        % Compute unit radial direction
        dirX = (x(k) - X0) / distFromCenter;
        dirY = (y(k) - Y0) / distFromCenter;

        % Apply outward velocity
        Vx(k) = V_explosion * dirX;
        Vy(k) = V_explosion * dirY;
    else
        % Normal thermal motion for outer atoms
        if Temp == 0
            Vx(k) = 0;
            Vy(k) = 0;
        else
            std0 = sqrt(C.kb * Temp / Mass);
            Vx(k) = std0 * randn;
            Vy(k) = std0 * randn;
        end
    end
end

% Apply momentum correction **ONLY TO THE OUTER PARTICLES**
outerAtoms = find(distFromCenter > explosionRadius);
Vx(outerAtoms) = Vx(outerAtoms) - mean(Vx(outerAtoms)) + VX0;
Vy(outerAtoms) = Vy(outerAtoms) - mean(Vy(outerAtoms)) + VY0;

nAtoms = nAtoms + numAtoms;

end

