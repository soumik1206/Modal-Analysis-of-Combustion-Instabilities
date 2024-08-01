close all;

H10_snapshot = zeros(1024^2,1000);
for i = 1:1000
        k = "D:\Engineering Books, PDFs & Lectures\IISc , M.Tech\ME 278 Practical Introduction to data analysis\Data Project\Shared File\Images\Hydrogen10\";
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

    %H10(:,:,i) = C;
    H10_snapshot(:,i) = reshape(C,1024^2,1);
end

%% subtracting mean
for i = 1:1024^2   
    H10_snapshot(i,:) = H10_snapshot(i,:) - mean(H10_snapshot(i,:))*ones(1,1000);
end
%% SVD
tic
[U,S,V]=svd(H10_snapshot,'econ');
toc

%% Singular Values

plot(cumsum(diag(S))/sum(diag(S))*100);
ylabel("Percentage of energy captured by singular values")
title("Cumulative sum of singular values")
set(gca,"Fontsize",18);

%% POD
figure(1)
subplot(221)
imagesc(reshape(U(:,1),1024,1024));
colormap jet
colorbar
title("H10 1st POD Mode","Fontsize",18)

subplot(222)
imagesc(reshape(U(:,5),1024,1024));
colormap jet
colorbar
title("H10 5th POD Mode","Fontsize",18)

subplot(223)
imagesc(reshape(U(:,10),1024,1024));
colormap jet
colorbar
title("H10 10th POD Mode","Fontsize",18)

subplot(224)
imagesc(reshape(U(:,15),1024,1024));
colormap jet
colorbar
title("H10 15th POD Mode","Fontsize",18)

%% time dyn
r = 85;
temp = U(:,1:r)*S(1:r,1:r)*V(:,1:r)';

%%
m = min(temp,[],"all");
M = max(temp,[],"all");

%% time dyn
% 1st mode
POD1 = U(:,1)*S(1,1)*V(:,1)';
%%
for i = 1:1000
    imagesc(reshape(POD1(:,i),1024,1024));
    title("1st POD mode Time Dynamics",FontSize=18);
    colormap jet
    colorbar
    clim([min(POD1,[],"all") max(POD1,[],"all")])
    pause(0.01)
    exportgraphics(gca,"h10POD1.gif","Append",true);
end
%% Reconstruction
for i = 1:1000
    imagesc(reshape(temp(:,i),1024,1024));
    title("Reconstruction of data upto 85th mode",FontSize=18);
    colormap jet
    colorbar
    clim([m M])
    pause(0.01)
    exportgraphics(gca,"h10reconstruction.gif","Append",true);
end