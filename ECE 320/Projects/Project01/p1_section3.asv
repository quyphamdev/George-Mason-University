%--------------------------------------------------------------------------
%% Question 3. Filtering of a Noisy Audio signal
%--------------------------------------------------------------------------
% 3.a:
%--------------------------------------------------------------------------
% load proj1_data.mat
%soundsc(sig);
% it sound like the sound of an insect cicada making :D
sound(sig,fs);
% it sound like the static sound.
%--------------------------------------------------------------------------
% 3.b:
%--------------------------------------------------------------------------
L = 10;
% the input signal and impulse reponse is in nx1 matrix
% so we need to do transpose(h) and transpose(sig) to convert them to 1xn
% matrix before plug them in oafilt() function.
y = oafilt(h.',sig.',L);
sound(y,fs);
% No difference when changing block length L
% I heard a song. The word "Hallelujah".
%%
subplot(2,1,1);
n = 0:length(sig)-1;
plot(n,sig);
title('The Noisy Audio Signal');xlabel('time');ylabel('Input Signal');
subplot(2,1,2);
n = 0:length(y)-1;
plot(n,y);
title('Audio Signal after filtering');xlabel('time');ylabel('y[n]');
