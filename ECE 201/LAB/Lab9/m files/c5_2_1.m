% 5.2.1 Freq response of the 3 points averager

% a. Derivation of the freq response of the filter:
% x[n] = A*exp(j*w*n + phi)
% y[n]    = 1/3*x[n] + 1/3*x[n-1] + 1/3*x[n-2]
%         = 1/3*A*(exp(j*w*n + phi) + exp(j*w*(n-1) + phi) + exp(j*w*(n-2) + phi))
%         = 1/3*A*(exp(j*w*n + phi) + exp(j*w*n + phi)*exp(-j*w) + exp(j*w*n + phi)*exp(-j*2*w))
%         = 1/3*A*exp(j*w*n + phi)*(1 + exp(-j*w) + exp(-j*2*w))
%  H  = 1/3*(1 + exp(-j*w) + exp(-j*2*w))
%     = 1/3*exp(-j*w)*(exp(j*w) + 1 + exp(-j*w))
%     = 1/3*exp(-j*w)*(2*cos(w) + 1)
 
% b & c
ww = -pi:(pi/200):pi;
H1 = ((2*cos(ww)+1)/3).*exp(-j*ww);
subplot(2,2,1);
plot(ww,abs(H1));
xlabel('w');
ylabel('Magnitude');
title('Question 3');
subplot(2,2,2);
plot(ww,angle(H1));
xlabel('w');
ylabel('Phase');
title('Question 3');
% c
bb = 1/3*ones(1,3);
H2 = freqz(bb,1,ww);
subplot(2,2,3);
plot(ww,abs(H2));
xlabel('w');
ylabel('Magnitude');
title('Question 4');
subplot(2,2,4);
plot(ww,angle(H2));
xlabel('w');
ylabel('Phase');
title('Question 4');
