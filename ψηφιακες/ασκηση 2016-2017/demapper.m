%Υλοποίηση του demapper
%output symbols <- Συμβολική ακολουθία του ληφθέν σήματος
%input size <- Μέγεθος διανύσματος του αρχικού σήματος
%bits <- Αριθμός bits κάθε ομάδας συμβόλου
%gray encoding <- =1 Για κωδικοποίηση Gray / =0 Για απλή κωδικοποίηση
function [output binary] = my demapper(output symbols, input size,bits, gray encoding)
%Μετατροπή των δεκαδικών τιμών στα αντίστοιχα δυαδικά log2(M) bits
output binary(1:input size) = reshape(de2bi(output symbols(:)', 'right-msb')', input size, 1);
%Μετατροπή των δεκαδικών τιμών στα αντίστοιχα δυαδικά log2(M) bits (Gray)
%και μετατροπή των κωδικοποιήσεων Gray στις αντίστιχες δυαδικές
if (gray encoding == 1)
output gray = gray2bin(output symbols, 'psk', 2ˆbits);
output binary(1:input size) = reshape(de2bi(output gray(:)', 'right-msb')', input size, 1);
end
end