f = 4000; 
fs = 22050; 
fftLength=1024;             %windowlength 
x =sin(2*pi*f*[0:1/fs:1]);  %makethesinewave 
ft =fft(x,fftLength);       %doFFT,userect.window 
ftMag=abs(ft);              %computemagnitude 

% plot the results both in linear and dB magnitudes 

subplot(2, 1, 1), plot(ftMag) 
title('Linear Magnitude') 
ylabel('magnitude'), xlabel('bins') 

subplot(2, 1, 2), plot(20*log10(ftMag)) 
title('dB Magnitude') 
ylabel('dB'), xlabel('bins')