%% Impedance Analysis of Transducers - 350 kHz - Experimental

%% clear workspace and load data
close all
clear all

% Import the data file
filename = "Standard_Setup\CH1_I_mA_CH2_V_10x_500MSs_200K_32AVG_Water_Tv001"; % path to file
data = importdata(filename);

%% Declare variables and constants
fs = 500e6; % sampling rate
dt = 1/fs; % time step of recording

fstart = 100e3; % start frequency of chirp signal used in analysis
fend = 700e3; % end frequency of chirp signal used in analysis

Vi = data(2,:); % Voltage in Volts
I = data(1,:); % current in mA
tf = 0:dt:(length(Vi)-1)*dt; % full recording time vector 

%% Plotting 

% Raw data
figure;
subplot(2,1,1)
plot(tf.*1e3, Vi)
xlabel('Time [ms]')
ylabel('Amplitude [V]')
title('Voltage')

subplot(2,1,2)
plot(tf.*1e3, I)
xlabel('Time [ms]')
ylabel('Amplitude [mA]')
title('Current')

%% Calculate FFT of input Voltage and Current signals and calculate frequency dependent impedance

N = length(Vi); % vector length
pad = 3; % pad FFT for higher frequency resolution
NFFT = 2^(nextpow2(N) + pad); % Zero pad 

df = fs/NFFT; % frequency step size of FFT
fvecp = df*(0:NFFT/2); % frequency vector used for plotting

% FFT
VF = fft(Vi, NFFT)*(1/N); % normalize by the actual length and not zero padded length for correct amplitude scaling
IF = fft(I, NFFT)*(1/N);

VF = 2*VF(1:NFFT/2+1); % scale by 2
IF = 2*IF(1:NFFT/2+1); % scale by 2

% Get rid of out of interest range frequencies
fR=(fvecp)<fend & (fvecp)>fstart;


%% Plot Spectra of Input signals
figure;
subplot(2,1,1)
plot(fvecp, abs(VF))
xlabel('Frequency [Hz]')
ylabel('Amplitude [|V|]')
title('Voltage Magnitude Spectrum')

subplot(2,1,2)
plot(fvecp, abs(IF))
xlabel('Frequency [Hz]')
ylabel('Amplitude [|mA|]')
title('Current Magnitude Spectrum')

%% Plot Impedance
ZF = (VF./IF); %*1e3
ZF=ZF(fR);
fvecp=fvecp(fR);

figure;
plot(fvecp, abs(ZF))
xlabel('Frequency [Hz]')
ylabel('Amplitude [|Z| Ohm]')
title('Impedance Magnitude')

figure;
plot(fvecp, angle(ZF))
xlabel('Frequency [Hz]')
ylabel('Amplitude [|Z| Ohm]')
title('Impedance Phase')

%% Acoustic Reflection coefficient - S11 - Using a scattering matrix formulation

Zo=50; % reference impedance
S11=(ZF-Zo)./(ZF+Zo);

R=(ZF./(50)-1)./(ZF./(50)+1);

figure(5)
plot(fvecp/1e6, abs(R),'-','DisplayName',"S11: M2 ",'LineWidth',1.5);
hold on
ylim([0 1])
set(findall(gcf,'-property','FontSize'),'FontSize',17)
set(findall(gcf,'-property','FontName'),'FontName','Times New Roman')
xlabel('Frequency [MHz]')
ylabel('|S_{11}|')