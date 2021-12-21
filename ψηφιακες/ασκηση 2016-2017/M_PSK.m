%Προσομοίωση Ομόδυνου Ζωνοπερατού Συστήματος M PSK
%gray encoding <- =1 Για κωδικοποίηση Gray / =0 Για απλή κωδικοποίηση
gray_encoding = 0;
%input size <- Μέγεθος διανύσματος του σήματος
input_size= 4;
%Αλφάβητο σήματος εισόδου
alphabet = [0 1];
%Δημιουργία σήματος με ισοπίθανη εμφάνιση συμβόλων αλφαβήτου
input_binary = randsrc(input_size , 1, alphabet);
%for M = 4:4:8
M=8;
%Ομάδα απο m bits
bits = log2(M);
for SNR = 0:2:16
%Υποσύστημα Mapper
[input_symbols, input_size, modulo] = my_mapper(input_binary, bits, gray_encoding);
%Υποσύστημα Modulator
[s_m] = my_modulator(input_symbols, M);
%Υποσύστημα Καναλιού AWGN
[signal_AWGN] = my_AWGN(M, SNR, input_size, s_m);
%Υποσύστημα Demodulator
[r] = my_demodulator(signal_AWGN);
%Υποσύστημα Detector
[output_symbols] = my_detector(r, M);
%Υποσύστημα Demapper
[output_binary] = my_demapper(output_symbols, input_size, bits, gray_encoding);
%Αφαίρεση των επιπλέων bits μηδενικών που προστέθηκαν
if (modulo ~=0)
output_binary(length(input_binary)+1:input_size) = [];
end
output_binary = output_binary';
%Υπολογισμός BER
bits_error = 0;
for i = 1:length(input_binary)
if (input_binary(i) ~= output_binary(i))
bits_error = bits_error + 1;
end
end
PSK_BER(M/4, SNR/2+1) = bits_error/length(input_binary)
end
%end