close all
clear all
clc

zero = [ 1  -3.914 7.643 -9.551 8.717 -5.637 2.074];
pole = [ 1  0.3696 0.04];
%% filtre app , comme on inverse filtre de depart alors

z_initial = pole;
p_initial = zero;
% figure('name','zplane initial non inverse')
% zplane(z_initial,p_initial);
% figure
% freqz(z_initial,p_initial);
% title('zplane initial non inverse')

[son_bruite,fe] = audioread('bruite.wav');
[son_original,fe] =  audioread('original.wav');

%% rendre filtre stable : comme les zero sont  correct, on corrige les poles
pr = roots(p_initial)
p = [.95*pr(1) .95*pr(2) 1/pr(3) 1/pr(4) 1/pr(5) 1/pr(6) ] % rendre le filtre stable a main

p_stable = poly(p)*15;

% figure('name','filtre stabiliser inverse')
% zplane(z_initial,p_stable);
% figure('name','filtre stabiliser inverse')
% freqz(z_initial,p_stable);
% figure
y_stable = filter(z_initial,p_stable,son_bruite);

%% composition RIF

module_filtre = abs(freqz(z_initial,p_stable,512/2));
% stem(module_filtre);

RIF4 = RIF_creator(module_filtre,4);
RIF8 = RIF_creator(module_filtre,8);
RIF16 = RIF_creator(module_filtre,16);


subplot(3,1,1)
plot(RIF4);
subplot(3,1,2)
plot(RIF8);
subplot(3,1,3)
plot(RIF16);

figure('name', 'rif 4-8-16')
subplot(3,1,1)
filtre_RIF4 = fftshift(ifft(RIF4));
plot(abs(filtre_RIF4));

subplot(3,1,2)
filtre_RIF8 = fftshift(ifft(RIF8));
plot(abs(filtre_RIF8));

subplot(3,1,3)
filtre_RIF16 = fftshift(ifft(RIF16));
plot(abs(filtre_RIF16));

figure('name', 'filtrer avec inverse stable');
subplot(4,1,1)
plot (son_bruite);
title('son bruite')
subplot(4,1,2)

convRIF4 = conv(son_bruite,abs(filtre_RIF4));
filtRIF4 = filter(abs(filtre_RIF4),1,son_bruite);
filtRIF8 = filter(abs(filtre_RIF8),1,son_bruite);
filtRIF16 = filter(abs(filtre_RIF16),1,son_bruite);

plot(filtRIF4);
title('filtre impulsion RIF4 passer dans filter');


subplot(4,1,3)
plot(y_stable);
title('filtre impulsion avec filtre inverse s tabiliser');



 %% eliminer le bruit  : prendre fft des 800 premier et 800 dernier
% 
bruit_debut = son_bruite(1:1000);
bruit_fin = son_bruite(length(son_bruite)-1000 : length(son_bruite));

fft_debut = fft(bruit_debut, fe);
fft_fin = fft(bruit_fin, fe);

% figure('name', 'fft debut')
% stem(abs(fft_debut)); 
% 
% figure('name', 'fft fin')
% stem(abs(fft_fin));

freq_attenuer = [900 915 930 1300 1315 1330]% dependant le bruit au depart et la fin

%utilisant  Euler on isole ces frequences en trouvant des zero a ces
zero_coupeB = [ exp((freq_attenuer(1)*2*pi)/fe*i) exp((freq_attenuer(2)*2*pi)/fe*i) exp((freq_attenuer(3)*2*pi)/fe*i) exp((freq_attenuer(4)*2*pi)/fe*i) exp((freq_attenuer(5)*2*pi)/fe*i) exp((freq_attenuer(6)*2*pi)/fe*i)];

zero_coupeB = [zero_coupeB, conj(zero_coupeB)];

pole_CoupeB = 0.9275*zero_coupeB;

a_CoupeB = poly(pole_CoupeB);
b_CoupeB = poly(zero_coupeB); 

% figure('name', 'plane filtre debruiteur')
% zplane(b_CoupeB,a_CoupeB);
% figure('name', 'freqz filtre debruiteur')
% freqz(b_CoupeB,a_CoupeB);



%% test son

subplot(4,1,1);
plot(son_bruite,'r');
title('Son Bruite');

s_debruitrer = filter(b_CoupeB,a_CoupeB,son_bruite);
subplot(4,1,2);
plot(s_debruitrer,'b');
title('Son debruiter par RII');

s_debruiterRIF4 = filter(abs(filtre_RIF4),1,s_debruitrer);
s_debruiterRIF8 = filter(abs(filtre_RIF8),1,s_debruitrer);
s_debruiterRIF16 = filter(abs(filtre_RIF16),1,s_debruitrer);
s_debruiterRII = filter(z_initial,p_stable,s_debruitrer);

subplot(4,1,3);
plot(s_debruiterRII,'g');
title('Son debruiter par RII + RIF4');

hold on;
subplot(4,1,4);
plot(son_bruite,'r');
plot(s_debruiterRII,'g');
plot(s_debruitrer,'b');
hold off

soundsc(s_debruiterRII, fe);
title('comparaison des trois sons');


%% 4
normSignalFiltrer = s_debruiterRII;
normSignalOriginal = son_original;

%soustrait
moySignalBruite = mean(normSignalFiltrer);
moySignalOriginal = mean(normSignalOriginal);

bruit = normSignalFiltrer - moySignalBruite;
original = normSignalOriginal - moySignalOriginal;

figure
plot(bruit)

%normaliser
maxSignalBruite = max(abs(bruit));
maxSignalOriginal = max(abs(original));

normSignalFiltrer = bruit/maxSignalBruite;
normSignalOriginal = original/maxSignalOriginal;

%Synchroniser
t1 = (0:length(normSignalFiltrer)-1)/fe;
t2 = (0:length(normSignalOriginal)-1)/fe;

[corrCroise, lag] = xcorr(normSignalFiltrer, normSignalOriginal);

[~,I] = max(abs(corrCroise));
lagDiff = lag(I);

timeDiff = lagDiff/fe;

figure
plot(lag,corrCroise)

normSignalFiltrer = normSignalFiltrer(timeDiff+1:end);
t1al = (0:length(normSignalFiltrer)-1)/fe;

startTime = 1.287*10^4;
endTime = 4.963*10^4;

normSignalFiltrer = normSignalFiltrer(startTime:endTime);
bruit = bruit(startTime:endTime);
normSignalOriginal = normSignalOriginal(startTime:endTime);



figure
subplot(3,1,1)
plot(normSignalFiltrer, 'r')
title('Filtrer, aligned')

subplot(3,1,2)
plot(normSignalOriginal, 'g')
title('Original sans bruit')
xlabel('Time (s)')

% Soustraction des parties utiles
bruit = normSignalOriginal - normSignalFiltrer;
subplot(3,1,3)
plot(normSignalFiltrer, 'r')
hold on
plot(normSignalOriginal, 'g')
hold on
plot(bruit)

maxBound = 36761;

%Calcul RSB
sumFiltrer = sum(normSignalFiltrer.^2);
sumBruit = sum(bruit.^2);
RSB = 10*log(sumFiltrer/sumBruit)

%Calcul RSB Trapeze
puissanceFiltrer = 1/maxBound*(trapz(abs(normSignalFiltrer)).^2);
puissanceBruit = 1/maxBound*(trapz(abs(bruit)).^2);
RSBTrapeze = 10*log(puissanceFiltrer/puissanceBruit)

%Calcul RSB Simpson
puissanceFiltrer = 1/maxBound*((1/3*(abs(normSignalFiltrer(1)) + abs(normSignalFiltrer(maxBound)) + 4*sum(abs(normSignalFiltrer(3:2:maxBound-2))) + 2*sum(abs(normSignalFiltrer(2:2:maxBound-1)))))^2);
puissanceBruit = 1/maxBound*((1/3*(abs(bruit(1)) + abs(bruit(maxBound)) + 4*sum(abs(bruit(3:2:maxBound-2))) + 2*sum(abs(bruit(2:2:maxBound-1)))))^2);

RSBSimpson = 10*log(puissanceFiltrer/puissanceBruit)

