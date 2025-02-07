for i = 1:ni
    for j = 1:nx
        for k = 1:ny
            if k == 1
                V(j,k) = 0;
                %V(j,k) = V(j,k+1);
            elseif k == 100
                V(j,k) = 0;
                % V(j,k) = V(j,k-1);
            else
                if j == 1
                    V(j,k) = 1;
                elseif j == 100
                    V(j,k) = 0;
                else
                    V(j,k) = (V(j+1,k)+V(j-1,k)+V(j,k-1)+V(j,k+1))/4;
                end
            end
        end

        %if mod(i,10)==0
       %     surf(V')
       %     pause(0.0001)
      %  end
    end
end

figure()
surf(V)
[Ex,Ey] = gradient(V);

figure
quiver(-Ey',-Ex',1)

