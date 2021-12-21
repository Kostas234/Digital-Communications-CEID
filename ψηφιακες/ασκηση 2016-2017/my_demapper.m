%Υλοποίηση του demapper
%output symbols <- Συμβολική ακολουθία του ληφθέν σήματος
%input size <- Μέγεθος διανύσματος του αρχικού σήματος
%bits <- Αριθμός bits κάθε ομάδας συμβόλου
%gray encoding <- =1 Για κωδικοποίηση Gray / =0 Για απλή κωδικοποίηση
function [output_binary] = my_demapper(output_symbols, input_size,bits, gray_encoding)
%Μετατροπή των δεκαδικών τιμών στα αντίστοιχα δυαδικά log2(M) bits
output_binary(1:input_size) = reshape(de2bi(output_symbols(:)', 'right-msb')', input_size, 1);
%Μετατροπή των δεκαδικών τιμών στα αντίστοιχα δυαδικά log2(M) bits (Gray)
%και μετατροπή των κωδικοποιήσεων Gray στις αντίστιχες δυαδικές
if (gray_encoding == 1)
output_gray = gray2bin(output_symbols, 'psk', 2^bits);
output_binary(1:input_size) = reshape(de2bi(output_gray(:)', 'right-msb')', input_size, 1);
end
end