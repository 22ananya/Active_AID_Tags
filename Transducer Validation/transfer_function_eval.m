%% Experimental measurement of transfer function

%% clear workspace and load data
close all
clear all

%% Data Import
% Import the data file
filename = "E:\Dropbox (GaTech)\Georgia Tech\Research\Experiments\350 kHz Design and Experiments\Transducer Validation\Transmissions - Hydrophone recordings\Tv001_Chirp_100K_800K_Matching4_125MSs_200k_32avg_50V_preamp"; % path to file
data = importdata(filename);

%% Declare variables and constants
fs = 125e6; % sampling rate
dt = 1/fs; % time step of recording

fstart = 100e3; % start frequency of chirp signal used in analysis
fend = 800e3; % end frequency of chirp signal used in analysis

y = data(1,:); % Voltage in Volts - channel 1 corresponds to recorded signal from the hydrophone
y = y - mean(y); % zero mean to eliminate any chance of DC offset
t = 0:dt:(length(y)-1)*dt; % full recording time vector 

%% Plotting 
% Raw data
figure;
plot(t.*1e3, y)
xlabel('Time [ms]')
ylabel('Amplitude [V]')
title('Recorded Waveform')

% Identify source of noise in the signal - likely 60 Hz signal from power
% supply

% Isolate only pulse in recorded signal for calculating spectrum 
yp = y(t>0.8e-3 & t<0.95e-3);
nfft = 2^(nextpow2(length(yp))+2);
Y = (2/nfft)*abs(fft(yp,nfft));
Y = Y(1:nfft/2);

freq = 0:fs/nfft:fs - fs/nfft; % frequency vector
freq = freq(1:nfft/2);

figure;
plot(freq/1e3, Y)
xlim([0 1e3])
xlabel('Freq [kHz]')
ylabel('Amplitude (raw)')
title('Waveform Spectrum')

%% Filtering
% Filter design

% Highpass filter the signal to remove 60 hz cycles
d = designfilt('highpassfir', ...       % Response type
       'StopbandFrequency',1e4, ...     % Frequency to be filtered
       'PassbandFrequency',5e4, ...
       'StopbandAttenuation',100, ...    
       'PassbandRipple', 4, ...
       'SampleRate',fs) ;              % Sample rate

% Visualize filter
fvtool(d)
y = filter(d,y); % rewrite y as filtered signal

figure;
plot(t.*1e3, y)
xlabel('Time [ms]')
ylabel('Amplitude [V]')
title('Filtered Waveform')

%% Source signal for reference

% generate / simulate source chirp signal 
ct = 0.1e-3; % length of source chirp signal

t2 = 0:1/fs:ct - 1/fs;
x = chirp(t2,fstart, t2(end), fend);

% Visualize source signal
figure;
plot(t2.*1e3, x)
xlabel('Time [ms]')
ylabel('Amplitude (nrm)')
title('Simulated Chirp')

% spectra
nfft2 = 2^(nextpow2(length(x))+2);
X = (2/nfft2)*abs(fft(x,nfft2));
X = X(1:nfft2/2);

freq2 = 0:fs/nfft2:fs - fs/nfft2; % frequency vector
freq2 = freq2(1:nfft2/2);

figure;
plot(freq2./1e3, X)
xlim([0 1e2])
xlabel('Freq [Hz]')
ylabel('Amplitude (raw)')
title('Chirp Spectrum')

