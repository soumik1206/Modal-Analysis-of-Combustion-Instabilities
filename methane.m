close all;

ch4 = zeros(1024,1024,1000);

for i = 1:1000
        k = "D:\Engineering Books, PDFs & Lectures\IISc , M.Tech\ME 278 Practical Introduction to data analysis\Data Project\Shared File\Images\Methane\";
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

    ch4(:,:,i) = C;
    % imagesc(C)
    % title("Methane")
    % axis off
    % pause(1/60)
    %exportgraphics(gca,"methane.gif","Append",true)
end

%% Time average
avg = zeros(1,1000);

dt = 1/5000;
tEnd = 1000*dt-dt;
t = 0:dt:1000*dt-dt;

for i = 1:1000
    avg(1,i) = mean(ch4(100:700,1:700,i),"all");
end

avg_wo_mean = avg-mean(avg)*ones(1,1000);

avg_fft = fftshift(fft(avg_wo_mean));

f = (-499:500)/tEnd;

R = 500:1000;

figure(1)

subplot(211)
plot(t,avg); axis tight
title("Time averaged values from images near P1 probe")
xlabel("time (s)")

subplot(212)
plot(f(R),abs(avg_fft(R))/500); axis tight
title("FFT of Time averaged values")
xlabel("Frequency (Hz)")

sgtitle('Methane Data', 'fontsize',18)

%% wavelet

[cfs_ch4,frq_ch4] = cwt(avg,"morse",5000);

figure(2)
subplot(111)
surface(t,frq_ch4,abs(cfs_ch4));
title("Wavelet Transform of Time averaged values of Methane near P1 probe", 'fontsize',18)
ylabel("Frequency (Hz)", 'fontsize',15)
xlabel("time (s)", 'fontsize',15)
shading flat
axis tight
set(gca,"yscale","log")
colormap jet