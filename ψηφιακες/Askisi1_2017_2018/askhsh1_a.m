%% ΑΣΚΗΣΗ 1
%% Α ΜΕΡΟΣ
% Μελετη αποδοσης Ομοδυνου Ζωνοπερατου Συστηματος M-PΑΜ
%
%% ΕΙΣΟΔΟΣ
% Αριθμος bit εισοδου
n=1e5;
% τυχαια δυαδικη ακολουθια μηκους n
% με χρηση της συναρτησης rand
bin_seq = round(rand(1,n));
%
%% MAPPER
% μετατροπη των bits του bin_seq σε log2(M)-bit συμβολα
%
for gray=[0 1]
for M=[2 8]
% καθε k=log2(M) bit αντιστοιχουν σε ενα συμβολο
k=log2(M);
% Στην περιπτωση του Μ=8 μπορει το μηκος της δυαδικης ακολουθιας να μην
% διαιρειται ακριβως με το log2(m) δηλαδη το 3 οποτε τοτε θα συμπληρωσουμε
% στην αρχη της ακολουθιας μηδενικα ωστε να γινεται η διαιρεση και να μην
% αλλαζει η αρχικη ακολουθια
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
% χρηση της reshape ωστε σε καθε γραμμη να υπαρχουν k=log2(M) bits% 
bin_seq1=reshape(bin_seq2,k,lng/k)';
% μετατροπη καθε γραμμης(log2(M) bit) σε εναν ακεραιο
dec_seq=bi2de(bin_seq1,'left-msb');
% χρηση κωδικοποιησης gray οταν η μεταβλητη gray εχει τιμη 1
if gray==1
    gray_enc=bin2gray(dec_seq,'pam',M);
    sm=gray_enc;
else sm=dec_seq;
end
%
%% MODULATOR
% Διαμορφωση 
%
% Σύμφωνα με τους τυπους του βιβλιου τα Α θα πάρουν τις παρακατω τιμες
if M==2
    A=1;
elseif M==8
    A=1/sqrt(21);
end
% παιρνουμε 4 δειγματα ανα περιοδο φερουσας
% καθε περιοδος συμβολου περιλαμβανει 10 κυκλους
% φερουσας δηλαδη 40 δειγματα οποτε η περιοδος
% συμβολου θα ειναι
Tsym=40;
Tc=4;
fc=1/Tc;
% ορθογωνιος παλμος gt ο οποιος εχει σταθερη
% τιμη για την περιοδο που θα εξετασουμε
gt=sqrt(2/Tsym);
sm=reshape(sm,1,lng/k);
% τα συμβολα  θα ειναι Μ οποτε θα αντιστοιχισουμε
% καθε ακεραιο με ενα πλατος ωστε να εχει μια θεση στο χωρο
% επειτα θα γινει πολλαπλασιασμος του καθε
% πλατους με τον ορθογωνιο παλμο gt 
% και με το συνημιτονο
n=length(sm);
for i=1:n
    for l=1:M
        if sm(i)==(l-1);
            m=l;
            % ορισμος του Am=(2m − (Μ + 1))A, m = 1, . . , Μ
            Am(i)=((2*m)-(M+1))*A;
                for t=1:41
                    s(t,i)=Am(i)*gt*cos(2*pi*fc*(t-1));             
                end
        end
    end
end
%
%% AWGN
% προσθηκη θορυβου
%
% ενεργεια ανα συμβολο
Es=1;
% ενεργεια ανα bit
Eb=Es/log2(M);
% το SNR μας δινεται στο ερωτημα
for SNR=0:2:20
% διασπορα θορυβου
sigma2=Eb/(2*(10^(SNR/10)));
% θορυβος
noise=sqrt(sigma2)*randn((lng/log2(M))*41,1);% καλυτερα σκετο length(s)
noise_1=reshape(noise,41,[]);
rt= s + noise_1;
%
%% DEMODULATOR
% Αποδιαμορφωση του σηματος
%
Tsym=40;
Tc=4;
fc=1/Tc;
% ορθογωνιος παλμος gt ο οποιος εχει σταθερη
% τιμη για την περιοδο που θα εξετασουμε
gt=sqrt(2/Tsym);
% Πολλαπλασιασμος ορθογωνιου παλμου με φερουσα
    for t=1:41
        p(t)=gt*cos(2*pi*fc*(t-1));
    end
% Συσχετισμος σηματος με το γινομενο παλμου-φερουσας
r=p*rt;
%
%% ΦΩΡΑΤΗΣ
% Προβλεψη συμβολου
%
% Υπολογισμος των συμβολων δηλαδη του Am
for m=1:M
    Am2(m)=((2*m)-(M+1))*A;
end
% για το σημα που προεκυψε απο τον demodulator γινεται ελεγχος καθε φορα
% απο ποιο Am θα εχει την μικροτερη αποσταση
for j=1:length(r)
    % Βαζουμε για αρχικοποιηση της ελαχιστης τιμης για την ελαχιστη αποσταση
    %μια πολυ μεγαλη τιμη ωστε να γινει παρακατω σωστα η συγκριση
    apostash_min = 1e100;
    for a=0:M-1   
        % υπολογισμος ευκλειδιας αποστασης του διανυσματος απο τα συμβολα
        % ωστε το συμβολο Am απο το οποιο θα εχει την μικροτερη αποσταση θα
        % ειναι το Am που του αντιστοιχει και το m που αντιστοιχει σε
        % αυτο το συμβολο Am θα ειναι η αντιστοιχη αρχικη εισοδος
        apostash(a+1) = sqrt((r(j)-Am2(a+1))^2);
        if (apostash(a+1) < apostash_min)
            apostash_min = apostash(a+1);
            sm_1=a;
        end
    end  
    sm_out(j)=sm_1;
end
%
%% Demapper
% Εαν το k ειναι 1 δηλαδη το Μ=2 τοτε η εξοδος sm2 θα ειναι και η τελικη
% μας εξοδος αντιθετα για Μ=8 χρειαζεται να κανουμε αποκωδικοποιηση απο gray και μετατροπη των
% δεκαδικων σε bit ωστε να εχουμε την προβλεψη της αρχικης ακολουθιας
if k==1
    bin_out=sm_out;
elseif k>1
    if gray==1
    % αποκωδικοποιηση απο κωδικοποιηση gray
    bin_out=gray2bin(sm_out,'pam',8);
    bin_out=de2bi(bin_out,'left-msb');
    bin_out = bin_out.';
    bin_out = bin_out(:).';
    elseif gray==0
    % μετατροπη απο ακεραιους σε δυαδικο
    bin_out=de2bi(sm_out,'left-msb');
    bin_out = bin_out.';
    bin_out = bin_out(:).';
    end
end
% Αφαιρεση των μηδενικων που προστεθηκαν
if md>0
    zer=lng-length(bin_seq);
    bin_out((lng-zer)+1:lng)=[];
end
%
%% Υπολογισμος BER και SER
%
%--------Dokimh------------
ber=0;
ser=0;
for q=1:length(bin_seq)
    if bin_seq(q)==~bin_out(q)
        ber=ber+1;
    end
end
for v=1:length(sm)
    if sm(v)==sm_out(v)
        ser=ser+1;
    end
end
BER=ber/length(bin_seq);
SER=(length(sm)-ser)/length(sm);
%--------------------------
%[berrors,bratio] = biterr(bin_seq,bin_out);
%[serrors,sratio] = symerr(sm,sm_out);
%w=w+1;
%berr(w)=bratio;
%serr(w)=sratio;
fprintf('Για Μ=%d', M);
if gray==1
    fprintf(' με χρήση κωδικοποίησης gray');
end
fprintf(' και SNR=%d το BER είναι:%d\n αντίστοιχα το SER είναι:%d\n\n', SNR, BER, SER);%berr(w), serr(w));
%
end % του SNR
% υπολογισμος σφαλματος
% αρχικοποιηση των s και sm2 σε 0 στο τελος της καθε εκτελεσης
% καθως παρατηρηθηκε οτι μετα απο καθε
% εκτελεση επηρεαζονταν οι επομενες εκτελεσεις προκαλωντας σφαλματα
s=0;
sm_out=0;
end % της for M=[2 8]
end
