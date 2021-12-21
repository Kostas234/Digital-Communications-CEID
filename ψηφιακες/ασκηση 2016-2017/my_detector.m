%Υλοποίηση του φωρατή
%r <- Διάνυσμα θέσης του ληφθέντος σήματος στο επίπεδο
%Μ <- Το πλήθος των συμβόλων
function output_symbols = my_detector(r, M)
%Υπολογισμός των 2 συνιστωσών του κάθε συμβόλου
for m = 0:M-1
s_m(m+1, 1) = cos((2*pi*m)/M);
s_m(m+1, 2) = sin((2*pi*m)/M);
end
%Εύρεση του συμβόλου που στάλθηκε
%Υπολογισμός της μικρότερης απόστασης μεταξύ των διανυσμάτων r & s m
%με τη χρήση της ευκλείδιας απόστασης
for i = 1:length(r)
%Αρχικοποίηση με τη μέγιστη τιμή
min = realmax;
%Αρχικοποίηση με την μικρότερη θέση
pos = 1;
 for j = 0:M-1
euclidean_dist(j+1, 1) = sqrt((r(i, 1)-s_m(j+1, 1))^2+(r(i, 2)-s_m(j+1, 2))^2);
if (euclidean_dist(j+1, 1) < min)
min = euclidean_dist(j+1, 1);
pos = j;
end
end
output_symbols(i, 1) = pos;
end
end