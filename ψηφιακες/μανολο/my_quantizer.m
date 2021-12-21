function [yQ] = my_quantizer(y,N,min_value,max_value)
    lvl=2^N;
    D=(abs(min_value)+abs(max_value))/lvl;
    R=cell(lvl,1);
    center=zeros(lvl,1);
    yQ=zeros(size(y));
    for i=0:lvl-1
        R{i+1}=[min_value+D*i min_value+D*(i+1)];
        center(i+1)=(R{i+1}(1)+R{i+1}(2))/2;
    end
    
    for j=1:size(y,1)
        if y(j)<min_value
            yQ(j)=min_value;
        elseif y(j)>max_value
                yQ(j)=max_value;
        else     
            for i=1:lvl
                if  (y(j)>=R{i}(1) && y(j)<=R{i}(2))
                    yQ(j)=center(i);
                    break;
                end  
            end
        end
    end
end