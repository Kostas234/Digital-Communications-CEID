%Ομοιόμορφος κβαντιστής Ν δυαδικών ψηφίων
%y <- Τρέχων δείγμα
%N <- Αριθμός των bits
%max/min value <- Δυναμική περιοχή
function_y2 = my_quantizer(y, N, min_value, max_value)
% Υπολογισμός κέντρων κβαντισμού
D = max_value/2^(N-1);
%Υπολογισμός των κέντρων κάθε περιοχής
centers(1) = max_value-D/2;
centers(2^N) = min_value+D/2;
for i = 2:(2^N-1)
centers(i) = centers(i-1)-D;
end
%Υπολογισμός περιοχής στην οποία ανήκει το δείγμα
for j = 1:length(y)
if y(j) <= min_value
    y2(j) = 2^N;
elseif y(j) >= max_value
    y2(j) = 1;
elseif y(j) < 0
    y(j) = max_value + abs(y(j));
elseif y(j)>=0
    y(j) = max_value - y(j);
end
y2(j) = floor(y(j)/D)+1;
end
y2(j) = centers(y2(j));
%end
%end