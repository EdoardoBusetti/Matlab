% test for the Crank Nicholson method to solve the diffusion equation using Von
% Newmann Boundary conditions
close all
clear;
clc

% Parameters to define the heat equation and the range in space and time
%       and to implement the Crank Nicholson Method

Lmax = 1;                 % Maximum length
Tmax = 1;                 % Maximum time 
D = 1;                    % Conductivivity of the material

Nt = 300;                 % Number of time steps
dt = Tmax/Nt;             % Time step
Nx = 300;                 % Number of space steps
dx = Lmax/Nx;             % Space step	
alpha = D*dt/(dx*dx);     % alpha parameter in the finite-difference implementation

%  Initial condition: the initial value of the u function
x = linspace(0,Lmax,Nx);
t = linspace(0,Tmax,Nt);

u = zeros(Nx,Nt);
u(:,1) = 1;  % u-> Space x Time -> (Nx x Nt)
%plot(x,u(:,1)) % Check the conditions

% Creating the initial matrices
% Right Matrix

% Left Matrix
ML_central =        diag(ones(1,Nx-1)*(2+2*alpha),0);
ML_right =          diag(ones(1,Nx-2)*(-alpha),1);
ML_left =           diag(ones(1,Nx-2)*(-alpha),-1);
Matrix_M_Left =     ML_left + ML_central + ML_right;

MR_central =        diag(ones(1,Nx-1)*(2-2*alpha),0);
MR_right =          diag(ones(1,Nx-2)*(alpha),1);
MR_left =           diag(ones(1,Nx-2)*(alpha),-1);
Matrix_M_Right =    MR_left + MR_central + MR_right;


%% Applying Von Newmann boundary conditions to the Matrices
% Left Matrix
Matrix_M_Left(1) =      Matrix_M_Left(1)             - alpha/(1+dx);
Matrix_M_Left(end) =    Matrix_M_Left(end)           - alpha/(1+dx);

% Right Matrix
Matrix_M_Right(1) =     Matrix_M_Right(1)            + alpha/(1+dx);
Matrix_M_Right(end) =   Matrix_M_Right(end)          + alpha/(1+dx);

%% Implementation of the Crank Nicholson method with Von Newmann boundaries
for j=1:Nt-1
    u(2:end,j+1) = (inv(Matrix_M_Left))*(Matrix_M_Right)*u(2:end,j);
end
% Readjusting the vector and matrix to be Nx-1
u = u(2:end,:);
x = x(2:end);


%% Answering the question:
%¿Cuanto tiempo debe transcurrir para que la temperatura 
%en el centro de la varilla alcance los 0.5◦ C?

for j = 1:Nt
    if u(round(Nx/2),j) <= 0.5
        u_index = j;
        break
    end
end
fprintf('Time for the center of the rod to reach 0.5C -->  %f seconds  \n',t(u_index))


%% Graphical representation of the wave at different selected times
%{
figure(1)
plot(x,u(:,1),'-b','LineWidth',2)
hold on
plot(x,u(:,40),'--g',x,u(:,80),':b',x,u(:,100),'-.r')
plot(x,u(:,u_index),'-k','LineWidth',2)
line([0 1], [0.5 0.5])
hold off

stri_end = sprintf('time t = %f  -> u(Nx/2,t) <= 0.5',t(u_index));
stri_1 = sprintf('time t = %i -> initial conditions',t(1));
stri_40 = sprintf('time t = %f ',t(40));
stri_80 = sprintf('time t = %f ',t(80));
stri_100 = sprintf('time t = %f ',t(100));

legend(stri_1,stri_40,stri_80,stri_100,stri_end,'Location','best')
title('Heat-equation using the Crank Nicholson Method with Von Newmann Boundaries')
xlabel('Length (meters)')
ylabel('Temperature (celsius)')
%}

%% mesh
%{
figure(2)
mesh(t,x,u)
xlabel('Time (seconds)')
ylabel('Length (meters)')
zlabel('Temperature (celsius)')
title('Heat-equation using the Crank Nicholson Method with Von Newmann Boundaries')

%}

%% Making an animated 2D .gif
%{
numfig = 3;
figure(numfig)
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'Animated_Heat_Equation_Crank_Nicholson.gif';

stringa = sprintf('Time t = 0 ');
for i = 1:Nt
    plot(x,u(:,i),'b','LineWidth',2)
    stringa = sprintf('Time t = %f ',t(i));
    title(stringa)
    xlabel('Space_m_t')
    ylabel('Degrees_C')
    clc
    fprintf('Percentage of completion : %f',i*100/Nt)
    axis([0 1 0 1])
    % Capture the plot as an image 
      frame = getframe(numfig); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if i == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end 
end
%}