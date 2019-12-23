%% FFT algoritm
clear;                      % clears all previus values from memory 
clc;                        % clear command window
fs =  44100;                % samplinf freq.
fftLength=16;              % windowlength 
% signal frequencies
max = 2048 - 1 ;

f1 = 430;
a1 = 0;

f2 = 4300;
a2 = 0;

f3 = 8000;
a3 = max/2;

% calculating signals 
comp1 = a1 * sin(2*pi*f1*[0:1/fs:1]);
comp2 = a2 * sin(2*pi*f2*[0:1/fs:1]);
comp3 = a3 * sin(2*pi*f3*[0:1/fs:1]);

% calculatin vector values for step function
d1 = ones(1, 24);
d2 = 0.*ones(1, 1000 );

%data = [ d1 , d2];                  % creates vector with step function
data = comp1 + comp2 + comp3;      % creates vector from 3 sin functions

figure(1)               % plots separete sin functions
plot ( comp1, '-');
hold on;
plot ( comp2, '-');
plot ( comp3, '-');
xlim([1 50])
title('Separete SIN functions') 
ylabel('magnitude'), xlabel('time') 
hold off;

figure(2)               % plots signal for fft
plot ( data);
title('Signal for FFT analysis FFT') 
ylabel('magnitude'), xlabel('time') 
xlim([1 100])

figure(3)               % plots resultinf fft from Matlab functions
ft =fft(data,fftLength); 
ftMag=abs(ft(1:fftLength/2)); 
plot (ftMag)
title('Linear Magnitude FFT') 
ylabel('magnitude'), xlabel('kHz') 

xt = xticks;        % returns the current x-axis tick values as a vector
fstep = fs/fftLength;       % tick of f axis in f domain 
xtnew = round((xt-1)*fstep/1000, 1) ;   % calculate new tick in kHz
xticklabels(xtnew)      % set new tick labels

figure(4)               % plots resultinf fft(in dB)  from Matlab functions
ft =fft(data,fftLength); 
ftMag=abs(ft(1:fftLength/2)); 
plot (20*log10(ftMag))
title('dB Magnitude') 
ylabel('dB'), xlabel('kHz') 

xt = xticks;        % returns the current x-axis tick values as a vector
fstep = fs/fftLength;       % tick of f axis in f domain 
xtnew = round((xt-1)*fstep/1000, 1) ;   % calculate new tick in kHz
xticklabels(xtnew)      % set new tick labels

%% Data preparation for FFT

% reverse bit calulation
bits = length(dec2bin( fftLength - 1 ));    % how many bits in binary number
rev_bit_dec = zeros(1,fftLength);           % create vektor size of fftlength

for i=1:fftLength
    bin_num = dec2bin(i-1 , bits);          % converting to binary number
    rev_bit = [];                           % create empty vector
    for k=bits:-1:1
       rev_bit = [rev_bit , bin_num(k)];
    end
    rev_bit_dec(i) = bin2dec(rev_bit) ;     % add 1 to match Matlab numbering   
end

%  creating array
%  create empty array to store values in reverse bit order
stage = zeros(bits + 1,fftLength);

for i=1:fftLength
     stage(1,i)  =  data(rev_bit_dec(i)+1);
end

%% First stage

for i = 1 : 2^1 : fftLength 
    % Even
    stage(2,i)    = stage(1,i) + stage(1,i+1);
    % Odd
    stage(2,i+1)  = stage(1,i) - stage(1,i+1);
    
end

%% Second stage

% Calculating W twiddling factor 
for i = 1 : 2 
    Wn(i)  = exp(-j * (i-1) * 2 * pi/ 4 );
end

% calculate next stage values
for i = 1 : 2^2 : fftLength 
    % Even pair
        stage(3,i+0)   = stage(2,i+0) + Wn(1)*stage(2,i+2); 
        stage(3,i+1)   = stage(2,i+1) + Wn(2)*stage(2,i+3); 
    % Odd par
        stage(3,i+2)   = stage(2,i+0) - Wn(1)*stage(2,i+2); 
        stage(3,i+3)   = stage(2,i+1) - Wn(2)*stage(2,i+3); 
end

%% Therd stage

% Calculating W twiddling factor 
for i = 1 : 4 
    Wn(i)  = exp(-j * (i-1) * 2 * pi/ 8 );
end

% calculate next stage values
for i = 1 : 2^3 : fftLength 
    for k = 0 : 3
        % Even pair
        stage(4,i+k)   = stage(3,i+k) + Wn(k+1)*stage(3,i+k+4);   
        % Odd par
        stage(4,i+k+4) = stage(3,i+k) - Wn(k+1)*stage(3,i+k+4); 
    end
end

%% 4th stage  

% Calculating W twiddling factor 
for i = 1 : 8 
    Wn(i)  = exp(-j * (i-1) * 2 * pi/ 16 );
end

% calculate next stage values
for i = 1 : 2^4 : fftLength 
    for k = 0 : 7
        % Even pair
        stage(5,i+k)    = stage(4,i+k) + Wn(k+1)*stage(4,i+k+8);     
        % Odd par
        stage(5,i+k+8)  = stage(4,i+k) - Wn(k+1)*stage(4,i+k+8);  
    end
end

%% Ploting out
% slowly plot result
figure(5)
for i = 1 : bits +1
    %plot( abs( real_n(i, :) + j.*imag_n(i,  :) ) );
    plot( abs( stage(i,:) ) );
    pause(1);
end
xt = xticks;        % returns the current x-axis tick values as a vector
fstep = fs/fftLength;       % tick of f axis in f domain 
xtnew = round(xt*fstep)/1000 ;   % calculate new tick in kHz
xticklabels(xtnew)      % set new tick labels
