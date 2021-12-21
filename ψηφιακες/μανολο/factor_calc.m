function [ a ] = factor_calc( x,p,pred_N,min_Value,max_Value)
    N=length(x);
    r(p,1)= zeros;
    R(p,p)= zeros;
    
    for i=1:p
        r(i,1) = 0;
        for n=p+2:N 
            r(i,1) = r(i,1) + (1/(N-p-1))*x(n)*x(n-i);
        end
        
        for j=1:p
            R(i,j) = 0;
            for n=p+1:N 
                R(i,j) = R(i,j) + 1/(N-p )*x(n-j)*x(n-i);
            end
        end
    end

    a = R\r;
           
    for i=1:p
        a(i,1) =  my_quantizer(a(i),pred_N,min_Value,max_Value);
    end


end