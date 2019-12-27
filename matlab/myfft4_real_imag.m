%% If need working only with Real and Imginary parts Comment lines started 
% with "Stage" in "New Stages" part and on the bottom whole figure(5)

%% FFT algoritm
clear;                      % clears all previus values from memory 
clc;                        % clear command window
fs =  44100;                % samplinf freq.
fftLength=256;              % windowlength 
stage_num = log2(fftLength);

while 1                     % Checking for correct "fftLength"-Wondow length value
if ~mod(stage_num,1)==0
    error('"fftLength"-Wondow length value must be a numer: 2^x= : 2, 4, 8, 16, 32,...');
    break
else
                            % continue working if value is correct
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

data = comp1 + comp2 + comp3;      % creates vector from 3 sin functions
%data = comp3;

% Plot shifting to center
bin_vals = [0 : fftLength-1];
N_2 = ceil(fftLength/2);
fax_kHz = (bin_vals-N_2)*fs/fftLength/1000;

freq3 = ceil(-(fftLength)/2:1:(fftLength)/2).*(fs/fftLength)/1000;

figure(1)               % plots separete sin functions
hold off,
%plot ( comp1, '-');
hold on;
%plot ( comp2, '-');
plot (comp3, '-')
xlim([1 50]), grid minor,;
title('Separete SIN functions') 
ylabel('magnitude'), xlabel('time') 
hold off;

figure(2)               % plots signal for fft
plot (data), grid minor,;
xlim([1 50])
title('Signal for FFT analysis FFT') 
ylabel('magnitude'), xlabel('time') 

figure(3)               % plots resultinf fft from Matlab functions
ft = fft(data,fftLength); 
ft1 = fftshift(ft);
ftMag = abs(ft1); 
plot (fax_kHz,ftMag), grid minor,
title('Linear Magnitude FFT') 
ylabel('magnitude'), xlabel('kHz') 

figure(4)               % plots resultinf fft(in dB) from Matlab functions
ft = fft(data,fftLength); 
ft1 = fftshift(ft);
ftMag = abs(ft1(1:fftLength)); 
plot (fax_kHz,20*log10(ftMag)), grid minor,
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

%  creating matrix arrays
%  create empty matrix arrays to store values in reverse bit order
stage = zeros(bits+1,fftLength);
real_n = zeros(bits+1,fftLength);
imag_n = zeros(bits+1,fftLength);

real_n_sfi = zeros(bits+1,fftLength);
imag_n_sfi = zeros(bits+1,fftLength);

%% Starting stages

for st = 0 : stage_num;
    if st == 0
       for tmp=1:fftLength;
            stage(st+1,tmp)  =  data(rev_bit_dec(tmp)+1);
            real_n(st+1,tmp)  =  data(rev_bit_dec(tmp)+1);
       end
    else st > 0;
        for n = 1 : fftLength/2;
                Wn(n)  = exp(-j * (n-1) * 2 * pi/ 2^(st) );
                Wr(n) = real(Wn(n));
                Wi(n) = imag(Wn(n));
        end
        for i = 1 : 2^st : fftLength;
                for k = 0 : 2^(st-1)-1;
                    % Even
                        stage(st+1,i+k) = stage(st,i+k) + Wn(k+1)*stage(st,i+k+2^(st-1));
                        real_n(st+1,i+k) = real_n(st,i+k) + Wr(k+1)*real_n(st,i+k+2^(st-1)) - Wi(k+1)*imag_n(st,i+k+2^(st-1));
                        imag_n(st+1,i+k) = imag_n(st,i+k) + Wi(k+1)*real_n(st,i+k+2^(st-1)) + + Wr(k+1)*imag_n(st,i+k+2^(st-1));
                    % Odd
                        stage(st+1,i+k+2^(st-1)) = stage(st,i+k) - Wn(k+1)*stage(st,i+k+2^(st-1));
                        real_n(st+1,i+k+2^(st-1)) = real_n(st,i+k) - Wr(k+1)*real_n(st,i+k+2^(st-1)) +  Wi(k+1)*imag_n(st,i+k+2^(st-1));
                        imag_n(st+1,i+k+2^(st-1)) = imag_n(st,i+k) - Wi(k+1)*real_n(st,i+k+2^(st-1)) - Wr(k+1)*imag_n(st,i+k+2^(st-1));
                end
        end
    end
end

%% Constructing signed fixed-point numeric objects

 for n = 1 : fftLength/2;
     Wr_sfi(n) = sfi(real(Wn(n)),16);
     Wi_sfi(n) = sfi(imag(Wn(n)),16);
 end

  for n = 1 : fftLength;
      for k = 1 : st + 1
        real_n_sfi(k,n) = sfi(real_n(k,n),24);
        imag_n_sfi(k,n) = sfi(imag_n(k,n),24);
      end
  end
 
%% Plotting out

% for slowly result plotting uncomment pause

figure(5)
for i = 1 : bits + 1;
    %plot( fax_kHz, abs( fftshift( real_n(i, :) + j.*imag_n(i,:) ) ) ),
    plot( fax_kHz, abs( fftshift( stage(i,:) ) ) ),
    grid minor, title('Linear Magnitude FFT'), ylabel('magnitude'), xlabel('kHz');
    %pause(1);
end

figure(6)
for i = 1 : bits + 1;
    plot( fax_kHz, abs( fftshift( real_n(i, :) + j.*imag_n(i,:) ) ) ),
    grid minor, title('Linear Magnitude FFT, ploted from Real + Imag'), ylabel('magnitude'), xlabel('kHz');
    %plot( fax_kHz, abs( fftshift( stage(i,:) ) ) ), grid minor,;
    %pause(1);
end

break
end
end
