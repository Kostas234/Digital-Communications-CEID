%Υλοποίηση του αποδιαμορφωτή
%signal AWGN <- Το ληφθέν σήμα
function r = my demodulator(signal AWGN)
%Σε κάθε περίοδο φέρουσας κρατάμε 4 δείγματα και
%κάθε περίοδο συμβόλου περιλαμβάνει 40 δείγματα
t symbol = 40;
t c = 4;
f c = 1/t c;
%Ορθογώνιος παλμός
g t = sqrt(2/t symbol);
%Συσχέτιση της φέρουσας με τον ορθογώνιο παλμό
for t = 1:t symbol
y 1(t,1) = g t *cos(2*pi* f c *t);
y 2(t,1) = g t *sin(2*pi* f c *t);
end
%Υπολογισμός του διανύσματος r
r 1 = signal AWGN* y 1;
r 2 = signal AWGN* y 2;
r = [r 1,r 2];
end