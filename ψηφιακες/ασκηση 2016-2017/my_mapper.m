%Υλοποίηση του mapper
%Αντιστοίχηση των log2(M) bits εισόδου σε Μ σύμβολα
%input binary <- Δυαδική ακολουθία σήματος
%bits <- Αριθμός bits κάθε ομάδας συμβόλου
%gray encoding <- =1 Για κωδικοποίηση Gray / =0 Για απλή κωδικοποίηση
%function [input_symbols, input_size, modulo] = my_mapper(input_binary, bits, gray_encoding)
input_binary=[1 1 1 1 0 0 1 0 1 1 0 0 0 0 1 1 0 1 0 1];
bits=3
gray_encoding=1;
input_size = length(input_binary);
%Υπολογισμός του πλήθους των bits που δεν σχηματίζουν ομάδα από log2(M) bits
modulo = mod(input_size, bits) ;
%Τροποποίηση των τελευταίων bits του σήματος εισόδου, ώστε
%όλα τα bits να σχηματίζουν ομάδα από log2(M) bits
%=> mod(input size, bits) == 0
if (modulo ~= 0)
input_size = input_size - modulo;
for i = 1:modulo
temp(i) = input_binary(input_size+1);
end
%Συμπλήρωση με μηδενικά στα MSB του σήματος
for i = (modulo+1):bits
temp(i) = 0;
end
input_binary((input_size+1):(input_size+bits)) = temp(:);
%Επαναϋπολογισμός του μήκους του διανύσματος εισόδου
%καθώς αυξήθηκε το μήκος του, προσθέτοντας bits μηδενικών
input_size = length(input_binary);
end
%Μετατροπή των δυαδικών log2(M) bits στις αντίστοιχες δυαδικές τιμές
j = 1;
for i = 1:bits:input_size
input_symbols(j) = bi2de(input_binary(i:i+bits-1)','right-msb');
j = j+1;
end
%Μετατροπή των δεκαδικών τιμών στις αντίστοιχες κωδικοποιήσεις gray
if (gray_encoding == 1)
input_symbols = bin2gray(input_symbols, 'psk', 2^bits);
end
%end