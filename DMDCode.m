close all;
addpath 'D:\Matlab\bin\readimx-v2.1.9-win64'
X = zeros(1024^2,1000);
for i = 1:1000
        if (i<=9)
        A = "B0000"+i+".im7";
        elseif (i>9 && i<=99)
        A = "B000"+i+".im7";
        elseif (i>99 && i<=999)
        A = "B00"+i+".im7";
        else 
        A = "B0"+i+".im7";
        end
    
    A = convertStringsToChars(A);
    B = readimx(A);
    
    C = B.Frames{1}.Components{1}.Planes{1};
%     imagesc(C)
%     title("Hydrogen 50")
%     axis off
%     pause(1/60)
    %exportgraphics(gca,"hydrogen10.gif","Append",true)
    X(:,i) = reshape(C,1024^2,1);

end

% imagesc(H50(:,:,1))
% colormap hot

%% DMD Computations 

% X = zeros(1024^2,1000);
% for j = 1:size(H50,3)
%     X(:,j) = reshape(H50(:,:,j),[],1);
% end
X1 = X(:,1:end-1);
% X2 = X(:,2:end);

for i = 1:length(X1)
    X1(i,:) = X1(i,:) - mean(X1(i,:));
end

%% SVD

[U1,S1,V1] = svd(X1,'econ'); 
plot((1:size(S1,1)),diag(S1),'o-')

[U2,S2,V2] = svd(X2,'econ'); 
figure()
plot((1:size(S2,1)),diag(S2),'o-')

%% Model reduction

r = 10;%Rank approximation
 
%Forward
U1r = U1(:,1:r);
S1r = S1(1:r,1:r);
V1r = V1(:,1:r);

%Backward
U2r = U2(:,1:r);
S2r = S2(1:r,1:r);
V2r = V2(:,1:r);

%% Forward-Backward Linear operator

A_ft = U1r'*X2*V1r/S1r;
A_bt = U2r'*X1*V2r/S2r;

%% Modified noiseless A_tilde

A_n = sqrtm(A_ft*inv(A_bt));
% Eigendecomposition of A_t
[W,Lam] = eig(A_n);
% Computing DMD modes
X2 = load('X2_Meanless.mat').X2;
phi = X2*(V1r/S1r)*W;%DMD modes
x1_t = S1r*V1r(1,:)';
b = (W*Lam)\x1_t;

%% Plotting DMD Modes

dt = 1/5000;
lambda = diag(Lam); 
[lambda_sorted,idx] = sort(abs(lambda),'descend');
w = log(lambda)/dt;
n = size(X2,2);
t= (0:n-1)*dt;

%% Plotting

yr = real(exp(w(5)*t));
yi = imag(exp(w(5)*t));
figure(1)
plot(t,yr,'-r')
figure(2)
plot(t,yi,'-b')

%% DMD mode plots
figure(3)
imagesc(reshape(real(phi(:,1)),1024,1024))
colormap 
figure(4)
imagesc(reshape(imag(phi(:,1)),1024,1024))
colormap 

%% Time dynamics
dt = 1/5000;
time_dynamics = zeros(10,600);
t= (0:n-1)*dt;
for k = 1:600
    time_dynamics(:,k)=(b.*exp(w*t(k)));
end
%%
figure() 
plot(t(1:600),real(time_dynamics(9,:)),'b')
title('Time dynamics of Mode 9')
xlabel('Time')
ylabel('Amplitude')
%% DMD reconstruction

X_dmd = phi(:,1:4)*time_dynamics(1:4,:);
M_Xdmd = max(real(X_dmd),[],'all');
m_Xdmd = min(real(X_dmd),[],'all');

%% DMD Mode time evolution
figure(5)
videoFileName = 'H50_DMD_recon_Mode_1-4).avi';
writerObj = VideoWriter(videoFileName);
writerObj.FrameRate = 20;
open(writerObj);
for m = 1:600
    H50_Rec = reshape(X_dmd(:,m),1024,1024);
    imagesc(real(H50_Rec))
    colormap jet
    caxis([m_Xdmd,M_Xdmd])
    colorbar
    axis off
    frame = getframe(gcf);
    writeVideo(writerObj, frame);
    pause(0.001)    
end
close(writerObj);

%%
figure(6)
plot(real(w),imag(w),'ro')
title('Continuous time eigenvalues in complex plane')
xlabel('Re(w)')
ylabel('Im(w)')


    
      