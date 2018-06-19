% 5.3.2 First Differnce Filter
A = 7;
phi = pi/3;
w = 0.125*pi;
n = 0:49;
xx = A*cos(w*n + phi);
bb = [5 -5];
yy = firfilt(bb,xx);
% a.
length_yy = length(xx) + length(bb) - 1;
% 51 = 50 + 2 -1
% b.
subplot(2,1,1);
stem(xx);grid;
xlabel('Samples');
ylabel('xx');
title('x[n]');
subplot(2,1,2);
stem(yy);grid;
xlabel('Samples');
ylabel('yy');
title('y[n]');
% c.
% Amplitude = 7
% phi = -2*pi*t/T = -2*pi*(-3)/16 = 0.375*pi
% d.
% because at first sample y[0] = 5*x[0] - 5*x[-1]
% x[-1] is undefined so it assumes x[-1] = 0
% so y[0] = 5*x[0] = 5*7*cos(pi/3) = 17.5
% e.
% Amplitude = 14
% Freq f = 1/T = 1/16s = 0.0625 Hz
% phi = -w*t = -2*pi*f*t = -2*pi*0.0625*(-6) = 0.75*pi
% f.
% The relative amplitude: A(rel) = Ay/Ax = 14/7 = 2
% The relative phase: phi(rel) = phi(y) - phi(x) = 0.75*pi - 0.375*pi =
% 0.375*pi
% g.
% Amplitude
abs(5-5*exp(-j*0.125*pi))
% ans = 1.9509
% Phase
angle(5-5*exp(-j*0.125*pi))
% ans = 1.374

