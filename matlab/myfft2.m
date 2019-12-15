%% FFT algoritm
clear;                      % clears all previus values from memory 
clc;                        % clear command window
fs =  44100;                % samplinf freq.
fftLength=512;              % windowlength 
% signal frequencies
max = 2048 - 1 ;

f1 = 430;
a1 = 0;

f2 = 8000;
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
%ftMag=abs(ft(1:fftLength/2)); 
ftMag=abs(ft);
plot (ftMag)
title('Linear Magnitude FFT') 
ylabel('magnitude'), xlabel('kHz') 

xt = xticks;        % returns the current x-axis tick values as a vector
fstep = fs/fftLength;       % tick of f axis in f domain 
xtnew = round(xt*fstep/1000, 1) ;   % calculate new tick in kHz
xticklabels(xtnew)      % set new tick labels

figure(4)               % plots resultinf fft(in dB)  from Matlab functions
ft =fft(data,fftLength); 
%ftMag=abs(ft(1:fftLength/2));
ftMag=abs(ft);
plot (20*log10(ftMag))
title('dB Magnitude') 
ylabel('dB'), xlabel('kHz') 

xt = xticks;        % returns the current x-axis tick values as a vector
fstep = fs/fftLength;       % tick of f axis in f domain 
xtnew = round(xt*fstep/1000, 1) ;   % calculate new tick in kHz
xticklabels(xtnew)      % set new tick labels

%% Data preparation for FFT

% reverse bit calulation
bits = length(dec2bin( fftLength - 1 ));    % how many bits in binary number
rev_bit_dec = zeros(1,fftLength);      % create vektor size of fftlength

for i=1:fftLength
    bin_num = dec2bin(i-1 , bits);      % converting to binary number
    rev_bit = [];                       % create empty vector
    for k=bits:-1:1
       rev_bit = [rev_bit , bin_num(k)];
    end
    rev_bit_dec(i) = bin2dec(rev_bit) + 1; % add 1 to match Matlab numbering   
end

%  creating array
 
real_n = zeros(bits+1,fftLength);  % create empty array to store values in reverse bit order
imag_n = zeros(bits+1,fftLength);
stage = zeros(bits+1,fftLength);
%sfi_data = sfi(data,16,0);
for i=1:fftLength
     real_n(1,i) =  data(rev_bit_dec(i)+1); 
     stage(1,i)  =  data(rev_bit_dec(i)+1);
end


% %  W_N vector calculation
% W  = zeros(1,fftLength);    % complex
% Wr = zeros(1,fftLength);    % real
% Wi = zeros(1,fftLength);    % imag
% for i = 1 : fftLength 
%     W(i)  = exp(-j * (i-1) * 2 * pi/ fftLength );
%     Wr(i) = sfi(real(W(i)),16,15);
%     Wi(i) = sfi(imag(W(i)),16,15);
% end
%
% % W(30) = - W(30+256)  
% % or
% % W(x) = - W(x + fftLength/2)

%  new W_N vector calculation this time only half

W  = zeros(1,fftLength/2);    % complex
Wr = zeros(1,fftLength/2);    % real
Wi = zeros(1,fftLength/2);    % imag
for i = 1 : fftLength/2 
    W(i)  = exp(-j * (i-1) * 2 * pi/ fftLength );
    Wr(i) = real(W(i));%sfi(real(W(i)),16,15);
    Wi(i) = imag(W(i));%sfi(imag(W(i)),16,15);
end


%% FFT FSM

%% First stage

for i = 1 : 2^1 : fftLength 
% %     % Even
% %     stage(2,i)    = stage(1,i) + stage(1,i+1);
% %     % Odd
% %     stage(2,i+1)  = stage(1,i) - stage(1,i+1);
    
    % Even
    real_n(2,i)   = real_n(1,i) + real_n(1,i+1);    
    % Odd
    real_n(2,i+1) = real_n(1,i) - real_n(1,i+1); 
end



%% Second stage

% % % Calculating W twiddling factor 
% % for i = 1 : 2 
% %     Wn(i)  = exp(-j * (i-1) * 2 * pi/ 4 );
% % end
% % 
% % % calculate next stage values
% % for i = 1 : 2^2 : fftLength 
% %     % Even pair
% %         stage(3,i+0)   = stage(2,i+0) + Wn(1)*stage(2,i+2); 
% %         stage(3,i+1)   = stage(2,i+1) + Wn(2)*stage(2,i+3); 
% %     % Odd par
% %         stage(3,i+2)   = stage(2,i+0) - Wn(1)*stage(2,i+2); 
% %         stage(3,i+3)   = stage(2,i+1) - Wn(2)*stage(2,i+3); 
% % end

% Multiply odd pairs with W twiddling factor
for i = 1 : 1 : fftLength 
    i_bin = dec2bin(i-1, bits);     % calculates "i" in binary
    
    if i_bin(bits - 1:bits) == '11'      % Odd pair odd number(every fourth)
        
        imag_n(2,i) = -real_n(2,i);
        real_n(2,i) = 0;
        % c= real_n(2,i) + j * imag_n(2,i),
    end 
end
% calculate next stage values
for i = 1 : 2^2 : fftLength 
    % Even pair
    real_n(3,i+0)   = real_n(2,i+0) + real_n(2,i+2); 
    real_n(3,i+1)   = real_n(2,i+1) + real_n(2,i+3);
    imag_n(3,i+0)   = imag_n(2,i+0) + imag_n(2,i+2); 
    imag_n(3,i+1)   = imag_n(2,i+1) + imag_n(2,i+3);  
    % Odd par
    real_n(3,i+2)   = real_n(2,i+0) - real_n(2,i+2);
    real_n(3,i+3)   = real_n(2,i+1) - real_n(2,i+3);
    imag_n(3,i+2)   = imag_n(2,i+0) - imag_n(2,i+2);
    imag_n(3,i+3)   = imag_n(2,i+1) - imag_n(2,i+3);
end

%% Therd stage

% % % Calculating W twiddling factor 
% % for i = 1 : 4 
% %     Wn(i)  = exp(-j * (i-1) * 2 * pi/ 8 );
% % end
% % 
% % % calculate next stage values
% % for i = 1 : 2^3 : fftLength 
% %     for k = 0 : 3
% %         % Even pair
% %         stage(4,i+k)   = stage(3,i+k) + Wn(k+1)*stage(3,i+k+4);   
% %         % Odd par
% %         stage(4,i+k+4) = stage(3,i+k) - Wn(k+1)*stage(3,i+k+4); 
% %     end
% % end

% Multiply odd pairs with W twiddling factor
for i = 1 : 1 : fftLength 
    i_bin = dec2bin(i-1, bits);     % calculates "i" in binary
    
    if i_bin(bits - 2) == '1'       % 
        if i_bin(bits - 1: bits) == '00' 
            % real_n(3,i) = real_n(3,i);
            % imag_n(3,i) = imag_n(3,i);  
        end
        if i_bin(bits - 1: bits) == '01' 
            real_x = real_n(3,i)*Wr(65) - imag_n(3,i)*Wi(65);
            imag_x = real_n(3,i)*Wi(65) + Wr(65)*imag_n(3,i);
            real_n(3,i) = real_x;
            imag_n(3,i) = imag_x;
        end
        if i_bin(bits - 1: bits) == '10' 
            real_x = real_n(3,i)*Wr(129) - imag_n(3,i)*Wi(129);
            imag_x = real_n(3,i)*Wi(129) + Wr(129)*imag_n(3,i);
            real_n(3,i) = real_x;
            imag_n(3,i) = imag_x;
        end
        if i_bin(bits - 1: bits) == '11' 
            real_x = real_n(3,i)*Wr(193) - imag_n(3,i)*Wi(193);
            imag_x = real_n(3,i)*Wi(193) + Wr(193)*imag_n(3,i); 
            real_n(3,i) = real_x;
            imag_n(3,i) = imag_x;
        end
    end 
end
% calculate next stage values
for i = 1 : 2^3 : fftLength 
    for k = 0 : 3
        % Even pair
        real_n(4,i+k)   = real_n(3,i+k) + real_n(3,i+k+4);  
        imag_n(4,i+k)   = imag_n(3,i+k) + imag_n(3,i+k+4);   
        % Odd par
        real_n(4,i+k+4) = real_n(3,i+k) - real_n(3,i+k+4); 
        imag_n(4,i+k+4) = imag_n(3,i+k) - imag_n(3,i+k+4); 
    end
end

%% 4th stage  

% % % Calculating W twiddling factor 
% % for i = 1 : 8 
% %     Wn(i)  = exp(-j * (i-1) * 2 * pi/ 16 );
% % end
% % 
% % % calculate next stage values
% % for i = 1 : 2^4 : fftLength 
% %     for k = 0 : 7
% %         % Even pair
% %         stage(5,i+k)    = stage(4,i+k) + Wn(k+1)*stage(4,i+k+8);     
% %         % Odd par
% %         stage(5,i+k+8)  = stage(4,i+k) - Wn(k+1)*stage(4,i+k+8);  
% %     end
% % end

% Multiply odd pairs with W twiddling factor
for i = 1 : 1 : fftLength 
    i_bin = dec2bin(i-1, bits);     % calculates "i" in binary
    
    if i_bin(bits - 3) == '1'       % 
    	n = bin2dec(i_bin(bits - 2:bits));  % converting last 3 bits to decimal
    	real_x = real_n(4,i)*Wr(n*32+1) - imag_n(4,i)*Wi(n*32+1);
    	imag_x = real_n(4,i)*Wi(n*32+1) + imag_n(4,i)*Wr(n*32+1); 
        real_n(4,i) = real_x;
        imag_n(4,i) = imag_x;
    end 
end

% calculate next stage values
for i = 1 : 2^4 : fftLength 
    for k = 0 : 7
        %Even pair
        real_n(5,i+k)   = real_n(4,i+k) + real_n(4,i+k+8);  
        imag_n(5,i+k)   = imag_n(4,i+k) + imag_n(4,i+k+8);   
        %Odd par
        real_n(5,i+k+8) = real_n(4,i+k) - real_n(4,i+k+8); 
        imag_n(5,i+k+8) = imag_n(4,i+k) - imag_n(4,i+k+8); 
    end
end

%% 5th stage 

% % % Calculating W twiddling factor 
% % for i = 1 : 16 
% %     Wn(i)  = exp(-j * (i-1) * 2 * pi/ 32 );
% % end
% % 
% % % calculate next stage values
% % for i = 1 : 2^5 : fftLength 
% %     for k = 0 : 15
% %         % Even pair
% %         stage(6,i+k)     = stage(5,i+k) + Wn(k+1)*stage(5,i+k+16);     
% %         % Odd par
% %         stage(6,i+k+16)  = stage(5,i+k) - Wn(k+1)*stage(5,i+k+16);  
% %     end
% % end

% Multiply odd pairs with W twiddling factor
for i = 1 : 1 : fftLength 
    i_bin = dec2bin(i-1, bits);     % calculates "i" in binary
    
    if i_bin(bits - 4) == '1'       % 
    	n = bin2dec(i_bin(bits - 3:bits));  % converting last 4 bits to decimal
    	real_x = real_n(5,i)*Wr(n*16+1) - imag_n(5,i)*Wi(n*16+1);
    	imag_x = real_n(5,i)*Wi(n*16+1) + imag_n(5,i)*Wr(n*16+1);  
        real_n(5,i) = real_x;
        imag_n(5,i) = imag_x;
    end 
end

% calculate next stage values
for i = 1 : 2^5 : fftLength 
    for k = 0 : 15
        % Even pair
        real_n(6,i+k)   = real_n(5,i+k) + real_n(5,i+k+16);  
        imag_n(6,i+k)   = imag_n(5,i+k) + imag_n(5,i+k+16);   
        % Odd par
        real_n(6,i+k+16)= real_n(5,i+k) - real_n(5,i+k+16); 
        imag_n(6,i+k+16)= imag_n(5,i+k) - imag_n(5,i+k+16); 
    end
end

%% 6th stage 

% % % Calculating W twiddling factor 
% % for i = 1 : 32 
% %     Wn(i)  = exp(-j * (i-1) * 2 * pi/ 64 );
% % end
% % 
% % % calculate next stage values
% % for i = 1 : 2^6 : fftLength 
% %     for k = 0 : 31
% %         % Even pair
% %         stage(7,i+k)     = stage(6,i+k) + Wn(k+1)*stage(6,i+k+32);     
% %         % Odd par
% %         stage(7,i+k+32)  = stage(6,i+k) - Wn(k+1)*stage(6,i+k+32);  
% %     end
% % end

% Multiply odd pairs with W twiddling factor
for i = 1 : 1 : fftLength 
    i_bin = dec2bin(i-1, bits);     % calculates "i" in binary
    
    if i_bin(bits - 5) == '1'       % 
    	n = bin2dec(i_bin(bits - 4:bits));  % converting last 5 bits to decimal
    	real_x = real_n(6,i)*Wr(n*8+1) - imag_n(6,i)*Wi(n*8+1);
    	imag_x = real_n(6,i)*Wi(n*8+1) + imag_n(6,i)*Wr(n*8+1); 
        real_n(6,i) = real_x;
        imag_n(6,i) = imag_x;
    end 
end

% calculate next stage values
for i = 1 : 2^6 : fftLength 
    for k = 0 : 31
        % Even pair
        real_n(7,i+k)   = real_n(6,i+k) + real_n(6,i+k+32);  
        imag_n(7,i+k)   = imag_n(6,i+k) + imag_n(6,i+k+32);   
        % Odd par
        real_n(7,i+k+32)= real_n(6,i+k) - real_n(6,i+k+32); 
        imag_n(7,i+k+32)= imag_n(6,i+k) - imag_n(6,i+k+32); 
    end
end

%% 7th stage 

% % % Calculating W twiddling factor 
% % for i = 1 : 64 
% %     Wn(i)  = exp(-j * (i-1) * 2 * pi/ 128 );
% % end
% % 
% % % calculate next stage values
% % for i = 1 : 2^7 : fftLength 
% %     for k = 0 : 63
% %         % Even pair
% %         stage(8,i+k)     = stage(7,i+k) + Wn(k+1)*stage(7,i+k+64);     
% %         % Odd par
% %         stage(8,i+k+64)  = stage(7,i+k) - Wn(k+1)*stage(7,i+k+64);  
% %     end
% % end

% Multiply odd pairs with W twiddling factor
for i = 1 : 1 : fftLength 
    i_bin = dec2bin(i-1, bits);     % calculates "i" in binary
    
    if i_bin(bits - 6) == '1'       % 
    	n = bin2dec(i_bin(bits - 5:bits));  % converting last 6 bits to decimal
    	real_x = real_n(7,i)*Wr(n*4+1) - imag_n(7,i)*Wi(n*4+1);
    	imag_x = real_n(7,i)*Wi(n*4+1) + imag_n(7,i)*Wr(n*4+1); 
        real_n(7,i) = real_x;
        imag_n(7,i) = imag_x;
    end 
end

% calculate next stage values
for i = 1 : 2^7 : fftLength 
    for k = 0 : 63
        % Even pair
        real_n(8,i+k)   = real_n(7,i+k) + real_n(7,i+k+64);  
        imag_n(8,i+k)   = imag_n(7,i+k) + imag_n(7,i+k+64);   
        % Odd par
        real_n(8,i+k+64)= real_n(7,i+k) - real_n(7,i+k+64); 
        imag_n(8,i+k+64)= imag_n(7,i+k) - imag_n(7,i+k+64); 
    end
end

%% 8th stage 


% % % Calculating W twiddling factor 
% % for i = 1 : 128 
% %     Wn(i)  = exp(-j * (i-1) * 2 * pi/ 256 );
% % end
% % 
% % % calculate next stage values
% % for i = 1 : 2^8 : fftLength 
% %     for k = 0 : 127
% %         % Even pair
% %         stage(9,i+k)      = stage(8,i+k) + Wn(k+1)*stage(8,i+k+128);     
% %         % Odd par
% %         stage(9,i+k+128)  = stage(8,i+k) - Wn(k+1)*stage(8,i+k+128);  
% %     end
% % end


% Multiply odd pairs with W twiddling factor
for i = 1 : 1 : fftLength 
    i_bin = dec2bin(i-1, bits);     % calculates "i" in binary
    
    if i_bin(bits - 7) == '1'       % 
    	n = bin2dec(i_bin(bits - 6:bits));  % converting last 7 bits to decimal
    	real_x = real_n(8,i)*Wr(n*2+1) - imag_n(8,i)*Wi(n*2+1);
    	imag_x = real_n(8,i)*Wi(n*2+1) + imag_n(8,i)*Wr(n*2+1); 
        real_n(8,i) = real_x;
        imag_n(8,i) = imag_x;
    end 
end

% calculate next stage values
for i = 1 : 2^8 : fftLength 
    for k = 0 : 127
        % Even pair
        real_n(9,i+k)   = real_n(8,i+k) + real_n(8,i+k+128);  
        imag_n(9,i+k)   = imag_n(8,i+k) + imag_n(8,i+k+128);   
        % Odd par
        real_n(9,i+k+128)= real_n(8,i+k) - real_n(8,i+k+128); 
        imag_n(9,i+k+128)= imag_n(8,i+k) - imag_n(8,i+k+128); 
    end
end

%% 9th stage 


% % % Calculating W twiddling factor 
% % for i = 1 : 256 
% %     Wn(i)  = exp(-j * (i-1) * 2 * pi/ 512 );
% % end
% % 
% % % calculate next stage values
% % for i = 1 : 2^9 : fftLength 
% %     for k = 0 : 255
% %         % Even pair
% %         stage(10,i+k)      = stage(9,i+k) + Wn(k+1)*stage(9,i+k+256);     
% %         % Odd par
% %         stage(10,i+k+256)  = stage(9,i+k) - Wn(k+1)*stage(9,i+k+256);  
% %     end
% % end

% Multiply odd pairs with W twiddling factor
for i = 1 : 1 : fftLength 
    i_bin = dec2bin(i-1, bits);     % calculates "i" in binary
    
    if i_bin(bits - 8) == '1'       % 
    	n = bin2dec(i_bin(bits - 7:bits));  % converting last 8 bits to decimal
    	real_x = real_n(8,i)*Wr(n*1+1) - imag_n(8,i)*Wi(n*1+1);
    	imag_x = real_n(8,i)*Wi(n*1+1) + imag_n(8,i)*Wr(n*1+1); 
        real_n(8,i) = real_x;
        imag_n(8,i) = imag_x;
    end 
end

% calculate next stage values
i = 1;
    for k = 0 : 255
        % Even pair
        real_n(10,i+k)   = real_n(9,i+k) + real_n(9,i+k+255);  
        imag_n(10,i+k)   = imag_n(9,i+k) + imag_n(9,i+k+255);   
        % Odd par
        real_n(10,i+k+255)= real_n(9,i+k) - real_n(9,i+k+255); 
        imag_n(10,i+k+255)= imag_n(9,i+k) - imag_n(9,i+k+255); 
    end



%% Ploting out
% slowly plot result
figure(5)
for i = bits : bits 
    plot( abs( real_n(i, :) + j.*imag_n(i,  :) ) );
%     plot( abs( stage(i,:) ) );
%    pause(1);
end
xt = xticks;        % returns the current x-axis tick values as a vector
fstep = fs/fftLength;       % tick of f axis in f domain 
xtnew = round(xt*fstep)/1000 ;   % calculate new tick in kHz
xticklabels(xtnew)      % set new tick labels