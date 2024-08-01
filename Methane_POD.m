close all;
addpath 'C:\Users\NITTTR7\Documents\Subham\IIsc Mtech\Practical Introduction to data analysis\Project\readimx-v2.1.9-win64'
Meth = zeros(1024,1024,1000);
for i = 1:1000
        k = "C:\Users\NITTTR7\Documents\Subham\IIsc Mtech\Practical Introduction to data analysis\Project\Shared File\Images\Methane\";
        if (i<=9)
        A = k+"B0000"+i+".im7";
        elseif (i>9 && i<=99)
        A = k+"B000"+i+".im7";
        elseif (i>99 && i<=999)
        A = k+"B00"+i+".im7";
        else 
        A = k+"B0"+i+".im7";
        end
    
    A = convertStringsToChars(A);
    B = readimx(A);
    
    C = B.Frames{1}.Components{1}.Planes{1};
%     imagesc(C)
%     title("Hydrogen 50")
%     axis off
%     pause(1/60)
    %exportgraphics(gca,"hydrogen10.gif","Append",true)
    Meth(:,:,i) = C;
end
% imagesc(H50(:,:,1))
% colormap hot

%% DMD Computations 
X = zeros(1024^2,1000);
for j = 1:size(Meth,3)
    X(:,j) = reshape(Meth(:,:,j),[],1);
end
%% pod
for i =1: 1024^2
    X(i,:) = X(i,:) - mean(X(i,:))*ones(1,1000);
end
%%
[U,S,V] = svd(X,'econ');
%% plot
imagesc(reshape(U(:,1),1024,1024));
colormap jet;
colorbar;
%% time
%temp = zeros(1024^2,1000);
temp = U(:,1:85)*S(1:85,1:85)*V(:,1:85)';
%%
videoFileName = 'MethFirst85ModesPOD.avi';
writerObj = VideoWriter(videoFileName);
writerObj.FrameRate = 30; % Set the frame rate (frames per second)
open(writerObj);

mi = min((temp),[],"all");
ma = max((temp),[],"all");
for i =1:1000
    M = reshape(temp(:,i),1024,1024);
    imagesc(M);
    colormap jet;
    caxis([mi,ma]);
    colorbar;
    axis off
    frame = getframe(gcf); % Capture the current figure as a frame
    writeVideo(writerObj, frame);
    pause(0.01);
end    
close(writerObj);
%% FFT of V

figure(2)
N = length(V(:,1));
frequencies = (-N/2:N/2-1)/0.2;
pos_val = round(N/2+1):N;
F = fftshift(fft(V(:,4)));
F_mag = abs(F)/(N/2);
plot(frequencies(pos_val),F_mag(pos_val));
title('FFT spectrum for 4th mode of methane ');
xlabel('frequencies');
ylabel('Amplitude');
