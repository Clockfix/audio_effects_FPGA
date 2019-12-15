%% FFT algoritm
clear;  % clear all data from memmory
start_time = 0;
number_of_samples = 32;
end_time = number_of_samples - 1;
n = linspace(start_time, end_time , number_of_samples ); 

f1 = 2;
a1 = 0.2;

f2 = 2;
a2 = 00;

f3 = 1;
a3 = 00;
comp1 = a1 * cos( f1 *2*pi*n/number_of_samples);
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

stage = zeros(bits,number_of_samples);

for i=1:number_of_samples
     stage(1,i) =  data((i)); 
end


stage(2,1) = stage(1,1) +  stage(1,2);
stage(2,2) = stage(1,1) -  stage(1,2) ;

stage(2,3) = (stage(1,3) +  stage(1,4)) * exp(-j * 0 * 2 * pi/ 4 );
stage(2,4) = (stage(1,3) -  stage(1,4)) * exp(-j * 1 * 2 * pi/ 4 );

stage(2,5) = stage(1,5) +  stage(1,6);
stage(2,6) = stage(1,5) -  stage(1,6);

stage(2,7) = (stage(1,7) +  stage(1,8)) * exp(-j * 0 * 2 * pi/ 4 );
stage(2,8) = (stage(1,7) -  stage(1,8)) * exp(-j * 1 * 2 * pi/ 4 );

stage(2,9) = stage(1,9) + stage(1,10);
stage(2,10) = stage(1,9) -  stage(1,10);

stage(2,11) = (stage(1,11) +  stage(1,12)) * exp(-j * 0 * 2 * pi/ 4 );
stage(2,12) = (stage(1,11) -  stage(1,12)) * exp(-j * 1 * 2 * pi/ 4 );

stage(2,13) = stage(1,13) +  stage(1,14);
stage(2,14) = stage(1,13) -  stage(1,14);

stage(2,15) = (stage(1,15) +  stage(1,16)) * exp(-j * 0 * 2 * pi/ 4 );
stage(2,16) = (stage(1,15) -  stage(1,16)) * exp(-j * 1 * 2 * pi/ 4 );

stage(2,17) = stage(1,17) +  stage(1,18);
stage(2,18) = (stage(1,17) -  stage(1,18)) * exp(-j * 1 * 2 * pi/ 4 );

stage(2,19) = stage(1,19) +  stage(1,20);
stage(2,20) = (stage(1,19) -  stage(1,20)) * exp(-j * 1 * 2 * pi/ 4 );

stage(2,21) = stage(1,21) +  stage(1,22);
stage(2,22) = stage(1,21) -  stage(1,22);

stage(2,23) = stage(1,23) +  stage(1,24);
stage(2,24) = stage(1,23) -  stage(1,24);

stage(2,25) = stage(1,25) +  stage(1,26);
stage(2,26) = stage(1,25) -  stage(1,26);

stage(2,27) = stage(1,27) +  stage(1,28);
stage(2,28) = stage(1,27) -  stage(1,28);

stage(2,29) = stage(1,29) +  stage(1,30);
stage(2,30) = stage(1,29) -  stage(1,30);

stage(2,31) = stage(1,31) +  stage(1,32);
stage(2,32) = stage(1,31) -  stage(1,32);


% stage,

% Second stage 


stage(2,1) = stage(1,1) +  stage(1,3);
stage(2,2) = stage(1,2) +  stage(1,4);
stage(2,3) = stage(1,1) -  stage(1,3);
stage(2,4) = stage(1,2) -  stage(1,4);

stage(2,5) = (stage(1,5) +  stage(1,7)) * exp(-j * 0 * 2 * pi/ 8 );
stage(2,6) = (stage(1,6) +  stage(1,8)) * exp(-j * 1 * 2 * pi/ 8 );
stage(2,7) = (stage(1,5) -  stage(1,7)) * exp(-j * 2 * 2 * pi/ 8 );
stage(2,8) = (stage(1,6) -  stage(1,8)) * exp(-j * 3 * 2 * pi/ 8 );

stage(2,9) = stage(1,9) +   stage(1,11);
stage(2,10) = stage(1,10) + stage(1,12);
stage(2,11) = stage(1,9) - stage(1,11);
stage(2,12) = stage(1,10) - stage(1,12);

stage(2,13) = (stage(1,13) + stage(1,15)) * exp(-j * 0 * 2 * pi/ 8 );
stage(2,14) = (stage(1,14) + stage(1,16)) * exp(-j * 1 * 2 * pi/ 8 );
stage(2,15) = (stage(1,13) - stage(1,15)) * exp(-j * 2 * 2 * pi/ 8 );
stage(2,16) = (stage(1,14) - stage(1,16)) * exp(-j * 3 * 2 * pi/ 8 );

stage(2,17) = stage(1,17) + 1 * stage(1,19);
stage(2,18) = stage(1,18) + 1 * stage(1,20);
stage(2,19) = stage(1,19) - W1(1) * stage(1,17);
stage(2,20) = stage(1,20) - W1(2) * stage(1,18);

stage(2,21) = stage(1,21) + 1 * stage(1,23);
stage(2,22) = stage(1,22) + 1 * stage(1,24);
stage(2,23) = stage(1,23) - W1(1) * stage(1,21);
stage(2,24) = stage(1,24) - W1(2) * stage(1,22);

stage(2,25) = stage(1,25) + 1 * stage(1,27);
stage(2,26) = stage(1,26) + 1 * stage(1,28);
stage(2,27) = stage(1,27) - W1(1) * stage(1,25);
stage(2,28) = stage(1,28) - W1(2) * stage(1,26);

stage(2,29) = stage(1,29) + 1 * stage(1,31);
stage(2,30) = stage(1,30) + 1 * stage(1,32);
stage(2,31) = stage(1,31) - W1(1) * stage(1,29);
stage(2,32) = stage(1,32) - W1(2) * stage(1,30);

% theard stage 


stage(3,1) = stage(2,1) +  stage(2,5);
stage(3,2) = stage(2,2) +  stage(2,6);
stage(3,3) = stage(2,3) +  stage(2,7);
stage(3,4) = stage(2,4) +  stage(2,8);
stage(3,5) = stage(2,1) -  stage(2,5);
stage(3,6) = stage(2,2) -  stage(2,6);
stage(3,7) = stage(2,3) -  stage(2,7);
stage(3,8) = stage(2,4) -  stage(2,8);

stage(3,9) =  (stage(2,9)  +  stage(2,13)) * exp(-j * 0 * 2 * pi/ 16 );
stage(3,10) = (stage(2,10) +  stage(2,14)) * exp(-j * 1 * 2 * pi/ 16 );
stage(3,11) = (stage(2,11) +  stage(2,15)) * exp(-j * 2 * 2 * pi/ 16 );
stage(3,12) = (stage(2,12) +  stage(2,16)) * exp(-j * 3 * 2 * pi/ 16 );
stage(3,13) = (stage(2,9)  -  stage(2,13)) * exp(-j * 4 * 2 * pi/ 16 );
stage(3,14) = (stage(2,10) -  stage(2,14)) * exp(-j * 5 * 2 * pi/ 16 );
stage(3,15) = (stage(2,11) -  stage(2,15)) * exp(-j * 6 * 2 * pi/ 16 );
stage(3,16) = (stage(2,12) -  stage(2,16)) * exp(-j * 7 * 2 * pi/ 16 );



stage(3,17) = stage(2,17) + W2(1) * stage(2,21);
stage(3,18) = stage(2,18) + W2(2) * stage(2,22);
stage(3,19) = stage(2,19) + W2(3) * stage(2,23);
stage(3,20) = stage(2,20) + W2(4) * stage(2,24);
stage(3,21) = stage(2,21) - W2(1) * stage(2,17);
stage(3,22) = stage(2,22) - W2(2) * stage(2,18);
stage(3,23) = stage(2,23) - W2(3) * stage(2,19);
stage(3,24) = stage(2,24) - W2(4) * stage(2,20);

stage(3,25) = stage(2,25) + W2(1) * stage(2,29);
stage(3,26) = stage(2,26) + W2(2) * stage(2,30);
stage(3,27) = stage(2,27) + W2(3) * stage(2,31);
stage(3,28) = stage(2,28) + W2(4) * stage(2,32);
stage(3,29) = stage(2,29) - W2(1) * stage(2,25);
stage(3,30) = stage(2,30) - W2(2) * stage(2,26);
stage(3,31) = stage(2,31) - W2(3) * stage(2,27);
stage(3,32) = stage(2,32) - W2(4) * stage(2,28);


% Fourt stage

% 
stage(4,1) = stage(3,1) +  stage(3,9);
stage(4,2) = stage(3,2) +  stage(3,10);
stage(4,3) = stage(3,3) +  stage(3,11);
stage(4,4) = stage(3,4) +  stage(3,12);
stage(4,5) = stage(3,5) +  stage(3,13);
stage(4,6) = stage(3,6) +  stage(3,14);
stage(4,7) = stage(3,7) +  stage(3,15);
stage(4,8) = stage(3,8) +  stage(3,16);
stage(4,9)  = stage(3,1) - stage(3,9);
stage(4,10) = stage(3,2) -  stage(3,10);
stage(4,11) = stage(3,3) -  stage(3,11);
stage(4,12) = stage(3,4) -  stage(3,12);
stage(4,13) = stage(3,5) -  stage(3,13);
stage(4,14) = stage(3,6) -  stage(3,14);
stage(4,15) = stage(3,7) -  stage(3,15);
stage(4,16) = stage(3,8) -  stage(3,16);

stage(4,17) = stage(3,17) + W3(1) * stage(3,25);
stage(4,18) = stage(3,18) + W3(2) * stage(3,26);
stage(4,19) = stage(3,19) + W3(3) * stage(3,27);
stage(4,20) = stage(3,20) + W3(4) * stage(3,28);
stage(4,21) = stage(3,21) + W3(5) * stage(3,29);
stage(4,22) = stage(3,22) + W3(6) * stage(3,30);
stage(4,23) = stage(3,23) + W3(7) * stage(3,31);
stage(4,24) = stage(3,24) + W3(8) * stage(3,32);
stage(4,25) = stage(3,25) - W3(1) * stage(3,17);
stage(4,26) = stage(3,26) - W3(2) * stage(3,18);
stage(4,27) = stage(3,27) - W3(3) * stage(3,19);
stage(4,28) = stage(3,28) - W3(4) * stage(3,20);
stage(4,29) = stage(3,29) - W3(5) * stage(3,21);
stage(4,30) = stage(3,30) - W3(6) * stage(3,22);
stage(4,31) = stage(3,31) - W3(7) * stage(3,23);
stage(4,32) = stage(3,32) - W3(8) * stage(3,24);

% Fifth stage

W4  = zeros(1,32);    % complex
for i = 1 : 32 
    W4(i)  = exp(-j * (i-1) * 2 * pi/ 32 );
end

stage(5,1) = stage(4,1) + W4(1) * stage(4,17);
stage(5,2) = stage(4,2) + W4(2) * stage(4,18);
stage(5,3) = stage(4,3) + W4(3) * stage(4,19);
stage(5,4) = stage(4,4) + W4(4) * stage(4,20);
stage(5,5) = stage(4,5) + W4(5) * stage(4,21);
stage(5,6) = stage(4,6) + W4(6) * stage(4,22);
stage(5,7) = stage(4,7) + W4(7) * stage(4,23);
stage(5,8) = stage(4,8) + W4(8) * stage(4,24);
stage(5,9)  = stage(4,9)  + W4(9) * stage(4,25);
stage(5,10) = stage(4,10) + W4(10) * stage(4,26);
stage(5,11) = stage(4,11) + W4(11) * stage(4,27);
stage(5,12) = stage(4,12) + W4(12) * stage(4,28);
stage(5,13) = stage(4,13) + W4(13) * stage(4,29);
stage(5,14) = stage(4,14) + W4(14) * stage(4,30);
stage(5,15) = stage(4,15) + W4(15) * stage(4,31);
stage(5,16) = stage(4,16) + W4(16) * stage(4,32);
stage(5,17) = stage(4,17) - W4(1) * stage(4,1);
stage(5,18) = stage(4,18) - W4(2) * stage(4,2);
stage(5,19) = stage(4,19) - W4(3) * stage(4,3);
stage(5,20) = stage(4,20) - W4(4) * stage(4,4);
stage(5,21) = stage(4,21) - W4(5) * stage(4,5);
stage(5,22) = stage(4,22) - W4(6) * stage(4,6);
stage(5,23) = stage(4,23) - W4(7) * stage(4,7);
stage(5,24) = stage(4,24) - W4(8) * stage(4,8);
stage(5,25) = stage(4,25) - W4(9) * stage(4,9);
stage(5,26) = stage(4,26) - W4(10) * stage(4,10);
stage(5,27) = stage(4,27) - W4(11) * stage(4,11);
stage(5,28) = stage(4,28) - W4(12) * stage(4,12);
stage(5,29) = stage(4,29) - W4(13) * stage(4,13);
stage(5,30) = stage(4,30) - W4(14) * stage(4,14);
stage(5,31) = stage(4,31) - W4(15) * stage(4,15);
stage(5,32) = stage(4,32) - W4(16) * stage(4,16);




figure(4)
stem(n, abs( stage(bits,:) ) )





