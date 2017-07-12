close all
clear all
clc
zero = [ 1  -3.914 7.643 -9.551 8.717 -5.637 2.074];
pole = [ 1  0.3696 0.04];

[son_bruite,fe] = audioread('bruite.wav');
[son_original,fe] =  audioread('original.wav');

%% filtre app , comme on inverse filtre de depart alors

z_initial = pole;
p_initial = zero;
figure('name','zplane initial non inverse')
zplane(z_initial,p_initial);
title('filtre inverser non stable');
figure

 freqz(z_initial,p_initial)
 title('freqz filtre inverser non stable');
 test = filter(p_initial,z_initial,son_bruite);


% title('zplane initial non inverse')


%% rendre filtre stable : comme les zero sont  correct, on corrige les poles
pr = roots(p_initial)
% p = [.99*pr(1) .99*pr(2) 1/pr(3) 1/pr(4) 1/pr(5) 1/pr(6) ] %meilleur graphe de filtre
p = [.95*pr(1) .95*pr(2) 1/pr(3) 1/pr(4) 1/pr(5) 1/pr(6) ] %meilleur logique zplane
p_stable = poly(p)*10 ;

 figure('name','filtre stabiliser inverse')
zplane(z_initial,p_stable);
title('filtre stabiliser inverse ')
figure
freqz(z_initial,p_stable);
title('filtre stabiliser inverse ')

y_stable = filter(z_initial,p_stable,son_bruite);

%% composition RIF

module_filtre = abs(freqz(z_initial,p_stable,512/2));
figure('name','allo loloolo')
stem(module_filtre);
title('module filtre ')

RIF4 = RIF_creator(module_filtre,4);
RIF8 = RIF_creator(module_filtre,8);
RIF16 = RIF_creator(module_filtre,16);

figure
subplot(3,1,1)
plot(RIF4);
subplot(3,1,2)
plot(RIF8);
subplot(3,1,3)
plot(RIF16);

figure
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

convRIF4 = conv(son_bruite,abs(filtre_RIF4))
filtRIF4 = filter(abs(filtre_RIF4),1,son_bruite);

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

zero_coupeB = [zero_coupeB, conj(zero_coupeB)]

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
subplot(4,1,3);
plot(s_debruiterRIF16,'g');
title('Son debruiter par RII + RIF4');

hold on;
subplot(4,1,4);
plot(son_bruite,'r');
plot(s_debruiterRIF16,'g');
plot(s_debruitrer,'b');
hold off

% soundsc(s_debruiterRIF4,fe);
% pause(4);
% soundsc(s_debruiterRIF8,fe);
% pause(4);
% soundsc(s_debruiterRIF16,fe);
% pause(4);
% soundsc(son_original,fe);
% pause(4);






