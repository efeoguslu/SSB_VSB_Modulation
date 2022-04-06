clc;
close all;
clear;

Fs = 19000;
t = 0:1/Fs:0.04;
fm = 300;
fc = 6000;
mt = 5*cos(2*pi*fm*t);
ct = cos(2*pi*fc*t);

st = mt .* ct;

%-----MODULATION

wn = (2*fc)/Fs;
n1 = 4;
n2 = 23;

[bn1, an1] = butter(n1, wn, 'low');
wn1 = freqz(bn1, an1, Fs/2);

[bn2, an2] = butter(n2, wn, 'low');
wn2 = freqz(bn2, an2, Fs/2);

figure(1);
plot(abs(wn1));
hold on;
plot(abs(wn2));
title("low pass filter responses");
legend("n = 4", "n = 23");

N = length(st);
fv = linspace(-Fs/2, Fs/2, N);
sf = fft(st, N);

slsb1 = filter(bn1, an1, st);
slsb2 = filter(bn2, an2, st);

figure(2);
subplot(311);
plot(fv, abs(fftshift(sf))/N);
xlabel("f (Hz)");
ylabel("|S(f)|");

subplot(312);
plot(fv, abs(fftshift(fft(slsb1)))/N);
xlabel("f (Hz)");
ylabel("|Slsb1(f)|")

subplot(313);
plot(fv, abs(fftshift(fft(slsb2)))/N);
xlabel("f (Hz)");
ylabel("|Slsb2(f)|")

%----------DEMODULATION

md = slsb2 .* (4*ct);
fc1 = 2*fm;
wn1 = 2*fc1/Fs;

n = 10;
[b1, a1] = butter(n, wn1, 'low');

md = filter(b1, a1, md);
Md = fftshift(fft(md,N));

figure(3);
subplot(211);
plot(fv, abs(Md)/N);
xlabel("demodulated signal");
ylabel("|Md(f)|");

subplot(212);
plot(fv, abs(fftshift(sf))/N);
xlabel("original message signal");
ylabel("|M(f)|");

figure(4);
plot(t, mt);
hold on;
plot(t, md);
legend("original message signal", "demodulated signal");
xlabel("time (seconds)");
ylabel("amplitude");







