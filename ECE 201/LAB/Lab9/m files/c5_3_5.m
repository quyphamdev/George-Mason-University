% 5.3.5 Cascading 2 systems
% a.
A = 7;
phi = pi/3;
w = 0.125*pi;
n = 0:49;
xx = A*cos(w*n + phi);

bb = [1 -1];
ww = xx.^2;
yy = firfilt(bb,ww);
% b.
subplot(3,1,1);
plot(n,xx(1:50));grid;
title('x(n)');
subplot(3,1,2);
plot(n,ww(1:50));grid;
title('w(n)');
subplot(3,1,3);
plot(n,yy(1:50));grid;
title('y(n)');
% f.
bb2=[1 -2*cos(0.25*pi) 1];
y2=firfilt(bb2,ww);
mm=0:51;
plot(mm,y2);grid;
title('y2(n)');
