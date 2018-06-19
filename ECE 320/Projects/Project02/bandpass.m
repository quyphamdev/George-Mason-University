%---------------------------------------------------------
%% Bandpass function
%---------------------------------------------------------
function [h, n] = bandpass(fl, fh, fs, M, winfxn)
% produce a band pass impulse response
% fl,fh : left and right cutoff frequency (Hz)
% fs : sampling frequency
% M : L=M*2+1: window length
% winfxn : a string of window function name
    wh = 2*pi*fh/fs;
    wl = 2*pi*fl/fs;
    wc = (wh-wl)/2;
    w0 = wc+wl;
    [hlpf, n] = fir_lpf(wc, M, winfxn);
    h = hlpf.*cos(w0*n)*2;
    