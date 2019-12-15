f = 4300; 
fs =  44100; 
fftLength=512;             % windowlength 
x =sin(2*pi*1000*[0:1/fs:1]) + sin(2*pi*f*[0:1/fs:1])  +  sin(2*pi*20000*[0:1/fs:1]);  % makethesinewave 
ft =fft(x,fftLength);       % doFFT,userect.window 
ftMag=abs(ft(1:fftLength/2));          % computemagnitude ( half )

% plot the results both in linear and dB magnitudes 

subplot(2, 1, 1), plot(ftMag) 
title('Linear Magnitude') 
ylabel('magnitude'), xlabel('kHz') 

xt = xticks;        % returns the current x-axis tick values as a vector
fstep = fs/fftLength;       % tick of f axis in f domain 
xtnew = round(xt*fstep)/1000 ;   % calculate new tick in kHz
xticklabels(xtnew)      % set new tick labels
 
subplot(2, 1, 2), plot(20*log10(ftMag)) 
title('dB Magnitude') 
ylabel('dB'), xlabel('kHz')

xt = xticks;        % returns the current x-axis tick values as a vector
fstep = (fs/fftLength);       % tick of f axis in f domain 
xtnew = round(xt*fstep)/1000;   % calculate new tick in kHz
xticklabels(xtnew)        % set new tick labels

    
