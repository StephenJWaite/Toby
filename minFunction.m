%m, the derivatives of the contour splines to be changed
%x1,x2,y1,y2 are the fixed points of contour
%ns KD tree of target data

function r=minFunction(m)
global ns
global elemPoints

%step one, construct elements
elem1=[elemPoints(1,1),elemPoints(2,1),elemPoints(1,2),elemPoints(2,2);
       m(1,1),m(1,2),m(2,1),m(2,2)];
elem2=[elemPoints(2,1),elemPoints(3,1),elemPoints(2,2),elemPoints(3,2);
       m(1,2),m(1,3),m(2,2),m(2,3)];
%step two calculate the points from m
[x1,y1,~,~]=plotElem(elem1,10);
[x2,y2,~,~]=plotElem(elem2,10);
points=[x1,x2;y1,y2]';
ns;
%now calculate the closet distance points
[~,dist]=knnsearch(ns,points,'k',1);
r=sum(dist.^2);


