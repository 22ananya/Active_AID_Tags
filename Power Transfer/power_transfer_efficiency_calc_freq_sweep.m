%% This script evaluates the end-to-end Source to Receiver experimental efficiency in Wireless Ultrasonic Power transfer for AID Tags
% Tags tested : v001 (receiver) and v002 (source)

%% Clear Variables and Workspace
close all
clear all
clc

%% Load data
% Load data file for source current and voltage
datapath = 'E:\Dropbox (GaTech)\Georgia Tech\Research\Experiments\350 kHz Design and Experiments\Power_Transfer\'; % directory path
datafile = 'Case10_5V';

data = load(join([datapath, datafile]));


%% Declare variables1,:)
% experiment and oscope settings
fs = 500e6;

VL = data(1,:) - mean(data(1,:)); % first channel measures the load voltage - [V]
IS = data(2,:) - mean(data(2,:)); % second channel measures the source current - [A]
VS = data(3,:) - mean(data(3,:)); % third channel measures the source voltage - [V]
RL = 50; % load resistance in Ohms
N = length(data);
fl = 100e3; % chirp start frequency
fh = 800e3; % chirp end frequency
%% Plotting
% Visualize signals - check for errors 
t = 0:1/fs:(length(data(1,:))-1)/fs; % create time vector

figure;
subplot(3,1,1)
plot(t.*1e3, VL)
xlabel('Time [ms]')
ylabel('Amplitude [V]')
title('Load Voltage')
subplot(3,1,2)
plot(t.*1e3, IS)
xlabel('Time [ms]')
ylabel('Current [A]')
title('Source Current')
subplot(3,1,3)
plot(t.*1e3, VS)
xlabel('Time [ms]')
ylabel('Voltage [V]')
title('Source Voltage')

%% Calculate power in frequency domain
% Load Voltage Spectrum
VLfft = fft(VL); 
VLfft = (2/N)*(VLfft(1:N/2 + 1));

% Source Voltage Spectrum
VSfft = fft(VS);
VSfft = (2/N)*(VSfft(1:N/2 + 1));

% Source Current Spectrum
ISfft = fft(IS);
ISfft = (2/N)*(ISfft(1:N/2 + 1));

ZS = VSfft./ISfft; % source / input impedance
freq = 0:fs/N:fs - N/fs;
ind = freq>fl & freq<fh;
f = freq(ind);

% Received Power
PR=abs(VLfft).^2/RL; % V^2/R

% Source or Input power
PS=(1/2)*real(VSfft.*conj(ISfft));
%PR(PS(ind)<0.05*max(PS(ind)))=0; % to eliminate artifically boosted efficiency values


eff=PR./PS;
eff(PR==0)=0;

%% Plot spectra and efficiency
figure;
plot(f, eff(ind)*100)
xlabel('Frequency [Hz]')
ylabel('Efficiency %')
title('Efficiency')

figure;
plot(f, abs(VLfft(ind)))
xlabel('Frequency [Hz]')
ylabel('Voltage Load [V]')
title('Load Voltage')

figure;
plot(f, abs(VSfft(ind)))
xlabel('Frequency [Hz]')
ylabel('Voltage [V]')
title('Source Voltage')

figure;
plot(f, abs(ISfft(ind)))
xlabel('Frequency [Hz]')
ylabel('Current [A]')
title('Source Current')
