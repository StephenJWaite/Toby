function [x,y,xd,yd]=plotElem(elem,numP)
    tInt=linspace(0,1,numP);
    for i=1:length(tInt)
        t=tInt(i);
        h00=2*t^3 - 3*t^2 +1;
        h10=t^3 - 2*t^2 + t;
        h01=-2*t^3 + 3*t^2;
        h11=t^3-t^2;
        x(i)=h00*elem(1,1)+h10*elem(2,1)+h01*elem(1,2)+h11*elem(2,2);
        y(i)=h00*elem(1,3)+h10*elem(2,3)+h01*elem(1,4)+h11*elem(2,4);
        
        %now calculate their derivatives
        h00=6*t^2 - 6*t;
        h10=3*t^2 - 4*t + 1;
        h01=-6*t^2 + 6*t;
        h11=3*t^2-2*t;
        xd(i)=h00*elem(1,1)+h10*elem(2,1)+h01*elem(1,2)+h11*elem(2,2);
        yd(i)=h00*elem(1,3)+h10*elem(2,3)+h01*elem(1,4)+h11*elem(2,4);
        
    end
    
end