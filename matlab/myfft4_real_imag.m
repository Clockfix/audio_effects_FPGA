%% If need working only with Real and Imginary parts Comment lines started 
% with "Stage" in "New Stages" part and on the bottom whole figure(5)

%% FFT algoritm
clear;                      % clears all previus values from memory 
clc;                        % clear command window
fs =  44100;                % samplinf freq.
fftLength=2^9;              % windowlength 
stage_num = log2(fftLength);
Wn_word = 12;                % signed fixed point lenght for Wn (fraction is word-2)
samp_word = 8;               % word lenght of samped signal (fraction is word-2)
w_bits = 10;                 % signed fixed point integer bit lenght
f_bits = 10;                 % signed fixed point integer bit lenght for calculations

                           
% reading input audio file
% audio samples are from matlab examples
% load handel.mat
% filename = 'handel.wav';
% load gong.mat;
filename = 'gong.wav';
% audiowrite(filename,y,Fs);
[y,fs] = audioread(filename);
data = sfi(y, samp_word, samp_word-2); 
m = 7;                          % alow select section of signal for FFT
data_cut = data(fftLength*m+1:fftLength*m+fftLength);
%sound(data.double,fs);

figure(2)               % plots signal for fft
plot (data_cut), grid minor,
% xlim([fftLength*m+1 fftLength*m+fftLength])
title('Signal for FFT analysis FFT') 
ylabel('magnitude'), xlabel('time') 


bin_vals = [0 : fftLength-1];

figure(3)               % plots resultinf fft from Matlab functions
ft = fft(data_cut.double,fftLength); 
ft1 = fftshift(ft);
ftMag = abs(ft1); 
plot (bin_vals,ftMag), grid minor,
title('Linear Magnitude FFT') 
ylabel('magnitude'), xlabel(' ') 

% figure(4)               % plots resultinf fft(in dB) from Matlab functions
% ft = fft(data.double,fftLength); 
% ft1 = fftshift(ft);
% ftMag = abs(ft1(1:fftLength)); 
% plot (bin_vals,20*log10(ftMag)), grid minor,
% title('dB Magnitude') 
% ylabel('dB'), xlabel(' ') 

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

for st = 0 : stage_num
    if st == 0
       for tmp=1:fftLength
            stage(st+1,tmp)  =  data_cut(rev_bit_dec(tmp)+1);
            real_n(st+1,tmp)  =  data_cut(rev_bit_dec(tmp)+1);
            real_n_sfi(st+1,tmp) = sfi(real_n(st+1,tmp),f_bits  +  w_bits ,f_bits);
       end
    else st > 0;
        for n = 1 : fftLength/2
                Wn(n)  = exp(-j * (n-1) * 2 * pi/ 2^(st) );
%                 Wr(n) = real(Wn(n));
%                 Wi(n) = imag(Wn(n));
                Wr(n) = sfi(real(Wn(n)),Wn_word,Wn_word-2);
                Wi(n) = sfi(imag(Wn(n)),Wn_word,Wn_word-2);
        end
        for i = 1 : 2^st : fftLength
                for k = 0 : 2^(st-1)-1
                    % Even
                        stage(st+1,i+k) = stage(st,i+k) + Wn(k+1)*stage(st,i+k+2^(st-1));
                        real_n(st+1,i+k) = real_n_sfi(st,i+k) + Wr(k+1)*real_n_sfi(st,i+k+2^(st-1)) - Wi(k+1)*imag_n_sfi(st,i+k+2^(st-1));
                        imag_n(st+1,i+k) = imag_n_sfi(st,i+k) + Wi(k+1)*real_n_sfi(st,i+k+2^(st-1)) + Wr(k+1)*imag_n_sfi(st,i+k+2^(st-1));
                        real_n_sfi(st+1,i+k) = sfi(real_n(st+1,i+k),f_bits  + w_bits,f_bits);
                        imag_n_sfi(st+1,i+k) = sfi(imag_n(st+1,i+k),f_bits  + w_bits,f_bits);
                    % Odd
                        stage(st+1,i+k+2^(st-1)) = stage(st,i+k) - Wn(k+1)*stage(st,i+k+2^(st-1));
                        real_n(st+1,i+k+2^(st-1)) = real_n_sfi(st,i+k) - Wr(k+1)*real_n_sfi(st,i+k+2^(st-1)) +  Wi(k+1)*imag_n_sfi(st,i+k+2^(st-1));
                        imag_n(st+1,i+k+2^(st-1)) = imag_n_sfi(st,i+k) - Wi(k+1)*real_n_sfi(st,i+k+2^(st-1)) - Wr(k+1)*imag_n_sfi(st,i+k+2^(st-1));
                        real_n_sfi(st+1,i+k+2^(st-1)) = sfi(real_n(st+1,i+k+2^(st-1)),f_bits +  w_bits,f_bits);
                        imag_n_sfi(st+1,i+k+2^(st-1)) = sfi(imag_n(st+1,i+k+2^(st-1)),f_bits +  w_bits,f_bits);
                end
        end
    end
end

%% Plotting out

% for slowly result plotting uncomment pause

figure(5)
%for i = 1 : bits + 1;
for i = bits+1 : bits + 1
    %plot( fax_kHz, abs( fftshift( real_n(i, :) + j.*imag_n(i,:) ) ) ),
    plot( bin_vals, abs( fftshift( stage(i,:) ) ) ),
    grid minor, title('Linear Magnitude FFT'), ylabel('magnitude'), xlabel(' ');
    %pause(1);
end

figure(6)
%for i = 1 : bits + 1;
for i = bits+1 : bits + 1
    plot( bin_vals, abs( fftshift( real_n_sfi(i, :) + j.*imag_n_sfi(i,:) ) ) ),
    grid minor, title('Linear Magnitude FFT, ploted from Real + Imag'), ylabel('magnitude'), xlabel(' ');
    %plot( fax_kHz, abs( fftshift( stage(i,:) ) ) ), grid minor,;
    %pause(1);
end

figure(7)
dif = abs( fftshift( stage(bits+1,:) ) ) - abs( fftshift( real_n_sfi(bits+1, :) + j.*imag_n_sfi(bits+1,:) ) )  ;
plot( bin_vals, dif )
grid minor, title('Difference in plots'), ylabel('diff magnitude'), xlabel(' ');

