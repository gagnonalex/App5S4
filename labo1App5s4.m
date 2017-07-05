clear all;
close all;
clc;
%% num 1 : reponse de filtre a partir de la transformee de z

H1 = [1 0;1 -0.7]; %  z/(z-0.7) = 1/(1-0.7z^-1) donc b = 1, a = [1,-0.7] apres filter(b,a,x)
H2 = [1 0; 1 0.7]; 
H3 = [1 0;1 0.90250];
t = [1:250]/250; % te = 1/250 donc fe = 250 donc max de f = fe/2 =125
%% A)


% - - - - - - - - - - H1
a = H1(2,:);
b = H1(1,:);
figure('name','Filtre H1');

i = 0;
for f = 0:25:125
    i = i +1;
    x = cos(2*pi*f*t);
    fx = filter(b,a,x);

    subplot(6,1,i)
    plot(t,fx);
    title(sprintf('frequence = %d hz', f));
end

% - - - - - - - - - - H2
figure('name','Filtre H2');
a = H2(2,:);
b = H2(1,:);


i = 0;
for f = 0:25:125
    i = i +1;
    x = cos(2*pi*f*t);
    fx = filter(b,a,x);

    subplot(6,1,i)
    plot(t,fx) 
    title(sprintf('frequence = %d hz', f));
end

% - - - - - - - - - - h3
figure('name','Filtre H3');

a = H3(2,:);
b = H3(1,:);


i = 0;
for f = 0:25:125
    i = i +1;
    x = cos(2*pi*f*t);
    fx = filter(b,a,x);

    subplot(6,1,i)
    plot(t,fx) 
    title(sprintf('frequence = %d hz', f));
end
%% B)
figure('name','rapport gain filtre vs entrer pour h1');

a = H1(2,:); % changer le numero du filtre pour les differentes analyse
b = H1(1,:);

% - - - - - - - - - - H
i = 0;
hold on 
for f = 0:25:125
    i = i +1;
    x = cos(2*pi*f*t);
    fx = filter(b,a,x);
    R = max(fx) / max(x); % rapport gain filtre / gain freq dentree
    stem(f,R) 
    %title(sprintf('frequence = %d hz', f));
end
hold off

%% C)


a = H1(2,:); % changer le numero du filtre pour les differentes analyse
b = H1(1,:);

% - - - - - - - - - - H
i = 0;
hold on 
for f = 0:25:125
    x = cos(2*pi*f*t);
    fx = filter(b,a,x);
    %figure;
%     freqz(fx); a decommenter pour voir la forme du filtree pour chaque
%     frequence ainsi que la reponse
end
hold off



%% num 2 : etude d'un filtre a partir de sa fonction de transfert exprimee en z
K = 1 
z1 = 0.8*j;
z2 = -0.8*j;
p1 = 0.95*exp(j*pi*(1/8));
p2 =  0.95*exp(-1*j*pi*(1/8));

%% A)

zplane([conj(z1); conj(z2)], [conj(p1); conj(p2)]);

signalRand = randn(1,8000);
h = [p1 p2 ; z1 z2];

z = [z1 z2];
p = [p1 p2];

a = poly(p);
b = poly (z);
figure
zplane(b,a);

figure
freqz(b,a);

figure
impz(b,a);

figure
filter(b,a,x);

figure
freqz(filter(b,a,signalRand));








