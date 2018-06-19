function xx = bell(ff, Io, tau, dur, fsamp)
%BELL  produce a bell sound
%
%usage: xx = bell (ff, Io, tau, dur, fsamp)
% 
%where: ff = frequency vector (containing fc and fm)
%       Io = scale factor for modulation index
%       tau = decay parameter for A(t)and I(t))
%       dur = duration (in sec.) of the output signal
%       fsamp = sampling rate

%fc = 110; % fc and fm raio 1:2 to create bell sound
%fm = 220;
fc = ff(1);
fm = ff(2);
tt = 0:(1/fsamp):dur;
phi_c = -pi/2;
phi_m = -pi/2;
At = bellenv(tau, dur, fsamp);
It = Io*bellenv(tau, dur, fsamp);
xx = At.*cos(2*pi*fc*tt + It.*cos(2*pi*fm*tt + phi_m) + phi_c);
