set(0, 'DefaultFigureWindowStyle', 'docked')
set(0, 'DefaultAxesFontSize', 20)
set(0, 'DefaultAxesFontName', 'Times New Roman')
set(0, 'DefaultLineLineWidth', 2)

nx = 50;
ny = 50;
N = nx * ny;

V = zeros(nx,ny);
G = sparse(N,N);

% Inclusion = 0;



for i = 1:nx
    for j = 1:ny
        n = j + (i-1)*ny;

        if i == 1 || i == nx || j == 1 || j == ny  % Boundary nodes
            G(n,n) = 1;

            %1+(j-1)*nx
        else
            % Bulk node finite difference equation
            nxp = j + i * ny; % (i+1, j)
            nxm = j + (i - 2) * ny; % (i-1, j)
            nyp = j+1 + (i - 1) * ny; % (i, j+1)
            nym = j-1 + (i - 1) * ny; % (i, j-1)

            G(n,n) = -4;
            G(n,nxp) = 1;
            G(n,nxm) = 1;
            G(n,nyp) = 1;
            G(n,nym) = 1;

            if i > 10 && i < 20 && j > 10 && j < 20
                G(n,n) = -2;
            else 
                G(n,n) = -4;
                G(n,nxp) = 1;
                G(n,nxm) = 1;
                G(n,nyp) = 1;
                G(n,nym) = 1;

            end
        end



    end
end


figure

figure('name','Matrix')
spy(G)

nmodes = 20;
[E,D] = eigs(G,nmodes,'SM');

figure('name','EigenValues')
plot(diag(D),'*');

np = ceil(sqrt(nmodes));
figure('name','Modes')
for k = 1:nmodes
    M = E(:,k);
    for i = 1:nx
        for j = 1:ny
            n = 1+(j-1)*nx;
            V(i,j) = M(n);
        end
        subplot(np,np,k),surf(V,'LineStyle','none')
        title(['EV = ' num2str(D(k,k))])
    end
end

