H10_table = readtable('C:\Users\NITTTR7\Documents\Subham\IIsc Mtech\Practical Introduction to data analysis\Project\Shared File\Pressure Data\Hydrogen10.xlsx');
h10_arr = table2array(H10_table);
H50_table = readtable('C:\Users\NITTTR7\Documents\Subham\IIsc Mtech\Practical Introduction to data analysis\Project\Shared File\Pressure Data\Hydrogen50.xlsx');
h50_arr = table2array(H50_table);
Methane_table = readtable('C:\Users\NITTTR7\Documents\Subham\IIsc Mtech\Practical Introduction to data analysis\Project\Shared File\Pressure Data\Methane.xlsx');
methane_arr = table2array(Methane_table);
%% time
fs = 10000;
dt = 1/fs;
t = 0:dt:0.2;
t = t';
%% Pressure data
methane_P2 = methane_arr(1:length(t),2);
h50_P2 = h50_arr(1:length(t),2);
h10_P2 = h10_arr(1:length(t),2);
%% Mean removed
methane_P2 = methane_P2-mean(methane_P2)*ones(length(methane_P2),1);
h50_P2 = h50_P2-mean(h50_P2)*ones(length(h50_P2),1);
h10_P2 = h10_P2-mean(h10_P2)*ones(length(h10_P2),1);
%% Denoising data 
h10_P1f = sgolayfilt(h10_P2,15,201);
h50_P1f = sgolayfilt(h50_P2,15,201);
methane_P1f = sgolayfilt(methane_P2,15,201);

figure(1)
subplot(3,2,1)
plot(t,h10_P2);
title('Actual data of H10');
xlabel('time');
ylabel('Pressure P2 of H10')

subplot(3,2,2)
plot(t,h10_P1f);
title('Noiseless data H10');
xlabel('time');
ylabel('Pressure P2 of H10')

subplot(3,2,3)
plot(t,h50_P2);
title('Actual data of H50');
xlabel('time');
ylabel('Pressure P2 of H50')

subplot(3,2,4)
plot(t,h50_P1f);
title('Noiseless data of H50');
xlabel('time');
ylabel('Pressure P2 of H50')


subplot(3,2,5)
plot(t,methane_P2);
title('Actual data of Methane');
xlabel('time');
ylabel('Pressure P2 of Methane')

subplot(3,2,6)
plot(t,methane_P1f);
title('Noiseless data of Methane');
xlabel('time');
ylabel('Pressure P2 of Methane')
%% FFT

N = length(h10_P2);
frequencies = (-N/2:N/2-1)/0.2;
pos_val = round(N/2+1):N;

figure(2)
subplot(3,1,1);
F_h10 = fftshift(fft(h10_P2));
F_mag_h10 = abs(F_h10)/(N/2);
plot(frequencies(pos_val),F_mag_h10(pos_val),'r','LineWidth',1);
title('FFT spectrum for H10 dynamic pressure P1 ');
xlabel('frequencies');
ylabel('Amplitude');


subplot(3,1,2);
F_h50 = fftshift(fft(h50_P2));
F_mag_h50 = abs(F_h50)/(N/2);
plot(frequencies(pos_val),F_mag_h50(pos_val),'k','LineWidth',1);
title('FFT spectrum for H50 dynamic pressure P1 ');
xlabel('frequencies');
ylabel('Amplitude');


subplot(3,1,3);
F_methane = fftshift(fft(methane_P2));
F_mag_methane = abs(F_methane)/(N/2);
plot(frequencies(pos_val),F_mag_methane(pos_val),'b','LineWidth',1);
title('FFT spectrum for methane dynamic pressure P1 ');
xlabel('frequencies');
ylabel('Amplitude');
%% Number of peaks
peak_h10_P2 = sum(F_mag_h10(pos_val)>0.2);
peak_h50_P2 = sum(F_mag_h50(pos_val)>0.2);
peak_methane_P2 = sum(F_mag_methane(pos_val)>0.2);
%% Spectrogram
figure(3)
spectrogram(h10_P2,1500,[],[],10000,'yaxis');
colormap jet;
set(gca,'FontSize',18,'Linewidth',1.5);
title("Spectrogram of P1, Hydrogen10");
%% Wavelet transform
[h10_P2_wt,h10_P2_freq] = cwt(h10_P2,10000);
[h50_P2_wt,h50_P2_freq] = cwt(h50_P2,10000);
[methane_P2_wt,methane_P2_freq] = cwt(methane_P2,10000);


figure(4)
surface(t,h10_P2_freq,abs(h10_P2_wt));
shading flat
axis tight
set(gca,"yscale","log")
colormap jet
title('scalogram of P2 data for Hydrogen 10');
colorbar

figure(5)
surface(t,h50_P2_freq,abs(h50_P2_wt));
shading flat
axis tight
set(gca,"yscale","log")
colormap jet
title('scalogram of P2 data for Hydrogen 50');
colorbar

figure(6)
surface(t,methane_P2_freq,abs(methane_P2_wt));
shading flat
axis tight
set(gca,"yscale","log")
colormap jet
title('scalogram of P2 data for Methane');
colorbar