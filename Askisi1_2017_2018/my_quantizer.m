% Ομοιομορφος Κβαντιστης
%
% Συναρτηση κβαντιστη
function y1 = my_quantizer(y, N, min_value, max_value)
% Αρχικοποιηση της y1
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
    b=max_value-D;
    s=min_value+D;
    if y(k)>=b
       y1(k)=1;
    elseif y(k)<s
       y1(k)= L;
    elseif y(k)<b && y(k)>=0
        d=1;
        for j=0:((2^N)/2)-1 % τοσες επαναληψεις χρειαζεται για να 
                            % υπολογισει σωστα το κεντρο της περιοχης
            if y(k)<b-j*D
                d=d+1;
                y1(k)=d;
            end
        end
     elseif y(k)<0 && y(k)>=s
         d=L;
        for j=0:((2^N)/2)-1          
            if y(k)>=s+j*D
                d=d-1;
                y1(k)=d;
            end
        end
    end    
% Κβαντισμενο δειγμα
y1(k)=centers(y1(k));
end
%
end
%