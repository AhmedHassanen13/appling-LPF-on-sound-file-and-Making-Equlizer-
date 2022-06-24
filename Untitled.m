%--------- Parameters ---------%
M = 16 ;   % Modulation order
k = log2(M);  % Number of bits per symbol
n = 10000;    % Number of bits to process
t = 0 : 0.0001 : 0.9999 ;
snr = [0:20];
Average_BER_AWGN_Channel = zeros(1 , length(0:1:15));
Average_BER_Empircal_Model = zeros(1 , length(0:1:15));
BER_AWGN_Channel = zeros(1 , length(0:100));
BER_Emperical_Model = zeros(1 , length(0:100));
%---------- Generate Random Signals ------------% 
rng default                 % Use default random number generator
dataIn = randi([0 1],n,1);  % Generate vector of binary data
stem(dataIn(1:40),'filled');
title('Random Bits');
xlabel('Bit Index');
ylabel('Binary Value');
modulation_sig = qammod(bi2de(dataIn) , M);
power = mean(abs(modulation_sig).^2);
normalized_sig = (1/sqrt(power))*modulation_sig ;
%% --------- AWGN Channel ----------------------%
for ii = 0 : length(snr)
    SNR = 10^(ii/10);
    %------ Transmitter Side ------%
    SndData = awgn(modulation_sig ,SNR , 'measured') ;
    %-------- Reciever Side --------%
    denormalized_sig = SndData*sqrt(power);
    demodulation_sig = qamdemod(denormalized_sig, M);
    RevData = de2bi(demodulation_sig);
    %----- Calculating Errors ------%
    Errors = xor(RevData , dataIn);
end