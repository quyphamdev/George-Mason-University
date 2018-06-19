%--------------------------------------------------------------------------
%% Question 2: Block convolution
%--------------------------------------------------------------------------
% 2.a: 
%--------------------------------------------------------------------------
ny = 0:99;
nh = 0:9;
h = (0.9).^nh;
nx = 0:90; % ny - nh
x = ones(1,91);
figure;
subplot(3,1,1);
stem(nh,h);
title('Section 2.a.i: Impulse response h[n]');xlabel('time');ylabel('h[n]');
subplot(3,1,2);
stem(nx,x);
title('Input Signal x[n]');xlabel('time');ylabel('x[n]');
%--------------------------------------------------------------------------
% 2.a.i:
%--------------------------------------------------------------------------
y = conv(h,x);
subplot(3,1,3);
stem(ny,y);
title('The Convolution: y[n]=h[n]*x[n]');xlabel('time');ylabel('y[n]');
%--------------------------------------------------------------------------
% 2.a.ii:
%--------------------------------------------------------------------------
IL = 100; % whole input length
L = 50; % block length
x0 = ones(1,L);
y0 = conv(h,x0);
x1 = ones(1,L);
y1 = conv(h,x1);
% L(y1) = L(x1) + L(h) - 1 = 50+10-1 = 59
% shift y1 by M = L+1 = 51
y1_shifted = [zeros(1,L) y1];
y0 = [y0 zeros(1,L)]; % need to be in the same length as y1_shifted
y = y0 + y1_shifted;
figure;
subplot(3,1,1);
ny0 = 0:(length(y0)-1);
stem(ny0,y0);
title('Section 2.a.ii: Block 1');xlabel('time');ylabel('y1[n]');
subplot(3,1,2);
ny1 = 0:(length(y1_shifted)-1);
stem(ny1,y1_shifted);
title('Block 2');xlabel('time');ylabel('y2[n]');
subplot(3,1,3);
% L(y1_shifted) = 50+59 = 109.
ny = 0:(length(y)-1); % 109 points
stem(ny,y);
title('Overlap-add Block Convolution');xlabel('time');ylabel('y[n]');

%--------------------------------------------------------------------------
% 2.b.i:
%--------------------------------------------------------------------------
% function y = oafilt(h,x,L)
