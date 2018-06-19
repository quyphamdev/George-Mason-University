%---------------------------------------------------------
% 2. FIR Filter Design via the Window method
%---------------------------------------------------------
%---------------------------------------------------------
%% 2.b
%---------------------------------------------------------
wrect11 = rectwin(11);
wrect51 = rectwin(51);
wrect101 = rectwin(101);
[W11, w11] = freqz(wrect11, 1, 1024, 'whole');
[W51, w51] = freqz(wrect51, 1, 1024, 'whole');
[W101, w101] = freqz(wrect101, 1, 1024, 'whole');
figure(1);
plot(w11/pi, abs(W11), 'b-', w51/pi, abs(W51), 'r--', w101/pi, abs(W101), 'g-.');
legend('11pts rectwin', '51pts rectwin', '101pts rectwin');
title('Frequency Response Magnitudes'); xlabel('w'); ylabel('W(e^{jw})');
axis([0 0.5 0 120]);

%---------------------------------------------------------
%% 2.c.i
%---------------------------------------------------------
wc = pi/3;
M = [5 25 50];
inc = 1;
for i=1:3
    n1 = -M(i):inc:-inc;
    n2 = inc:inc:M(i);
    n0 = 0;
    h_n1 = sin(wc*n1)./(pi*n1);
    h_lhopital = wc*cos(wc*n0)/pi;
    h_n2 = sin(wc*n2)./(pi*n2);
    h = [h_n1 h_lhopital h_n2];
    n = -M(i):inc:M(i);
    figure(2);
    subplot(3,1,i);
    stem(n, h);
    title(['h_',num2str(i),'[n] with ',num2str(M(i)*2+1),' pts']); xlabel('n'); ylabel('h[n]');
%---------------------------------------------------------
% 2.c.ii
%---------------------------------------------------------
    figure(3);
    subplot(3,1,i);
    [H, w] = freqz(h, 1, 1024, 'whole');
    plot(w/pi, abs(H));
    title(['H_',num2str(i),' with ',num2str(M(i)*2+1),' pts']); xlabel('w'); ylabel('H(e^{jw})');
    plot(w/pi, 10*log10(abs(H)));
    title(['Rectangular window with ',num2str(M(i)*2+1),' pts']); xlabel('w'); ylabel('20log10(abs(H))');
end
%---------------------------------------------------------
%% 2.d.i
%---------------------------------------------------------
n11 = -5:5;
wblkman11 = blackman(11);
n51 = -25:25;
wblkman51 = blackman(51);
n101 = -50:50;
wblkman101 = blackman(101);
figure(4);
subplot(3,1,1);
stem(n11, wblkman11);
title('Blackman window L=11');xlabel('n');ylabel('w');
subplot(3,1,2);
stem(n51, wblkman51);
title('Blackman window L=51');xlabel('n');ylabel('w');
subplot(3,1,3);
stem(n101, wblkman101);
title('Blackman window L=101');xlabel('n');ylabel('w');
%---------------------------------------------------------
% 2.d.ii
%---------------------------------------------------------
[Wbm11, w11] = freqz(wblkman11, 1, 1024, 'whole');
[Wbm51, w51] = freqz(wblkman51, 1, 1024, 'whole');
[Wbm101, w101] = freqz(wblkman101, 1, 1024, 'whole');
figure(5);
subplot(3,1,1);
plot(w11/pi, 10*log10(abs(Wbm11)));
title('Blackman Freq. Resp. Magnitudes L=11'); xlabel('w'); ylabel('20log10(abs(W))');
subplot(3,1,2);
plot(w51/pi, 10*log10(abs(Wbm51)));
title('Blackman Freq. Resp. Magnitudes L=51'); xlabel('w'); ylabel('20log10(abs(W))');
subplot(3,1,3);
plot(w101/pi, 10*log10(abs(Wbm101)));
title('Blackman Freq. Resp. Magnitudes L=101'); xlabel('w'); ylabel('20log10(abs(W))');
%---------------------------------------------------------
%% 2.d.iii
%---------------------------------------------------------
wc = pi/3;
M = [5 25 50];
inc = 1;
for i=1:3
    n1 = -M(i):inc:-inc;
    n2 = inc:inc:M(i);
    n0 = 0;
    h_n1 = sin(wc*n1)./(pi*n1);
    h_lhopital = wc*cos(wc*n0)/pi;
    h_n2 = sin(wc*n2)./(pi*n2);
    hlpf = [h_n1 h_lhopital h_n2];
    n = [n1 n0 n2];
    wbm = blackman(M(i)*2+1);
    h = wbm'.*hlpf;
    figure(2);
    subplot(3,1,i);
    plot(n, h);
    title(['h with L=',num2str(M(i)*2+1)]); xlabel('n'); ylabel('h');
    [H, w] = freqz(h, 1, 1024, 'whole');
    figure(3);
    subplot(3,1,i);
    plot(w/pi, abs(H));
    title(['Blackman H_',num2str(i),' with ',num2str(M(i)*2+1),' pts']); xlabel('w'); ylabel('H(e^{jw})');
end
%---------------------------------------------------------
%% 2.f
%---------------------------------------------------------
M = [5 25 50];
wc = pi/3;
for i=1:3
    [h, n] = fir_lpf(wc, M(i), @blackman);
    subplot(3, 1, i);
    plot(n, h);
    title(['Function output with L=',num2str(M(i)*2+1)]); xlabel('n'); ylabel('h');
end

