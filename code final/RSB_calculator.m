function [RSB, RSBTrapeze, RSBSimpson] = RSB_calculator( signal )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% 4
global son_original
global fe

normSignalFiltrer = signal;
normSignalOriginal = son_original;

%soustrait
moySignalBruite = mean(normSignalFiltrer);
moySignalOriginal = mean(normSignalOriginal);

bruit = normSignalFiltrer - moySignalBruite;
original = normSignalOriginal - moySignalOriginal;

% figure
% plot(bruit)

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

% figure
% plot(lag,corrCroise)

normSignalFiltrer = normSignalFiltrer(timeDiff+1:end);
t1al = (0:length(normSignalFiltrer)-1)/fe;

% fenetre utile
startTime = 1.287*10^4;
endTime = 4.963*10^4;
maxBound = endTime - startTime

normSignalFiltrer = normSignalFiltrer(startTime:endTime);
bruit = bruit(startTime:endTime);
normSignalOriginal = normSignalOriginal(startTime:endTime);

% figure
% subplot(3,1,1)
% plot(normSignalFiltrer, 'r')
% title('Filtrer, aligned')

% subplot(3,1,2)
% plot(normSignalOriginal, 'g')
% title('Original sans bruit')
% xlabel('Time (s)')

% Soustraction des parties utiles
bruit = normSignalOriginal - normSignalFiltrer;
% subplot(3,1,3)
% plot(normSignalFiltrer, 'r')
% hold on
% plot(normSignalOriginal, 'g')
% hold on
% plot(bruit)


%Calcul RSB
sumFiltrer = sum(normSignalFiltrer.^2);
sumBruit = sum(bruit.^2);
RSB = 10*log(sumFiltrer/sumBruit);

%Calcul RSB Trapeze
puissanceFiltrer = 1/maxBound*(trapz(abs(normSignalFiltrer)).^2);
puissanceBruit = 1/maxBound*(trapz(abs(bruit)).^2);
RSBTrapeze = 10*log(puissanceFiltrer/puissanceBruit);

%Calcul RSB Simpson
puissanceFiltrer = 1/maxBound*((1/3*(abs(normSignalFiltrer(1)) + abs(normSignalFiltrer(maxBound)) + 4*sum(abs(normSignalFiltrer(3:2:maxBound-1))) + 2*sum(abs(normSignalFiltrer(2:2:maxBound-2)))))^2);
puissanceBruit = 1/maxBound*((1/3*(abs(bruit(1)) + abs(bruit(maxBound)) + 4*sum(abs(bruit(3:2:maxBound-1))) + 2*sum(abs(bruit(2:2:maxBound-2)))))^2);

RSBSimpson = 10*log(puissanceFiltrer/puissanceBruit);