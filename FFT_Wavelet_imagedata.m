load('H50_img.mat')
load('H10_img.mat')
load('H0_img.mat')
M50_p1=M50_p1-mean(M50_p1);
M50_p2=M50_p2-mean(M50_p2);
M10_p1=M10_p1-mean(M10_p1);
M10_p2=M10_p2-mean(M10_p2);
M0_p1=M0_p1-mean(M0_p1);
M0_p2=M0_p2-mean(M0_p2);
t=linspace(0,0.2,1001); t=t(1:end-1);
FFT50_p1 = abs(fftshift(fft(M50_p1)))/500;   % FFT
FFT50_p2 = abs(fftshift(fft(M50_p2)))/500;
FFT10_p1 = abs(fftshift(fft(M10_p1)))/500;
FFT10_p2 = abs(fftshift(fft(M10_p2)))/500;
FFT0_p1 = abs(fftshift(fft(M0_p1)))/500;
FFT0_p2 = abs(fftshift(fft(M0_p2)))/500;
f=(-500:499)/0.2;
%%  Ploting time series= FFT
figure
subplot(3,1,1)
plot(f(501:1000) , FFT0_p1(501:1000) ,'b' , LineWidth = 1)
title("Heat release rate in p1 sensor region(Methane)")
xlabel("Frequency")
ylabel("Amplitude")
subplot(3, 1, 2)
plot(f(501:1000),FFT10_p1(501:1000),'k',LineWidth=1)
title("Heat release rate in p1 sensor region(Hydrogen 10)")
xlabel("Frequency")
ylabel("Amplitude")
subplot(3,1,3)
plot(f(501:1000),FFT50_p1(501:1000),'r',LineWidth=1)
title("Heat release rate in p1 sensor region(Hydrogen 50)")
xlabel("Frequency")
ylabel("Amplitude")
%%  FFT

figure
subplot(3,1,1)
plot(f(501:1000),FFT0_p2(501:1000),'b',LineWidth=1)
title("Heat release rate in p2 sensor region(Methane)")
xlabel("Frequency")
ylabel("Amplitude")
subplot(3,1,2)
plot(f(501:1000),FFT10_p2(501:1000),'k',LineWidth=1)
title("Heat release rate in p2 sensor region(Hydrogen 10)")
xlabel("Frequency")
ylabel("Amplitude")
subplot(3,1,3)
plot(f(501:1000),FFT0_p2(501:1000),'r',LineWidth=1)
title("Heat release rate in p2 sensor region(Hydrogen 50)")
xlabel("Frequency")
ylabel("Amplitude")

%%
a50=sum(FFT50_p2>30);
a10=sum(FFT10_p2>30);
a0=sum(FFT0_p2>30);  %No of frequencies greater than 20 unit amp
%% methane,HYD 10,HYD 50 CWT
[wt0_p1,fw0_p1] = cwt(M0_p1,5000);  %p1
[wt0_p2,fw0_p2] = cwt(M0_p2,5000);  %p2
[wt10_p1,fw10_p1] = cwt(M10_p1,5000);
[wt10_p2,fw10_p2] = cwt(M10_p2,5000);
[wt50_p1,fw50_p1] = cwt(M50_p1,5000);
[wt50_p2,fw50_p2] = cwt(M50_p2,5000);
%% Plotting Wavelet
figure
title("Methane: P1 sensor region")
waveletplot(t,fw0_p1,wt0_p1)
figure
title("Hyd10: P1 sensor region")
waveletplot(t,fw10_p1,wt10_p1)
figure
title("Hyd50: P1 sensor region")
waveletplot(t,fw50_p1,wt50_p1)

figure
title("Methane: P2 sensor region")
waveletplot(t,fw0_p2,wt0_p2)
figure
title("Hyd10: P2 sensor region")
waveletplot(t,fw10_p2,wt10_p2)
figure
title("Hyd50: P2 sensor region")
waveletplot(t,fw50_p2,wt50_p2)

%% Time Series
figure
subplot(3,1,1)
plot(M0_p1,'r',LineWidth=0.7)
title("Heat release rate in p1 sensor region(Methane)")
xlabel("time")
ylabel("Heat release rate")
subplot(3,1,2)
plot(M10_p1,'k',LineWidth=0.7)
title("Heat release rate in p1 sensor region(Hydrogen 10)")
xlabel("time")
ylabel("Heat release rate")
subplot(3,1,3)
plot(M50_p1, 'b' , LineWidth = 0.7)
title("Heat release rate in p1 sensor region(Hydrogen 50)")
xlabel("time")
ylabel("Heat release rate")
%%
figure
subplot(3,1,1)
plot(M0_p2,'r',LineWidth=0.7)
title("Heat release rate in p2 sensor region(Methane)")
xlabel("time")
ylabel("Heat release rate")
subplot(3,1,2)
plot(M10_p2,'k',LineWidth=0.7)
title("Heat release rate in p2 sensor region(Hydrogen 10)")
xlabel("time")
ylabel("Heat release rate")
subplot(3,1,3)
plot(M50_p2, 'b' , LineWidth = 0.7)
title("Heat release rate in p2 sensor region(Hydrogen 50)")
xlabel("time")
ylabel("Heat release rate")

spectrogram(M50_p2, 320, [], [], 5000,'yaxis')








function waveletplot(t,fw,wt)
surface(t,fw,abs(wt));
shading flat
axis tight
set(gca,'yscale','log')

xlabel("Time")
ylabel("Frequency")
colormap jet
colorbar
end