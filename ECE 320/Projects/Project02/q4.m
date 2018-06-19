%---------------------------------------------------------
%% 4.1.b
%---------------------------------------------------------
wc = 0.304*pi;
fs = 22050;

[h1, n1] = fir_lpf(wc, 14, @rectwin);
[H1, f1] = freqz(h1, 1, 1024, 'whole', fs);
figure;
subplot(1,2,1);
plot(f1, abs(H1));grid;
axis([0 4500 0.8 1.2]);
title('rectwin'); xlabel('f'); ylabel('Magnitude');
subplot(1,2,2);
plot(f1, abs(H1));grid;
axis([3000 5000 0 0.3]);
title('rectwin'); xlabel('f'); ylabel('Magnitude');

[h2, n2] = fir_lpf(wc, 18, @bartlett);
[H2, f2] = freqz(h2, 1, 1024, 'whole', fs);
figure;
subplot(1,2,1);
plot(f2, abs(H2));grid;
axis([0 4500 0 1]);
title('bartlett'); xlabel('f'); ylabel('Magnitude');
subplot(1,2,2);
plot(f2, abs(H2));grid;
axis([3000 5500 0 0.3]);
title('bartlett'); xlabel('f'); ylabel('Magnitude');

[h3, n3] = fir_lpf(wc, 39, @hanning);
[H3, f3] = freqz(h3, 1, 1024, 'whole', fs);
figure;
subplot(1,2,1);
plot(f3, abs(H3));grid;
axis([0 4500 0.9 1.01]);
title('hanning'); xlabel('f'); ylabel('Magnitude');
subplot(1,2,2);
plot(f3, abs(H3));grid;
axis([3000 5000 0 0.1]);
title('hanning'); xlabel('f'); ylabel('Magnitude');


[h4, n4] = fir_lpf(wc, 49, @hamming);
[H4, f4] = freqz(h4, 1, 1024, 'whole', fs);
figure;
subplot(1,2,1);
plot(f4, abs(H4));grid;
axis([0 3100 0.99 1.01]);
title('hamming'); xlabel('f'); ylabel('Magnitude');
subplot(1,2,2);
plot(f4, abs(H4));grid;
axis([3100 4000 0 0.01]);
title('hamming'); xlabel('f'); ylabel('Magnitude');

[h5, n5] = fir_lpf(wc, 72, @blackman);
[H5, f5] = freqz(h5, 1, 1024, 'whole', fs);
figure;
subplot(1,2,1);
plot(f5, abs(H5));grid;
axis([0 3100 0.99 1.001]);
title('blackman'); xlabel('f'); ylabel('Magnitude');
subplot(1,2,2);
plot(f5, abs(H5));grid;
axis([3000 4000 0 0.01]);
title('blackman'); xlabel('f'); ylabel('Magnitude');
%---------------------------------------------------------
%% Phase
%---------------------------------------------------------
figure(3);
subplot(5,1,1);
plot(f1, phase(H1));
title('rectwin'); xlabel('f'); ylabel('Phase');
figure(3);
subplot(5,1,2);
plot(f2, phase(H2));
title('bartlett'); xlabel('f'); ylabel('Phase');
figure(3);
subplot(5,1,3);
plot(f3, phase(H3));
title('hanning'); xlabel('f'); ylabel('Phase');
figure(3);
subplot(5,1,4);
plot(f4, phase(H4));
title('hamming'); xlabel('f'); ylabel('Phase');
figure(3);
subplot(5,1,5);
plot(f5, phase(H5));
title('blackman'); xlabel('f'); ylabel('Phase');
%---------------------------------------------------------
%% 4.1.c.i
%---------------------------------------------------------
load noisysig.mat;
soundsc(xnoisy, fs);
% It's a male cartoon voice but there were a lot of noise.
%---------------------------------------------------------
%% 4.1.c.ii
%---------------------------------------------------------
y1 = filter(h1, 1, xnoisy);
y2 = filter(h2, 1, xnoisy);
y3 = filter(h3, 1, xnoisy);
y4 = filter(h4, 1, xnoisy);
y5 = filter(h5, 1, xnoisy);
subplot(6,1,1);
plot(xnoisy);
title('Noisy signal'); xlabel('w'); ylabel('Magnitude');
subplot(6,1,2);
plot(y1);
title('Filtered w/ Rectangular'); xlabel('w'); ylabel('y1');
subplot(6,1,3);
plot(y2);
title('Filtered w/ Bartlett'); xlabel('w'); ylabel('y2');
subplot(6,1,4);
plot(y3);
title('Filtered w/ Hanning'); xlabel('w'); ylabel('y3');
subplot(6,1,5);
plot(y4);
title('Filtered w/ Hamming'); xlabel('w'); ylabel('y4');
subplot(6,1,6);
plot(y5);
title('Filtered w/ Blackman'); xlabel('w'); ylabel('y5');
%---------------------------------------------------------
%% 4.1.c.iii
%---------------------------------------------------------
%% rectangular
soundsc(y1, fs); % still has lot of noise
%% bartlett
soundsc(y2, fs); % a bit less noise as compare to the rectangular
%% hanning
soundsc(y3, fs); % still noise but it's small
%% hamming
soundsc(y4, fs); % still noise but it's small
%% blackman
soundsc(y5, fs); % all noises are filtered
% It says: "in this town we obey the law of thermal dynamic"
%---------------------------------------------------------
%% 4.1.c.iv
%---------------------------------------------------------
% done above

%---------------------------------------------------------
%% 4.2.a
%---------------------------------------------------------
load proj2_clip.mat
soundsc(clip, Fs);
%---------------------------------------------------------
%% 4.2.b
%---------------------------------------------------------
M = 100;
% filter 1
[f1, n] = fir_lpf(2*pi*220/Fs, M, @blackman);
[F1, w] = freqz(f1, 1, 1024, 'whole', Fs);
figure;
plot(w, abs(F1));
% filter 2
[f2, n] = bandpass(220, 440, Fs, M, @blackman);
[F2, w] = freqz(f2, 1, 1024, 'whole', Fs);
figure;
plot(w, abs(F2));
% filter 3
[f3, n] = bandpass(440, 880, Fs, M, @blackman);
[F3, w] = freqz(f3, 1, 1024, 'whole', Fs);
figure;
plot(w, abs(F3));
% filter 4
[f4, n] = bandpass(880, 1760, Fs, M, @blackman);
[F4, w] = freqz(f4, 1, 1024, 'whole', Fs);
figure;
plot(w, abs(F4));
% filter 5
[f5, n] = bandpass(1760, 3520, Fs, M, @blackman);
[F5, w] = freqz(f5, 1, 1024, 'whole', Fs);
figure;
plot(w/pi, abs(F5));
% filter 6
[f6, n] = highpass(3520, Fs, M, @blackman);
[F6, w] = freqz(f6, 1, 1024, 'whole', Fs);
figure;
plot(w, abs(F6));
%---------------------------------------------------------
%% 4.2.c
%---------------------------------------------------------
soundsc(clip, Fs);
%% lower pass filter 220Hz
yf1 = filter(f1, 1, clip);
soundsc(yf1, Fs);
%% bandpass 220Hz-440Hz
yf2 = filter(f2, 1, clip);
soundsc(yf2, Fs);
%% bandpass 440-880Hz
yf3 = filter(f3, 1, clip);
soundsc(yf2, Fs);
%% bandpass 880-1760Hz
yf4 = filter(f4, 1, clip);
soundsc(yf2, Fs);
%% bandpass 1760-3520Hz
yf5 = filter(f5, 1, clip);
soundsc(yf5, Fs);
%% highpass 3520Hz
yf6 = filter(f6, 1, clip);
soundsc(yf6, Fs);
