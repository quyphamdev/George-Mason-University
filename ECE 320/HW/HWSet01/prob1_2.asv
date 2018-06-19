%% a.
n = 0:9;
k = [1 2 4 6];
figure;
for id=1:4
wk = 2*pi*k(id)/5;
x = sin(wk.*n);
subplot(4,1,id);
stem(n,x);
title(['x_k[n]=sin(w_kn) with k = ',int2str(k(id))]);
xlabel('n');
ylabel('magnitude');
end

%% b.
N = 12;
M = [4 5 7 10 15];
n = 0:(2*N-1);
figure;
for id=1:5
x = sin(2*pi*M(id).*n/N);
subplot(5,1,id);
stem(n,x);
title(['x_M[n]=sin(2\piMn/N) with M = ',int2str(M(id))]);
xlabel('n');
ylabel('magnitude');
end

%% c.
N = 6;
n = 0:4*N;
x1 = cos(2*pi.*n/N) + 2*cos(3*pi.*n/N);
x2 = 2*cos(2.*n/N) + cos(3.*n/N);
x3 = cos(2*pi.*n/N) + 3*sin(5*pi.*n/(2*N));
figure;
subplot(3,1,1);
stem(n,x1);
title('x_1[n]=cos(2\pin/N)+2cos(3\pin/N)');
xlabel('n');
ylabel('magnitude');
subplot(3,1,2);
stem(n,x2);
title('x_2[n]=2cos(2n/N)+cos(3n/N)');
xlabel('n');
ylabel('magnitude');
subplot(3,1,3);
stem(n,x3);
title('x_3[n]=cos(2\pin/N)+3sin(5\pin/2N)');
xlabel('n');
ylabel('magnitude');
