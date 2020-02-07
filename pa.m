function [] = pa()
clear
clc
close all

nx = 50;
ny = 50;
alpha = 1;

 G = sparse(ny*nx,nx*ny);
 for n = 1:nx*ny
     [currY,currX] = getPosSpace(nx,n);
     if currY > 1 && currX > 1 && currX < nx && currY < ny %if in the middle for position space
         if currX >= 10 && currX <= 20 && currY >= 10 && currY <= 20
            G = assignG(G,n,nx,ny,currY,currX,-2);
         else
              G = assignG(G,n,nx,ny,currY,currX,-4);
         end
         G = assignG(G,n,nx,ny,currY-1,currX,1);
         G = assignG(G,n,nx,ny,currY+1,currX,1);
         G = assignG(G,n,nx,ny,currY,currX-1,1);
         G = assignG(G,n,nx,ny,currY,currX+1,1);
     else %if boundary
         G = assignG(G,n,nx,ny,currY,currX,1); 
     end
 end
[E,D] = eigs(G,9,'SM');
figure;
plot(diag(D))

figure
for n = 1:9
    currE = squeeze(E(:,n));
    currE = reshape(currE,[ny,nx])';
    figure
    surf(currE);
end
end

function [G] = assignG(G,row,nx,ny,assY,assX,val)
    eq = getEqSpace(nx,assY,assX);
    if eq <= 0 || eq > nx*ny
       return; 
    end
    G(row,eq) = val;
end

function [eq] = getEqSpace(nx,yPos,xPos)
eq = xPos + (yPos-1)*nx;
end

function [yPos,xPos] = getPosSpace(nx,eq)
xPos = mod(eq-1,nx)+1;
yPos = floor((eq-1)/nx) + 1;
end