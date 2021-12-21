clear;
%% initialization

x=load('source.mat');
x=x.x; %input signal

N=length(x)
min_=-3; % min of the quantizer
max_=3; % max of the quantizer
min_pr=-2; % min of the prediction quantizer
max_pr=2; % max of the prediction quantizer
pred_N=8; % number of bits for the prediction quantizer

y=zeros(N,1); %y = prediction error
yQ=zeros(N,1);% yQ = Q(y(n))
y1=zeros(N,1); % y1 = y' = prediction 
yQ1=zeros(N,1); % yQ1 =  y1+yQ
out=zeros(N,1); % output signal

%%
p=[4 5 6 7 8]; % P = number of previous values for prediction
QN=[1;2;3]; % QN = number of bits for the quantizer

%%
error=zeros(3,5);
out2=cell(3,1);
for k=1:5
    for i=1:3
        for n=1:N    

            if n<p(k)+1      
                %% transmitter
                y1(n)=0;
                y(n)=x(n)-y1(n);
                yQ(n) = my_quantizer(y(n),QN(i),min_,max_);        
                yQ1(n) = y1(n) + yQ(n);  

                %% receiver        
                out(n) =yQ1(n);
            else
                 %% transmitter         
                 % prediction factors calculation
                 if n==p(k)+1
                    a{i,k}= factor_calc(x,p(k),pred_N,min_pr,max_pr);
                 end

                y1(n) = prediction(yQ1,n,p(k),a{i,k});

                y(n)=x(n)-y1(n);

                yQ(n) = my_quantizer(y(n),QN(i),min_,max_);

                yQ1(n) = y1(n) + yQ(n);


                %% receiver        
                y1(n)= prediction(out,n,p(k),a{i,k});
                out(n) = y1(n)+yQ(n);
            end
        end
        error(i,k)=immse(x,y1);
    end
    out2{k}=out;
end

%% PLOTS

figure;
subplot(3,1,1);


plot(500:750,x(500:750),'color','r'); hold on;
plot(500:750,out2{1}(500:750),'color','b');

legend('x','y_reconstructed')
title('p=4 , No of Bits = 1')

subplot(3,1,2);
plot(500:750,x(500:750),'color','r'); hold on;
plot(500:750,out2{2}(500:750),'color','b');

legend('x','y_reconstructed')
title('p=4 , No of Bits = 2')

subplot(3,1,3);
plot(500:750,x(500:750),'color','r'); hold on;
plot(500:750,out2{3}(500:750),'color','b');

legend('x','y_reconstructed')
title('p=4 , No of Bits = 3')



