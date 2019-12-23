%% FFT algoritm
clear;                      % clears all previus values from memory 
clc;                        % clear command window
fs =  44100;                % samplinf freq.
fftLength=512;              % windowlength 
stage_num = log2(fftLength);
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
Length = length(comp3);
% calculatin vector values for step function
d1 = ones(1, 24);
d2 = 0.*ones(1, 1000 );

%data = [ d1 , d2];                  % creates vector with step function
data = comp1 + comp2 + comp3;      % creates vector from 3 sin functions
%data = comp3;

% Grafika nobiides
bin_vals = [0 : fftLength-1];
N_2 = ceil(fftLength/2);
fax_kHz = (bin_vals-N_2)*fs/fftLength/1000;

freq3 = ceil(-(fftLength)/2:1:(fftLength)/2).*(fs/fftLength)/1000;

figure(1)               % plots separete sin functions
hold off,
%plot ( comp1, '-');
hold on;
%plot ( comp2, '-');
plot ( comp3, '-'), grid minor,;
%xlim([1 50])
title('Separete SIN functions') 
ylabel('magnitude'), xlabel('time') 
hold off;

figure(2)               % plots signal for fft
plot ( data), grid minor,;
xlim([1 50])
title('Signal for FFT analysis FFT') 
ylabel('magnitude'), xlabel('time') 
%xlim([1 100])

figure(3)               % plots resultinf fft from Matlab functions
ft =fft(data,fftLength); 
ft1 = fftshift(ft);
ftMag = abs(ft1); 
plot (fax_kHz,ftMag), grid minor,
title('Linear Magnitude FFT') 
ylabel('magnitude'), xlabel('kHz') 

figure(4)               % plots resultinf fft(in dB)  from Matlab functions
ft = fft(data,fftLength+1); 
ftMag = abs(ft(1:fftLength+1)); 
plot (freq3,20*log10(ftMag)), grid minor,
title('dB Magnitude') 
ylabel('dB'), xlabel('kHz') 

%% Data preparation for FFT

% reverse bit calulation
bits = length(dec2bin( fftLength - 1 ));    % how many bits in binary number
rev_bit_dec = zeros(1,fftLength);           % create vektor size of fftlength

stage = 1;              %Do it here for stage #1 
c = 0:fftLength-1;
c_bin = de2bi(c);       % create binary table
rev_bit_dec = bi2de(fliplr(circshift(c_bin',stage-1)'));    %Rotate binary table and convert to dec

%  creating array
%  create empty array to store values in reverse bit order
stage = zeros(bits + 1,fftLength);

%% New stages

for st = 0 : stage_num;
    if st == 0
       for tmp=1:fftLength;
            stage(st+1,tmp)  =  data(rev_bit_dec(tmp)+1);
       end
    else st > 0;
        for n = 1 : fftLength/2;
                Wn(n)  = exp(-j * (n-1) * 2 * pi/ 2^(st) );
        end
        for i = 1 : 2^st : fftLength;
                for k = 0 : 2^(st-1)-1;
                    % Even
                        stage(st+1,i+k) = stage(st,i+k) + Wn(k+1)*stage(st,i+k+2^(st-1));
                    % Odd
                        stage(st+1,i+k+2^(st-1)) = stage(st,i+k) - Wn(k+1)*stage(st,i+k+2^(st-1));
                end
        end
    end
end

%% Ploting out
% slowly plot result
figure(5)
for i = 1 : bits + 1;
    %plot( abs( real_n(i, :) + j.*imag_n(i,  :) ) );
        plot( fax_kHz, abs( fftshift( stage(i,:) ) ) ), grid minor,;
    pause(1);
end

title('Linear Magnitude FFT') 
ylabel('magnitude'), xlabel('kHz') 
