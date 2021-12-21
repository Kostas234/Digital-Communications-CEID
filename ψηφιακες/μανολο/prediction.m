function [ y1 ] = prediction(yQ1,n,p,a)
    
    y1(n)=0;
    for i=1:p
        y1(n) = y1(n) + a(i)*yQ1(n-i);
    end
    y1=y1(n);
   
end