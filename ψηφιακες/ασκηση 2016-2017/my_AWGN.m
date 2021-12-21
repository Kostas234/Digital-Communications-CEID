%function signal_AWGN = my_AWGN(M, SNR, input_size, s_m)
%Μ <- Το πλήθος των συμβόλων
%SNR <- Signal-to-Noise ratio
%input size <- Μέγεθος διανύσματος του σήματος
%s m <- Διαμορφωμένο Σήμα
%Ενέργεια ανά bit
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
for SNR=0:2:20
%M=8;
E_b = 1/log2(M);
%Διασπορά θορύβου
var = E_b/((2*10)^(SNR/10));
%Υπολογισμός του AWGN
noise = sqrt(var)*randn((20/log2(2))*40,1);
%Υπολογισμός του σήματος που θα παραληφθεί από τον δέκτη
%Αρχικό Σήμα + AWGN
dim = size(s_m);
signal_AWGN = s_m + reshape(noise, 9,40);
end
%end