%---------------------------------------------------------
%% Highpass function
%---------------------------------------------------------
function [h, n] = highpass(f, fs, M, winfxn)
% produce a high pass impulse response
% f : cutoff frequency (Hz)
% fs : sampling frequency
% M : L=M*2+1: window length
% winfxn : a string of window function name
    wc = pi-2*pi*f/fs;
    [hlpf, n] = fir_lpf(wc, M, winfxn);
    h = hlpf.*cos(pi*n);
    