%---------------------------------------------------------
%% 3.c
%---------------------------------------------------------
wc = pi/4;
[h, n] = fir_lpf(wc, 50, @blackman);
hnew = h.*cos(pi*n);
[Hnew, w] = freqz(hnew, 1, 1024, 'whole');
plot(w/pi, abs(Hnew));
title('Freq. Resp.'); xlabel('w'); ylabel('H_{new}');
%---------------------------------------------------------
%% 3.d.i
%---------------------------------------------------------
n = -pi:0.01:pi;
Hbp = ((n>=-2*pi/3)&(n<=-pi/6))|((n>=pi/6)&(n<=2*pi/3));
figure;
plot(n, Hbp);
axis([-4 4 0 1.2]);
title('Bandpass Filter'); xlabel('w'); ylabel('Magnitude');
%---------------------------------------------------------
%% 3.d.ii & iii
%---------------------------------------------------------
wc = pi/4;
[h, n] = fir_lpf(wc, 50, @blackman);
hnew = h.*cos(5*pi*n/12)*2;
figure;
plot(n, hnew);
title('Impulse Resp.'); xlabel('n'); ylabel('h');
[Hnew, w] = freqz(hnew, 1, 1024, 'whole');
figure;
plot(w/pi, abs(Hnew));
title('Bandpass Filter'); xlabel('w'); ylabel('H_{new}');
