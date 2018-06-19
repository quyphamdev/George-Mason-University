%% Question 1
% diary LAB3

%% Question 2
% a.
% Independent variable is the time vector located at the first column.
% Dependent variables are Flap4,Flap5,Vane6 and Vane7 located at columns
% 2nd,3rd,4th and 5th respectively.
% b.
% The sample period is the time increasement T = 0.004s.
% c.
% The sample frequency is f = 1/T.

%% Question 3
% use dlmread function to read all the datas of independent and dependent
% variables in a 'ServoLoadData.txt' file which is located in same folder as
% this *.m file.
% - The 2nd parameter is delimeter. In the data file, all the data are
% saperated by tab so tab is a delimeter and the syntax is '\t'.
% - The 3rd and 4th parameters are row and column where data is started
% (start with 0)
data = dlmread('ServoLoadData.txt','\t',22,0);

%% Question 4
size(data)

%% Question 5
t = data(:,1);
flap4 = data(:,2);
flap5 = data(:,3);
vane6 = data(:,4);
vane7 = data(:,5);
subplot(2,2,1);
plot(t,flap4);
xlabel('Time t');
ylabel('Flap4');
title('Flap4 vs. Time');
subplot(2,2,2);
plot(t,flap5);
xlabel('Time t');
ylabel('Flap5');
title('Flap5 vs. Time');
subplot(2,2,3);
plot(t,vane6);
xlabel('Time t');
ylabel('Vane6');
title('Vane6 vs. Time');
subplot(2,2,4);
plot(t,vane7);
xlabel('Time t');
ylabel('Vane7');
title('Vane7 vs. Time');

%% Question 6
% max, min, average values and standard deviation for 5 variables
% Time,Flap4,Flap5,Vane6 and Vane7.
max(data,[],1)
min(data,[],1)
mean(data,1)
std(data,0,1)
