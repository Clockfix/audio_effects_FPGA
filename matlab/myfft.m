%% FFT algoritm
start_time = 0;
number_of_samples = 16;
end_time = number_of_samples - 1;
n = linspace(start_time, end_time , number_of_samples ); 

f1 = 5;
a1 = 0.2;

f2 = 2;
a2 = 00;

f3 = 1;
a3 = 00;
comp1 = a1 * sin( f1 *2*pi*n/number_of_samples);
comp2 = a2 * sin( f2 *2*pi*n/number_of_samples);
comp3 = a3 * sin( f3 *2*pi*n/number_of_samples);

data = comp1 + comp2 + comp3;


figure(1)
plot (n, comp1, '-');
hold on;
plot (n, comp2, '-');
plot (n, comp3, '-');
hold off;

figure(2)
plot (n, data);

figure(3)
X_matlab = fft(data, number_of_samples);
stem (n,abs(X_matlab))

%% My FFT

%  W_N vector calculation
% W  = zeros(1,number_of_samples);    % complex
% Wr = zeros(1,number_of_samples);    % real
% Wi = zeros(1,number_of_samples);    % imag
% for i = 1 : number_of_samples 
%     W(i)  = exp(-j * (i-1) * 2 * pi/ number_of_samples );
%     Wr(i) = real(W(i));
%     Wi(i) = imag(W(i));
% end

% reverse bit calulation

bits = length(dec2bin( number_of_samples - 1 ));
rev_bit_dec = zeros(1,number_of_samples); 

for i=1:number_of_samples
    bin_num = dec2bin(i-1 , bits);
    rev_bit = [];
    for k=bits:-1:1
       rev_bit = [rev_bit , bin_num(k)];
    end
    rev_bit_dec(i) = bin2dec(rev_bit) + 1; % add 1 to match Matlab numbering   
end

% First stage of FFT

s_1_2 = zeros(1,number_of_samples); 
stage = zeros(bits,number_of_samples);


for i=1:number_of_samples
    if rem(i-1,2) == 0          % odd or even
        stage(1,i) = data(rev_bit_dec(i)) +  data(rev_bit_dec(i+1));
    else
        stage(1,i) = data(rev_bit_dec(i)) -  data(rev_bit_dec(i-1));
    end
end

% s_1_2(1)  = data(rev_bit_dec(1)) +  data(rev_bit_dec(2));
% s_1_2(2)  = data(rev_bit_dec(2)) -  data(rev_bit_dec(1));
% 
% s_1_2(3)  = data(rev_bit_dec(3)) +  data(rev_bit_dec(4));
% s_1_2(4)  = data(rev_bit_dec(4)) -  data(rev_bit_dec(3));
% 
% s_1_2(5)  = data(rev_bit_dec(5)) +  data(rev_bit_dec(6));
% s_1_2(6)  = data(rev_bit_dec(6)) -  data(rev_bit_dec(5));
% 
% s_1_2(7)  = data(rev_bit_dec(7)) +  data(rev_bit_dec(8));
% s_1_2(8)  = data(rev_bit_dec(8)) -  data(rev_bit_dec(7));
% 
% s_1_2(9)  = data(rev_bit_dec(9)) +  data(rev_bit_dec(10));
% s_1_2(10)  = data(rev_bit_dec(10)) -  data(rev_bit_dec(9));
% 
% s_1_2(11)  = data(rev_bit_dec(11)) +  data(rev_bit_dec(12));
% s_1_2(12)  = data(rev_bit_dec(12)) -  data(rev_bit_dec(11));
% 
% s_1_2(13)  = data(rev_bit_dec(13)) +  data(rev_bit_dec(14));
% s_1_2(14)  = data(rev_bit_dec(14)) -  data(rev_bit_dec(13));
% 
% s_1_2(15)  = data(rev_bit_dec(15)) +  data(rev_bit_dec(16));
% s_1_2(16)  = data(rev_bit_dec(16)) -  data(rev_bit_dec(15));

% s_1_2(1)  = data(1) +  data(5);
% s_1_2(2)  = data(5) -  data(1);
% 
% s_1_2(3)  = data(3) +  data(7);
% s_1_2(4)  = data(7) -  data(3);
% 
% s_1_2(5)  = data(2) +  data(6);
% s_1_2(6)  = data(6) -  data(2);
% 
% s_1_2(7)  = data(4) +  data(8);
% s_1_2(8)  = data(8) -  data(4);

% s_1_2,
% stage,

% Second stage 

s_2_3 = zeros(1,number_of_samples); 

s_2_3(1) = s_1_2(1) + W(1) * s_1_2(3);
s_2_3(2) = s_1_2(2) + W(3) * s_1_2(4);
s_2_3(3) = s_1_2(3) + W(5) * s_1_2(1);
s_2_3(4) = s_1_2(4) + W(7) * s_1_2(2);

s_2_3(5) = s_1_2(5) + W(1) * s_1_2(7);
s_2_3(6) = s_1_2(6) + W(3) * s_1_2(8);
s_2_3(7) = s_1_2(7) + W(5) * s_1_2(5);
s_2_3(8) = s_1_2(8) + W(7) * s_1_2(6);


W1  = zeros(1,4);    % complex
for i = 1 : 4 
    W1(i)  = exp(-j * (i-1) * 2 * pi/ 4 );
end

stage(2,1) = stage(1,1) + W1(1) * stage(1,3);
stage(2,2) = stage(1,2) + W1(2) * stage(1,4);
stage(2,3) = stage(1,3) - W1(1) * stage(1,1);
stage(2,4) = stage(1,4) - W1(2) * stage(1,2);

stage(2,5) = stage(1,5) + W1(1) * stage(1,7);
stage(2,6) = stage(1,6) + W1(2) * stage(1,8);
stage(2,7) = stage(1,7) - W1(1) * stage(1,5);
stage(2,8) = stage(1,8) - W1(2) * stage(1,6);

stage(2,9) = stage(1,9) + W1(1) * stage(1,11);
stage(2,10) = stage(1,10) + W1(2) * stage(1,12);
stage(2,11) = stage(1,11) - W1(1) * stage(1,9);
stage(2,12) = stage(1,12) - W1(2) * stage(1,10);

stage(2,13) = stage(1,13) + W1(1) * stage(1,15);
stage(2,14) = stage(1,14) + W1(2) * stage(1,16);
stage(2,15) = stage(1,15) - W1(1) * stage(1,13);
stage(2,16) = stage(1,16) - W1(2) * stage(1,14);

% theard stage 

s_3_4 = zeros(1,number_of_samples); 

s_3_4(1) = s_2_3(1) + W(1) * s_2_3(5);
s_3_4(2) = s_2_3(2) + W(2) * s_2_3(6);

s_3_4(3) = s_2_3(3) + W(3) * s_2_3(7);
s_3_4(4) = s_2_3(4) + W(4) * s_2_3(8);


s_3_4(5) = s_2_3(5) + W(5) * s_2_3(1);
s_3_4(6) = s_2_3(6) + W(6) * s_2_3(2);

s_3_4(7) = s_2_3(7) + W(7) * s_2_3(3);
s_3_4(8) = s_2_3(8) + W(8) * s_2_3(4);

W2  = zeros(1,8);    % complex
for i = 1 : 8 
    W2(i)  = exp(-j * (i-1) * 2 * pi/ 8 );
end

stage(3,1) = stage(2,1) + W2(1) * stage(2,5);
stage(3,2) = stage(2,2) + W2(2) * stage(2,6);
stage(3,3) = stage(2,3) + W2(3) * stage(2,7);
stage(3,4) = stage(2,4) + W2(4) * stage(2,8);
stage(3,5) = stage(2,5) - W2(1) * stage(2,1);
stage(3,6) = stage(2,6) - W2(2) * stage(2,2);
stage(3,7) = stage(2,7) - W2(3) * stage(2,3);
stage(3,8) = stage(2,8) - W2(4) * stage(2,4);

stage(3,9) = stage(2,9) + W2(1) * stage(2,13);
stage(3,10) = stage(2,10) + W2(2) * stage(2,14);
stage(3,11) = stage(2,11) + W2(3) * stage(2,15);
stage(3,12) = stage(2,12) + W2(4) * stage(2,16);
stage(3,13) = stage(2,13) - W2(1) * stage(2,9);
stage(3,14) = stage(2,14) - W2(2) * stage(2,10);
stage(3,15) = stage(2,15) - W2(3) * stage(2,11);
stage(3,16) = stage(2,16) - W2(4) * stage(2,12);


% Fourt stage

W3  = zeros(1,16);    % complex
for i = 1 : 16 
    W3(i)  = exp(-j * (i-1) * 2 * pi/ 16 );
end

stage(4,1) = stage(3,1) + W3(1) * stage(3,9);
stage(4,2) = stage(3,2) + W3(2) * stage(3,10);
stage(4,3) = stage(3,3) + W3(3) * stage(3,11);
stage(4,4) = stage(3,4) + W3(4) * stage(3,12);
stage(4,5) = stage(3,5) + W3(5) * stage(3,13);
stage(4,6) = stage(3,6) + W3(6) * stage(3,14);
stage(4,7) = stage(3,7) + W3(7) * stage(3,15);
stage(4,8) = stage(3,8) + W3(8) * stage(3,16);
stage(4,9)  = stage(3,9)  - W3(1)  * stage(3,1);
stage(4,10) = stage(3,10) - W3(2) * stage(3,2);
stage(4,11) = stage(3,11) - W3(3) * stage(3,3);
stage(4,12) = stage(3,12) - W3(4) * stage(3,4);
stage(4,13) = stage(3,13) - W3(5) * stage(3,5);
stage(4,14) = stage(3,14) - W3(6) * stage(3,6);
stage(4,15) = stage(3,15) - W3(7) * stage(3,7);
stage(4,16) = stage(3,16) - W3(8) * stage(3,8);


figure(4)
stem(n, abs( stage(4,:) ) )





