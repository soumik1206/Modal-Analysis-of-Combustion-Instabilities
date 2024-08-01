% %% loading the data
% h50 = load("h50_avg_P1.mat");
% P1_H50 = h50.avg;
% t = h50.t;

%frequncies = [244,115,93,99,107,119,216,216];
%%
pres = readtable('MethPressure.xlsx');

%%
DP1 = table2array(pres(:,1));
DP2 = table2array(pres(:,2));
t = 0:1/10000:60;
figure(1)
plot(t(1:2000),DP1(1:2000))%Plotting for first 0.2 sec
title("Dynamic Pressure 1 Methane")
xlabel('Time')
ylabel('Pressure')
figure(2)
plot(t(1:2000),DP2(1:2000))%Plotting for first 0.2 sec
title("Dynamic Pressure 2 Methane")
xlabel('Time')
ylabel('Pressure')
%%
[c1,lags1] = xcorr(DP1,DP1);
figure()
plot(lags1,c1/max(c1),'-r')
title('Autocorrelation of DP1')
% figure()
% plot(lags2,c2/max(c2),'-r')
% title('Autocorrelation of DP2')
%% Time delay embedding of pressure time series
load DP1H50.mat
% Time delay embedding of pressure time series
n = 2000;
X = zeros(n,length(DP1)-n+1);
for i = 1:n
        X(i,:) = DP1(i:end-n+i);
end
%% SVD of X
[ U1, S1, V1] = svd(X,'econ');
% [ U2, S2, V2] = svd(X2,'econ');
% figure(2)
plot((1:length(S1(1,:))),diag(S1),'o-')
title('Singular values of Hankel Matrix')
ylabel('Singular values')

%%
figure(3)
plot3(V1(1:2e3,1),V1(1:2e3,2),V1(1:2e3,3),'-r')
% h = animatedline('Linewidth',2,'Color','r');
% view(45,45)
% for k = 1:2e3
%     addpoints(h,V2(k,1),V2(k,2),V2(k,3))
%     drawnow
%     pause(0.001)
% end
title('Reconstructed Phase Space DP1 Methane')
xlabel('x1')
ylabel('x2')
zlabel('x3')

%% Recurrence plot
 R = zeros(2e3);
for i = 1:2e3
    v1 = [V1(i,1),V1(i,2),V1(i,3)];
    for j = 1:2e3
        v2 = [V2(j,1),V2(j,2),V2(j,3)];
        R(i,j) = norm(v1-v2);       
    end
end
figure(4)
imagesc(R)
colormap(flipud(gray))
set(gca,'YDir','Normal')
title('Recurrence plot DP1 H10')
xlabel('Time')
ylabel('Time')
%%  Freq from rec plot
r = R(1,:);
k = 0;
for i = 2:length(r)-1
    if r(i-1) > r(i) && r(i+1)>r(i)
        k = k+1;
    end
end

freq = k/0.2;