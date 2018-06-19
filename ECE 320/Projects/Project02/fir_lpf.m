%---------------------------------------------------------
% 2.e
%---------------------------------------------------------
function [h,n] = fir_lpf(wc, M, winfxn)
% Function to implement window design of lowpass filters
% wc : cutoff frequency
% M : integer that defines the length of the filter L = 2*M + 1
% winfxn : a string which contains the name of the window function to use
%       example: @blackman, @hamming, ...
%       notice the '@' right infront of each function name
    n1 = -M:-1;
    n2 = 1:M;
    n0 = 0;
    L = 2*M+1;
    h_n1 = sin(wc*n1)./(pi*n1);
    h_lhopital = wc*cos(wc*n0)/pi;
    h_n2 = sin(wc*n2)./(pi*n2);
    hlpf = [h_n1 h_lhopital h_n2];
    n = [n1 n0 n2];
    w = feval(winfxn, L);
    h = w'.*hlpf;
    