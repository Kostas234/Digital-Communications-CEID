%Υλοποίηση του αποδιαμορφωτή
%signal AWGN <- Το ληφθέν σήμα
function r = my_demodulator(signal_AWGN)
%Σε κάθε περίοδο φέρουσας κρατάμε 4 δείγματα και
%κάθε περίοδο συμβόλου περιλαμβάνει 40 δείγματα
t_symbol = 40;
t_c = 4;
f_c = 1/t_c;
%Ορθογώνιος παλμός
g_t = sqrt(2/t_symbol);
%Συσχέτιση της φέρουσας με τον ορθογώνιο παλμό
for t = 1:t_symbol
y_1(t,1) = g_t *cos(2*pi* f_c *t);
y_2(t,1) = g_t *sin(2*pi* f_c *t);
end
%Υπολογισμός του διανύσματος r
r_1 = signal_AWGN* y_1;
r_2 = signal_AWGN* y_2;
r = [r_1,r_2];
end