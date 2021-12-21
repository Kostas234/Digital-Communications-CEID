function signal_AWGN = my_AWGN(M, SNR, input_size, s_m)
%Μ <- Το πλήθος των συμβόλων
%SNR <- Signal-to-Noise ratio
%input size <- Μέγεθος διανύσματος του σήματος
%s m <- Διαμορφωμένο Σήμα
%Ενέργεια ανά bit
E_b = 1/log2(M);
%Διασπορά θορύβου
var = E_b/((2*10)ˆ(SNR/10));
%Υπολογισμός του AWGN
noise = sqrt(var)*randn((input_size/log2(M))*40,1);
%Υπολογισμός του σήματος που θα παραληφθεί από τον δέκτη
%Αρχικό Σήμα + AWGN
dim = size(s_m);
signal_AWGN = s_m + reshape(noise, dim(1),dim(2));
end
end