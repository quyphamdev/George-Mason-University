% 5.3.3 Linearity of the filter
% a.
A = 7;
phi = pi/3;
w = 0.125*pi;
n = 0:49;
xx = A*cos(w*n + phi);
bb = [5 -5];

xa = 2*xx;
ya = firfilt(bb,xa);
subplot(2,1,1);
plot(n,xa);grid;
title('xa(n)');
subplot(2,1,2);
plot(n,ya(1:50));grid;
title('ya(n)');
% The relative amplitude is: 2 
% And the relative phase: 0.375*pi
% b.
xb = 8*cos(0.25*pi*n);
yb = firfilt(bb,xb);
subplot(2,1,1);
plot(n,xb);grid;
title('xb(n)');
subplot(2,1,2);
plot(n,yb(1:50));grid;
title('yb(n)');
% The relative amplitude A = Ay/Ax = 30/8 = 3.75
% The relative phase = phi(y) - phi(x) = 3*pi/8 - 0 = 0.375*pi
% The amplitude and freq stay the same, only the phase is changed.
% c.
xc = xa + xb;
yc = firfilt(bb,xc);
subplot(2,1,1);
plot(yc);grid;
title('yc(n)');
subplot(2,1,2);
plot(ya+yb);grid;
title('ya(n)+yb(n)');
