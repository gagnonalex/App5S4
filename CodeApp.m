close all
clear all
%% filtre app

zeros = [1 -3.914 7.643 -9.551 8.717 -5.637 2.074];
pole = [1 0.3696 0.04];
zplane(pole,zeros)

[x,fe] = audioread('phrase_malentendant_bruite.wav');
y = filter(pole, zeros, x);

figure('name','freqz')
freqz(pole,zeros);
figure('name','plot')
plot(y);

%filtre passe tout


