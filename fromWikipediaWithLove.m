clc
clear
close all
%Playing with the wikipedia math.
%The splines are defined as functions of a piece wise interval t, that
%spans 0-1 in local space, and is mapped to a dimension when evaluated.
%https://en.wikipedia.org/wiki/Cubic_Hermite_spline
t=2;
%Lets set up the basis functions
h00=2*t^3 - 3*t^2 +1;
h10=t^3 - 2*t^2 + t;
h01=-2*t^3 + 3*t^2;
h11=t^3-t^2;

global elemPoints 
global testCoords
global ns
%For continious splines, the value of m1 at t_k must equalt m0 at t_k+1
%there are a number of schemes for determining the value of gradients to 
%match the data, we will start with the finite difference method
%mk = 1/2((pk+1-pk)/(t_k+1 - tk) + (pk-pk-1)/(t_k - tk-1)
CHderiv(t,t)

%the hermite equation then takes the form 
%p(t)=h00*p0 + h10*m0+h01*p1+h11*m1
%where p represents a spatial dimension, p0 is the position of that
%dimension at t=0 of the interval, and p1 is the position at t=1. m0 is the
%gradient at t0 and m1 at t=1

%some play around code for 1 element of x

x0=1;
x1=2;
m0=1;
m1=2;

tInt=linspace(0,1,1000);
for i=1:length(tInt)
    t=tInt(i);
    h00=2*t^3 - 3*t^2 +1;
    h10=t^3 - 2*t^2 + t;
    h01=-2*t^3 + 3*t^2;
    h11=t^3-t^2;
    p(i)=h00*x0+h10*m0+h01*x1+h11*m1;
end

plot(tInt,p)

%so for a 2D closed contour, you have n elements, and each element will
%have a x and y spline, so x0,x1,y0,y1,mx0,mx1,my0,my1 data. Lets start
%with two elements
elem1=[2,3,2,1;6,0,0,-1];
elem2=[3,2,1,-2;0,-6,-1,0];


%now calculate p1x, p1y,p2x, p2y
numP=30;
tInt=linspace(0,1,numP);
[x1,y1,xd1,yd1]=plotElem(elem1,numP);
[x2,y2,xd2,yd2]=plotElem(elem2,numP);

figure(2)
subplot(3,2,1)
plot(tInt,x1,'-b')
subplot(3,2,2)
plot(tInt,y1,'-r')
subplot(3,2,3)
plot(tInt,x2,'-b')
subplot(3,2,4)
plot(tInt,y2,'-r')
subplot(3,2,5)
hold on
plot([tInt,(tInt+1)],[x1,x2],'-b')
plot([0,1],[x1(1),x2(1)],'ob')
subplot(3,2,6)
hold on
plot([tInt,(tInt+1)],[y1,y2],'-r')
plot([0,1],[y1(1),y2(1)],'or')

figure(3)
subplot(3,2,1)
plot(tInt,xd1,'-b')
subplot(3,2,2)
plot(tInt,yd1,'-r')
subplot(3,2,3)
plot(tInt,xd2,'-b')
subplot(3,2,4)
plot(tInt,yd2,'-r')
subplot(3,2,5)
hold on
plot([tInt,(tInt+1)],[xd1,xd2],'-b')
plot([0,1],[xd1(1),xd2(1)],'ob')
subplot(3,2,6)
hold on
plot([tInt,(tInt+1)],[yd1,yd2],'-r')
plot([0,1],[yd1(1),yd2(1)],'or')



figure(4)
hold on
plot([x1,x2],[y1,y2],'xb')
plot([x1(1),x1(end),x2(1),x2(end)],[y1(1),y1(end),y2(1),y2(end)],'or')
axis('equal')
sP=[x1,x2;y1,y2]';

%Now we are going to spoof some fake data to try and match
testElem1=[2,3,2,1;8,0,0,-1];
testElem2=[3,2,1,-2;0,-8,-1,0];
testNumP=60;
tInt=linspace(0,1,testNumP);
[tx1,ty1,~,~]=plotElem(testElem1,testNumP);
[tx2,ty2,~,~]=plotElem(testElem2,testNumP);
testCoords=[tx1,tx2;ty1,ty2]';
plot(testCoords(:,1),testCoords(:,2),'.k')

%Set up a KD tree of the testCoords
ns=createns(testCoords,'nsmethod','kdtree');
[idx,dist]=knnsearch(ns,sP,'k',1);
for i=1:length(sP)
    plot([sP(i,1),testCoords(idx(i),1)],[sP(i,2),testCoords(idx(i),2)],'-g')
end

%now lets try fit a function, we need the points to be global

%elem1=[2,3,2,1;6,0,0,-1];
%elem2=[3,2,1,-2;0,-6,-1,0];
elemPoints=[2,2;3,1;2,-2];
mInit=[6,0,-6;0,-1,0]; %in the form mx;my

%lets test the min function
testR=minFunction(mInit);

[mOut,fval,exitflag]=fminunc('minFunction',mInit);

%lets check the result
elem1=[elemPoints(1,1),elemPoints(2,1),elemPoints(1,2),elemPoints(2,2);
       mOut(1,1),mOut(1,2),mOut(2,1),mOut(2,2)];
elem2=[elemPoints(2,1),elemPoints(3,1),elemPoints(2,2),elemPoints(3,2);
       mOut(1,2),mOut(1,3),mOut(2,2),mOut(2,3)];
   
[x1,y1,~,~]=plotElem(elem1,1000);
[x2,y2,~,~]=plotElem(elem2,1000);
points=[x1,x2;y1,y2]';
plot(points(:,1),points(:,2),'-c')
   












