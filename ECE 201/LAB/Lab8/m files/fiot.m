function [tt,fi_t] = fiot(ff, Io, tau, dur, fsamp)
%
% usage:
% 3. Ploting fi(t)
%
%where: ff = frequency vector (containing fc and fm)
%       Io = scale factor for modulation index
%       tau = decay parameter for A(t)and I(t))
%       dur = duration (in sec.) of the output signal
%       fsamp = sampling rate
%
% return:
%       tt = time vector
%       fi(t)
%
fc = ff(1);
fm = ff(2);
tt = 0:(1/fsamp):dur;
phi_m = -pi/2;
It = Io*bellenv(tau, dur, fsamp);
fi_t = fc - It*fm.*sin(2*pi*fm*tt) + 1/(2*pi)*(-Io/tau)*exp(-tt/tau).*cos(2*pi*fm*tt);