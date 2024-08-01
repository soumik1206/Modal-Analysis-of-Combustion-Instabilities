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
%% Creating Snapshot matrix

load X_POD.mat
for i = 1:length(X)
   X(i,:) = X(i,:) - mean(X(i,:));
end

%% SVD of Snapshot matrix
[U,S,V] = svd(X,'econ');

%% Extracting mode dynamics

plot((cumsum(diag(S))/sum(diag(S))*100),'o-')
title('Percentage of Energy captured by modes')
xlabel('Modes')
ylabel('% Energy')
n = 1:100;
X_Pod = U(:,n)*S(n,n)*V(:,n)';

%% Plotting the dynamics

imagesc(reshape(U(:,n),1024,1024))
title('POD Mode 5')
colormap jet
colorbar

%%
M_Xdmd = max((X_Pod),[],'all');
m_Xdmd = min((X_Pod),[],'all');

videoFileName = 'H50 POD Reconstruction (1-100).avi';
writerObj = VideoWriter(videoFileName);
writerObj.FrameRate = 30;
open(writerObj);

for m = 1:600
    imagesc(reshape(X_Pod(:,m),1024,1024))
    title('H50 POD Reconstruction (1-100)')
    colormap jet 
    caxis([m_Xdmd,M_Xdmd])
    colorbar
    axis off
    frame = getframe(gcf); 
    writeVideo(writerObj, frame);
    pause(0.01)
end
close(writerObj);
%% FFT of POD modes

plot(V(:,5),'r');
title('Time variation of Mode 5')
xlabel('Time')
ylabel('Amplitude')
n = 1000;
fft_POD1 = fftshift(fft(V(:,5)));
frq = (1/0.2)*(0:n/2-1);
figure()
plot(frq,abs(fft_POD1(501:1000))/n,'b')
title('FFT of Mode 5')
ylabel('Power spectral density')
xlabel('Frequency')

