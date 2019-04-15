%   MUMT 307 (Music & Audio Computing II)
%   Final Project.  Modal Synthesis analysis.
%   Max Henry #260133798

%   This script will analyze a sound for modal resonances by finding
%   spectral peaks and their associated bandwidths.  It outputs a CSV file
%   "FreqsRs.csv" that is used by the accompanying C++ program to
%   generate a dynamic filter bank to be used as a synthesis engine.  You
%   are welcome to play with peak-threshold and peak-prominence parameters,
%   that determine whether a local maximum will be selected to be modeled
%   as a resonant filter.

%   Optional plots are included in the second section of this script.

clear;

strike = 1;
[reson, fs] = audioread('examples/rhodes.wav');                 % read .wav file and get sample rate.

reson = reson(:,1);                                             % take one channel, if stereo file

peakthresh = -60;                                               % set auto-peak threshold
peakprom = 20;                                                  % set auto-peak prominance
pad = 100000;                                                   % set zero padding value
sustain = length(reson)-1;                                      
xreson = [reson ; zeros(pad, 1)];
xstrike = [strike ; zeros(sustain, 1)];                         % generate impulse resp as long as input signal

T = 1/fs;                                                       % sample period
N = length(xreson);                                             % signal length with zero padding
hN = floor(N/2);                                                % approx half N
freqs = (1:hN)/N*fs;                                            % frequency axis

%   FFT Calculations
X = abs(fft(xreson));
magX = 20*log10(X/max(X));
hmagX = magX(1:hN);

[pks, locs] = findpeaks(hmagX, 'MinPeakHeight',...              % get peak locations
    peakthresh, 'MinPeakProminence', peakprom);

iploc = zeros(1, length(locs));
ipmag = zeros(1, length(locs));
B = zeros(1, length(locs));

for i = 1:length(locs)
    %   Refine peaks using parabolic interpolation
    peak = locs(i);
    
    beta = hmagX(peak);                                         % get peak value
    alpha = hmagX(peak-1);                                      % get previous value
    gamma = hmagX(peak+1);                                      % get next value
    
    ip = 0.5 * (alpha - gamma)/(alpha - 2*beta + gamma);        % local peak location
    ipmag(i) = beta - 0.25 * (alpha - gamma) * ip;              % peak magnitude
    iploc(i) = ((locs(i)+ip)/N*fs);                             % peak frequency
    
    %   Find adjacent -3dB drop
    searching = true;
    j = 1;

    while searching == true
        bwfinder = hmagX(peak+j);
        
        if (bwfinder > (hmagX(peak) - 3))
            j = j + 1;
        else
            searching = false;
        end
    end
    
    B(i) = 2*j/N*fs;                                            % calculate approx bandwidth
    
end

normgains = db2mag(ipmag)/max(db2mag(ipmag));                   % normalized filter gains

%   Calculate radii and filter coefficients
rs = exp(-pi*B*T);
as = [ones(length(locs), 1) (-2*rs.*cos(2*pi.*iploc.*T))' rs.^2'];

%   Generate example output (for analysis)
y = zeros(1, length(xstrike));                                  % initialize output

for n = 1:5
    y = y + normgains(n) * filter(1, as(n,:), xstrike')...      % normalize and scale filter contributions
        /max(filter(1, as(n,:), xstrike'));
end

%   Output frequencies and R's to csv.
csvwrite('FreqsRs.csv',[iploc; rs; normgains]);

%%  Plots -------------------------------------------------------

%   Plot magnitude frequency response and peaks
plot(freqs, hmagX);
hold on;
scatter(iploc, ipmag, '*');
hold off;
ylabel('Level (dB)');
ylim([peakthresh 1]);
xlabel('Frequency (Hz)');
title('Magnitude freq response with spectral peaks');

%   Plot exemplary engine output
time = (0:(length(y)-1))./fs;
figure;
plot(time, y/max(y));
xlabel('Time (s)');
ylabel('Amplitude');
title('Synthesis output');