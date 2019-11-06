function valid = valid_config(map, q)
    if q(1)<1 || q(2) <1|| q(3) <1 ||q(4) <1
        valid=0;
    elseif q(1) > size(map,1) || q(3) > size(map,1)
        valid=0;
    elseif q(2) > size(map,2) || q(4) > size(map,2)
        valid=0;
        
    elseif q(1)==q(3) && q(2)==q(4)
        valid=0;
        
    elseif map(q(1),q(2))==1 
        valid=0;
    elseif map(q(3), q(4))==1
        valid=0;
    else
        valid=1;
    end
end