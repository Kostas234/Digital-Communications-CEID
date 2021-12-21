%meros_A: Modulation of input signal through system containing a filter
%for transmission, a channel with additive white gaussian noise, a filter
%in receiver, a sampler and a decision device.
n=1e5;
bin_seq = round(rand(1,n));
M=4;
% καθε k=log2(M) bit αντιστοιχουν σε ενα συμβολο
k=log2(M);
% το μηκος της δυαδικης ακολουθιας να μην % διαιρειται ακριβως με το log2(m)
% οποτε τοτε θα συμπληρωσουμε στην αρχη της ακολουθιας μηδενικα ωστε να γινεται
% η διαιρεση χωρις να αλλαζει η αρχικη ακολουθια
md=mod(n,k);
if md>0
    if mod(n+1,log2(M))~=0 
        c=n+2;
    elseif mod(n+2,log2(M))~=0
        c=n+1;
    end
        for z=1:c
            if z>n
                bin_seq2(z)=0;
            else
            bin_seq2(z)=bin_seq(z);
            end
        end     
elseif md==0
        bin_seq2=bin_seq;
end
lng=length(bin_seq2);
% χρηση της reshape ωστε σε καθε γραμμη να υπαρχουν k=log2(M) bits
bin_seq1=reshape(bin_seq2,k,lng/k)';
% μετατροπη καθε γραμμης(log2(M) bit) σε εναν ακεραιο
dec_seq=bi2de(bin_seq1,'left-msb');
%
%% ΔΙΑΜΟΡΦΩΣΗ ΕΙΣΟΔΟΥ
%
Es=1;
sm=reshape(dec_seq,1,lng/k);
% τα συμβολα  θα ειναι Μ οποτε θα αντιστοιχισουμε
% καθε ακεραιο με δυο συνιστωσες ωστε να εχει μια θεση στο χωρο
n=length(sm);
for i=1:n
    for l=1:M
        if sm(i)==(l-1);
            m=l;
                s1(i)=sqrt(Es)*cos((2*pi*m)/M);
                s2(i)=sqrt(Es)*sin((2*pi*m)/M);
        end
    end
end
% Συνθεση μιγαδικου αριθμου με τις δυο συνιστωσες
s=complex(s1,s2);
in=s;
rate=4;
ro_factor=0.3;
T=1;
ideal='n';
SNR_db=4;
% s:the alphabet of the source
%~~~~~~~~~~~~~~~~~~~~~~ INPUT | UPSAMPLING ~~~~~~~~~~~~~~~~~~~~~
%---upsample input according to rate:
signal_up = upsample(in,rate);
%remove last nonusable '0s'
signal_up = signal_up(1:length(signal_up)-rate+1);
%~~~~~~~~~~~~~~~~~~~~~~ TRANSMITTER | FILTER ~~~~~~~~~~~~~~~~~~~
%---transmitter's filter (Ts = 1sec)
f = rcosfir(ro_factor , [-T/2 , T/2] , rate , 1 , 'sqrt');
%normalization of filter so that norm(f) = 1
f = f./norm(f);
%---signal is passed through the filter (convolution):
TF_sig = conv(f , signal_up);
%~~~~~~~~~~~~~~~~~~~~~ CHANNEL | FILTER ~~~~~~~~~~~~~~~~~~~~~~~~
%---check if channel is ideal or not;
%if it isn't, add the channel's upsampled response
if (ideal == 'n')
%non-ideal channel's impulse response is given as:
h = [0.01 , 0.04 , -0.05 , 0.06 , -0.22 , -0.5 , ...
0.72 , 0.36 , 0 , 0.21 , 0.04 , 0.08 , 0.02];
h_up = upsample(h,rate);
%remove extra '0s'
h_up = h_up(1:length(h_up)-rate+1);
%convolution with signal
C_sig = conv(TF_sig , h_up);
elseif (ideal == 'y')
C_sig = TF_sig;
end%~~~~~~~~~~~~~~~~~~~~~ CHANNEL | NOISE ~~~~~~~~~~~~~~~~~~~~~~~~~
%---additive AWGN noise:
%calculate average power of channeled signal:
absC_sig = abs(C_sig);
Ps = sum(absC_sig.^2) / length(C_sig);
%calculate average power of channel's noise based on given SNR|db:
Pn = Ps / (10^(SNR_db/10));
%calculate noise based on Pn which is the square of noise's deviation:
noiserand = randn(length(C_sig),1);
%if the constellation is complex, noise must be added in both imaginary and
%real parts:
if(isreal(C_sig) == 0)
noiserand = (noiserand + 1j*randn(length(C_sig),1)) / sqrt(2);
end
noise = sqrt(Pn) * noiserand;
%---channel's output with added noise:
CAWGN_sig = C_sig + noise';
%~~~~~~~~~~~~~~~~~~~~~~ RECEIVER | FILTER ~~~~~~~~~~~~~~~~~~~~~~
%---receiver's filter is the same as transmitter's:
RF_sig = conv(f , CAWGN_sig);
%~~~~~~~~~~~~~~~~~~~ RECEIVER | DOWNSAMPLING ~~~~~~~~~~~~~~~~~~~~
%---calculate delay according to channel's type to be excluded from
%incoming signal:
if (ideal == 'n')
%displacement:
delay = 2*floor(length(f)/2) + floor(length(h_up)/2);
elseif (ideal == 'y')
delay = 2*floor(length(f)/2);
end
%downsample signal:
S_sig = RF_sig(delay+1 : rate : length(RF_sig) - delay);
%~~~~~~~~~~~~~~~~~~~~~ RECEIVER | DECISION ~~~~~~~~~~~~~~~~~~~~~
for m=1:M
        s1_2(m)=sqrt(Es)*cos((2*pi*m)/M);
        s2_2(m)=sqrt(Es)*sin((2*pi*m)/M);
end
% Συνθεση μιγαδικου αριθμου με τις δυο συνιστωσες
s_2=complex(s1_2,s2_2);
S_sig=S_sig';
s_2=s_2';
out = zeros(length(S_sig),1);
D = zeros(length(s_2),1);
%for each element of the signal vector, decide by minimum square distance
%to which value of the alphabet it is closer:
for i = 1 : 1 : length(S_sig)
for j = 1 : 1 : length(s_2)
D(j,1) = (S_sig(i,1) - s_2(j,1))^2;
end
for k = 1 : 1 : length(D)
if(D(k,1) == min(D))
out(i,1) = s_2(k,1);
end
end
end
% Μετατροπη των συμβολων σε δυαδικο
%bin_out=de2bi(out,'left-msb');
%    bin_out = bin_out.';
%   bin_out = bin_out(:).';
% Αφαιρεση των μηδενικων που προστεθηκαν
%if md>0
%    zer=lng-length(bin_seq);
%    bin_out((lng-zer)+1:lng)=[];
%end
%
%% ΥΠΟΛΟΓΙΣΜΟΣ BER και SER
%
%ber=0;
ser=0;
%for q=1:length(bin_seq)
%   if bin_seq(q)==~bin_out(q)
%        ber=ber+1;
%    end
%end
for v=1:length(dec_seq)
    if dec_seq(v)==out(v)
        ser=ser+1;
   end
end
%BER=ber/length(bin_seq);
SER=(length(dec_seq)-ser)/length(dec_seq);
fprintf('Για Μ=%d', M);
fprintf(' και SNR=%d το BER είναι:\n αντίστοιχα το SER είναι:%d\n\n', SNR_db, SER);
%