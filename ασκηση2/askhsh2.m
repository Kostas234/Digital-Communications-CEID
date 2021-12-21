%% ΑΣΚΗΣΗ 2
% Εξομοίωση Τηλεπικοινωνιακού Συστήματος Βασικής Ζώνης
%
%% ΕΙΣΟΔΟΣ
% Αριθμος bit εισοδο
%n=1e4;
%n=100003;
n=6;
% τυχαια δυαδικη ακολουθια μηκους n
% με χρηση της συναρτησης rand
bin_seq = round(rand(1,n));
%
% μετατροπη των bits του bin_seq σε log2(M)-bit συμβολα
%
%for M=[4 8]
M=8;
% καθε k=log2(M) bit αντιστοιχουν σε ενα συμβολο
k=log2(M);
% το μηκος της δυαδικης ακολουθιας να μην % διαιρειται ακριβως με το log2(m)
% οποτε τοτε θα συμπληρωσουμε στην αρχη της ακολουθιας μηδενικα ωστε να γινεται
% η διαιρεση χωρις να αλλαζει η αρχικη ακολουθια
bin_seq2=0;
md=mod(n,k);
if md>0
    if mod(n+1,log2(M))~=0 
        c=n+2;
    elseif mod(n+2,log2(M))~=0
        c=n+1;
    end
        for z=1:c
            if z>n
                bin_seq2(z)=0;
            else
            bin_seq2(z)=bin_seq(z);
            end
        end     
elseif md==0
        bin_seq2=bin_seq;
end
lng=length(bin_seq2);
% χρηση της reshape ωστε σε καθε γραμμη να υπαρχουν k=log2(M) bits
bin_seq1=reshape(bin_seq2,k,lng/k)';
% μετατροπη καθε γραμμης(log2(M) bit) σε εναν ακεραιο
dec_seq=bi2de(bin_seq1,'left-msb');
%
%% ΔΙΑΜΟΡΦΩΣΗ ΕΙΣΟΔΟΥ
%
Es=1;
sm=reshape(dec_seq,1,lng/k);
% τα συμβολα  θα ειναι Μ οποτε θα αντιστοιχισουμε
% καθε ακεραιο με δυο συνιστωσες ωστε να εχει μια θεση στο χωρο
n=length(sm);
for i=1:n
    for l=1:M
        if sm(i)==(l-1);
            m=l;
                s1(i)=sqrt(Es)*cos((2*pi*m)/M);
                s2(i)=sqrt(Es)*sin((2*pi*m)/M);
        end
    end
end
% Συνθεση μιγαδικου αριθμου με τις δυο συνιστωσες
s_in=complex(s1,s2);
% Υπερδειγματοληψια του σηματος με βαση τον ρυθμο της εκφωνησης
s=upsample(s_in,4);
% Αφαιρουνται τα επιπλεον μηδενικα που ειναι στο τελος
s(length(s)-2:length(s))=[];
%
%% ΦΙΛΤΡΟ ΠΟΜΠΟΥ
%
% Κατασκευη του φιλτρου με χρηση της συναρτησης rcosdesign
b=rcosdesign(0.3,6,4,'sqrt');
% Περναμε το σημα μεσα απο το φιλτρο που δημιουργησαμε με χρηση
% της συναρτησης conv
s_f=conv(s,b);
%
%% ΦΙΛΤΡΟ ΚΑΝΑΛΙΟΥ
%
% Ελεγχος αν το καναλι ειναι ιδανικο
% Για idl=1 ειναι ιδανικο για idl=0 οχι
idl=1;
if idl==0;
% Θα γινει συνελιξη με το παρακατω ιδανικο καναλι
h=[0.04 -0.05 0.07 -0.21 -0.5 0.72 0.36 0 0.21 0.03 0.07];
% Υπερδειγματοληψια του σηματος με βαση τον ρυθμο της εκφωνησης
h_ups=upsample(h,4);
% Αφαιρεση των 3 περιττων μηδενικων στο τελος
h_ups=h_ups(7:length(h_ups)-6);
% Συνελιξη του σηματος με το ιδανικο καναλι με χρηση της συναρτησης conv
s_f=conv(s_f,h_ups);
end
%
%% ΘΟΡΥΒΟΣ
% προσθηκη θορυβου
%
%for SNR=0:2:30
SNR=0; %--dokimh--
% Παιρνουμε το μετρο των στοιχειων του σηματος
s_f_abs=abs(s_f);
% Υπολογισμος της μεσης ισχυος του σηματος
P_S=0;
for i=1:length(s_f)
P_S=P_S + s_f_abs(i)^2;
end
P_S=P_S/length(s_f);
% Υπολογισμος της μεσης ισχυος του θορυβου για τα διαφορα SNR
% η οποια ειναι το τετραγωνο της διασπορας του θορυβου
P_N=P_S/(10^(SNR/10));
% Υπολογισμος θορυβου
noise1=randn(length(s_f),1);
% Στη περιπτωση των μιγαδικων αστερισμων ο θορυβος θα πρεπει
% να προστεθει στο πραγματικο και στο φανταστικο μερος των συμβολων
%ωστε το πραγματικο και το φανταστικο μερος να εχουν αλλοιωθει
% απο θορυβο διασπορας σ^2/2=P_N/2
if(isreal(s_f)==0)
    noise1=(noise1 + j*randn(length(s_f),1))/sqrt(2);
end
% Εξισωση θορυβου
noise=sqrt(P_N)*noise1;
% Προσθηκη του θορυβου στο σημα
s_f_n=s_f+noise';
%
%% ΔΕΚΤΗΣ
%
% Ο δεκτης εχει το ιδιο φιλτρο με τον πομπο
s_r=conv(s_f_n,b);
% Υποδειγματοληψια του σηματος
s_r_d=downsample(s_r,4);
s_r_d(7:length(s_r_d)-6)=[];
%
% Υπολογισμος της καθυστερησης για να αφαιρεθει
if idl==0
    delay=2*((length(b)-1)/2)+((length(h_ups)-1)/2);
elseif idl==1
    delay=2*((length(b)-1)/2);
end
% Αφαιρεση της καθυστερησης
s_r=s_r(delay+1:length(s_r)-delay);
%% ΔΙΑΤΑΞΗ ΑΠΟΦΑΣΗΣ
%
% Υπολογισμος των συμβολων
for m=1:M
        s1_2(m)=sqrt(Es)*cos((2*pi*m)/M);
        s2_2(m)=sqrt(Es)*sin((2*pi*m)/M);
end
% Συνθεση μιγαδικου αριθμου με τις δυο συνιστωσες
s_2=complex(s1_2,s2_2);
%s_r_d=s_r_d';
%s_2=s_2';
%s_out = zeros(length(s_r_d),1);
%D = zeros(length(s_2),1);
%for each element of the signal vector, decide by minimum square distance
%to which value of the alphabet it is closer:
%for i = 1 : 1 : length(s_r_d)
%for j = 1 : 1 : length(s_2)
%D(j,1) = (s_r_d(i,1) - s_2(j,1))^2;
%end
%for k = 1 : 1 : length(D)
%if(D(k,1) == min(D))
%s_out(i,1) = s_2(k,1);
%end
%end
%end
% για το σημα που προεκυψε μετα την υποδειγματοποιηση 
%γινεται ελεγχος καθε φορα απο ποιο συμβολο θα εχει την μικροτερη αποσταση
for j=1:length(s_r_d)
    % Βαζουμε για αρχικοποιηση της ελαχιστης τιμης για την ελαχιστη αποσταση
    % μια πολυ μεγαλη τιμη ωστε να γινει παρακατω σωστα η συγκριση
    apostash_min = 1e100;
    for a=0:M-1   
        % υπολογισμος ευκλειδιας αποστασης του διανυσματος απο τα συμβολα
        % ωστε το συμβολο απο το οποιο θα εχει την μικροτερη αποσταση θα
        % ειναι το συμβολο που του αντιστοιχει και το m που αντιστοιχει σε
        % αυτο το συμβολο θα ειναι η αντιστοιχη αρχικη εισοδος
        apostash(a+1) = sqrt((s_r_d(j)-s_2(a+1))^2);
        if (apostash(a+1) < apostash_min)
            apostash_min = apostash(a+1);
            out=a;
        end
    end  
    s_out(j)=out;
end
% Μετατροπη των συμβολων σε δυαδικο
bin_out=de2bi(s_out,'left-msb');
    bin_out = bin_out.';
    bin_out = bin_out(:).';
% Αφαιρεση των μηδενικων που προστεθηκαν
if md>0
    zer=lng-length(bin_seq);
    bin_out((lng-zer)+1:lng)=[];
end
%
%% ΥΠΟΛΟΓΙΣΜΟΣ BER και SER
%
ber=0;
ser=0;
for q=1:length(bin_seq)
    if bin_seq(q)==~bin_out(q)
        ber=ber+1;
    end
end
for v=1:length(dec_seq)
    if dec_seq(v)==s_out(v)
        ser=ser+1;
   end
end
BER=ber/length(bin_seq);
SER=(length(s_in)-ser)/length(s_in);
fprintf('Για Μ=%d', M);
fprintf(' και SNR=%d το BER είναι:%d\n αντίστοιχα το SER είναι:%d\n\n', SNR, BER, SER);
%

%end % του SNR
%s_in=0;
%s_out=0;
%clear
%
%end % της for M=[4 8]

