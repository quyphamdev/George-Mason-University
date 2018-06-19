% 5.3.4 Time-Invariance of the filter
A = 7;
phi = pi/3;
w = 0.125*pi;
n = 0:49;
xx = A*cos(w*n + phi);
bb = [5 -5];
yy = firfilt(bb,xx);

xs = 7*cos(0.125*pi*(n-3)+(pi/3));
ys = firfilt(bb,xs);
subplot(2,1,1);
plot(n+3,yy(1:50));grid;
title('y(n)');
subplot(2,1,2);
plot(n,ys(1:50));grid;
title('ys(n)');