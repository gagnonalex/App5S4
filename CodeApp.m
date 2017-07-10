close all
clear all
clc
zeros = [ 1  -3.914 7.643 -9.551 8.717 -5.637 2.074];
pole = [ 1  0.3696 0.04];
%% filtre app , comme on inverse filtre de depart alors

zi = pole;
pi = zeros
figure('name','zplane initial')
zplane(zi,pi)

[x,fe] = audioread('phrase_malentendant_bruite.wav');
yi = filter(zi, pi, x);

figure('name','freqz')
freqz(zi,pi);
figure('name','plot')
plot(yi);

%% rendre filtre stable : comme les zeros sont  correct, oncorrige les poles
p = [0.99*pi(1) 0.99*pi(2) 1/pi(3) 1/pi(4) 1/pi(5) 1/pi(6) 1/pi(7)] 




figure('name','filtre stable')
zplane(zi,p);
% ypt = filter(z, p, x)
 figure('name','filtre passe tout freqz')
freqz(zi,p);

%% eliminer le bruit 


