%Υλοποίηση του διαμορφωτή
%input symbols <- Συμβολική ακολουθία του σήματος
%Μ <- Το πλήθος των συμβόλων
function [s_m] = my_modulator(input_symbols, M)
%Σε κάθε περίοδο φέρουσας κρατάμε 4 δείγματα και
%κάθε περίοδο συμβόλου περιλαμβάνει 40 δείγματα
M=2;
input_symbols=[0 1 0 0 1 1 0 1 0];
t_sumbol = 40;
t_c = 4;
f_c = 1/t_c;
%Ορθογώνιος παλμός
g_t = sqrt(2/t_sumbol);
%Υπολογισμός 2 συνιστωσών για κάθε σύμβολο
for m = 0:M-1
s(m+1,1) = cos(2*pi*m/M);
s(m+1,2) = sin(2*pi*m/M);
end
%Υπολογισμός του ζωνοπερατού σήματος
for i = 1:length(input_symbols)
for t = 1:t_sumbol
s_m(i,t) = s((input_symbols(i)+1),1)* g_t *cos(2*pi*f_c*t) + s((input_symbols(i)+1),2)* g_t *sin(2*pi* f_c *t);
end
end
end