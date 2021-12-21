% Διανυσμα αυτοσυσχετισης
% ειχα μπερδεψει πως θα παιρνει τιμες
%---DOKIMH----
%for k=1:3
%r1=0;
%for i=1:2
%r1=r1+i
%end
%r(k)=2*r1
%end
%--------
%
%
%
%--------------QUANTIZER--------------------------------------
% Αρχικοποιηση της y1
%y=a;
%N=2;
%min_value=-2;
%max_value=2;
%
%for v=1:length(y)
%    y1(v)=0;
%end
% Αριθμος επιπεδων κβαντισης
%L=2^N;
% Βημα κβαντισης
%D=2*(max_value/L);
% Κεντρα της καθε περιοχης
%for i=1:L
%    centers(i)= max_value-(i-1)*D-D/2;
%end
% Υπολογισμος περιοχης που ανηκει καθε δειγμα εισοδου
%
%lng=length(y);
%for k=1:lng
%    if y(k)>=max_value || y(k)>=max_value-D
%       y1(k) =1;
%    elseif y(k)<min_value || y(k)<min_value+D
%       y1(k)= L;
%    elseif y(k)<max_value-D && y(k)>=0
%        if y(k)<=D
%            y1(k)=L/2;
%        elseif y(k)>D && y(k)<2*D
%            y(k)=3;
%        elseif y(k)>=2*D
%            y1(k)= 2;
%        end
%    elseif y(k)<0 && y(k)>=min_value+D
%        if y(k)>=-D
%            y1(k)=(L/2)+1;
%        elseif y(k)<-D && y(k)>-2*D
%            y(k)=6;
%        elseif y(k)<=-2*D
%            y1(k)=7
%        end
%    end
%
% Κβαντισμενο δειγμα
%y1(k)=centers(y1(k));
%end  % της for k=1:lng
%a_quant=y1;
%
%---------------------------------------------------------------