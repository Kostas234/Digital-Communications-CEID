%Υλοποίηση του mapper
%Αντιστοίχηση των log2(M) bits εισόδου σε Μ σύμβολα
%input binary <- Δυαδική ακολουθία σήματος
%bits <- Αριθμός bits κάθε ομάδας συμβόλου
%gray encoding <- =1 Για κωδικοποίηση Gray / =0 Για απλή κωδικοποίηση
function [input symbols, input size, modulo] = my mapper(input binary, bits, gray encoding)
input size = length(input binary);
%Υπολογισμός του πλήθους των bits που δεν σχηματίζουν ομάδα από log2(M) bits
modulo = mod(input size, bits) ;
%Τροποποίηση των τελευταίων bits του σήματος εισόδου, ώστε
%όλα τα bits να σχηματίζουν ομάδα από log2(M) bits
%=> mod(input size, bits) == 0
if (modulo ~= 0)
input size = input size - modulo;
for i = 1:modulo
temp(i) = input binary(input size+1);
end
%Συμπλήρωση με μηδενικά στα MSB του σήματος
for i = (modulo+1):bits
temp(i) = 0;
end
input binary((input size+1):(input size+bits)) = temp(:);
%Επαναϋπολογισμός του μήκους του διανύσματος εισόδου
%καθώς αυξήθηκε το μήκος του, προσθέτοντας bits μηδενικών
input size = length(input binary);
end
%Μετατροπή των δυαδικών log2(M) bits στις αντίστοιχες δυαδικές τιμές
2630 j = 1;
for i = 1:bits:input size
input symbols(j) = bi2de(input binary(i:i+bits-1)','right-msb');
j = j+1;
end
%Μετατροπή των δεκαδικών τιμών στις αντίστοιχες κωδικοποιήσεις gray
if (gray encoding == 1)
input symbols = bin2gray(input symbols, 'psk', 2ˆbits);
end
end