%Κωδικοποίηση DPCM
%Ανάκτηση δεδομένων εισόδου
load source.mat;
%Αριθμός δειγμάτων στη μνήμη
p = 8;
%Αριθμός bits κβάντισης
bits = 3;
%Μέγεθος του αρχείου εισόδου
N = length(x);
%Υπολογισμός διανύσματος αυτοσυσχέτισης
for i = 1:p
sum = 0;
for n = p+1:N
sum = sum+x(n)*x(n-i);
end
r(i) = (1/(N-p))*sum;
end
r = r';
%Υπολογισμός πίνακα αυτοσυσχέτισης
for i = 1:p
for j = 1:p
sum = 0;
for n = p:N
sum = sum+x(n-j+1)*x(n-i+1);
end
R(i,j) = (1/(N-p+1))*sum;
end
end
%Υπολογισμός των συντελεστών του φίλτρου πρόβλεψης
a = inv(R)*r;
%Κβάντιση των συντελεστών
%a_quantum = my_quantizer(a,8,-2,2)';
a_quantum=[1.5 -1.5 1.5 -0.5 -0.5 0.5 0.5 -0.5];
%Θεωρούμε ότι τα p πρώτα δείγματα μεταδίδονται
%μη κβαντισμένα και χωρίς σφάλματα
%Αποθήκευση p αρχικών τιμών στη μνήμη
mem(1:p) = x(1:p)';
%Αποθήκευση p αρχικών τιμών που θα ληφθούν
y2(1:p) = mem(1:p);
%Υλοποίηση φίλτρου πρόβλεψης
for j = p+1:N
sum = 0;
for i = 1:p
sum = sum + a_quantum(i)*mem(j-i);
end
%Πρόβλεψη του δείγματος
prediction(j) = sum;
%Υπολογισμός σφάλματος πρόβλεψης
y1(j) = x(j)-prediction(j);
%Κβαντοποίηση του σφάλματος πρόβλεψης
y(j)=y1(j);
N=2;
min_value=-3.5;
max_value=3.5;
%
for v=1:length(y)
    y1(v)=0;
end
% Αριθμος επιπεδων κβαντισης
L=2^N;
% Βημα κβαντισης
D=2*(max_value/L);
% Κεντρα της καθε περιοχης
for i=1:L
    centers(i)= max_value-(i-1)*D-D/2;
end
% Υπολογισμος περιοχης που ανηκει καθε δειγμα εισοδου
%
lng=length(y);
for k=1:lng
    if y(k)>=max_value || y(k)>=max_value-y(k)
       y1(k) =1;
    elseif y(k)<max_value-y(k) && y(k)>0
        l=L/2;
        d=0;
        s=max_value-D/2;
        for j=1:2
            if y(k)<=D/2
                y1(k)=L/2;
            elseif y(k)<s && y(k)<s-j*D
                s=j*D+D/2;
                d=d+1;
            elseif y(k)>s-j*D
                disp(y(k));
                y1(k)= d;
            end
        end
    elseif y(k)<0 && y(k)>min_value+D
        l=L/2;
        d=0;
        s=max_value;
      for j=l:-1:1
            if y(k)>=-(D/2)
                y1(k)=(L/2)+1;
            elseif y(k)>-s && y(k)>(-j)*D
                s=((j-1)*(-D))-D/2;
                d=d+1;                
            elseif y(k)<=-j*D
                y1(k)= l + 2*d;
            end
        end     
    elseif y(k)<min_value || y(k)<min_value+D
       y1(k)= L;
    end
%
if y1(k)==0
    y1(k)=1;
end
% Κβαντισμενο δειγμα
y1(k)=centers(y1(k));
end  % της for k=1:lng
y1_quantum(j) = y1(j);
%Ανακατασκευή του δείγματος στο δέκτη
y2(j) = y1_quantum(j)+ prediction(j);
mem(j) = y2(j);
end