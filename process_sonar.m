close all; clear all; clc;

file = 'L0069SideScan200kHz.mat';
load(file);
% HS: configuration for each ping
% P: echogram
% PS: time and coordinates
P = P';
[m, n] = size(P);

% Apply TVG function ------------------------------------------
for pingno = 1:n
    frequency = HS(1, pingno).frequency;
    transmitpower = HS(1, pingno).transmitPower;
    pulselength = HS(1, pingno).pulseLength;
    sampleinterval = HS(1, pingno).sampleInterval;
    soundvelocity = HS(1, pingno).soundVelocity;
    absorptioncoefficient = HS(1, pingno).absorptionCoefficient;
    count = HS(1, pingno).count;
    
    samplespace = soundvelocity * sampleinterval / 2;
    lambda = soundvelocity / frequency;
    
    % Sv values
    svcenterrange = soundvelocity * pulselength / 4;
    svrange = (0:count-1)' * samplespace - svcenterrange;
    svtvgrange = svrange;
    svtvgrange(svtvgrange < samplespace) = samplespace;
    
    tvg20 = 20 * log10(svtvgrange) + 2 * absorptioncoefficient * svtvgrange;
    idxtvg20less0 = find(tvg20 < 0);
    tvg20(idxtvg20less0) = 0;
    
    % svconst = 10*log10(transmitpower*lambda^2*soundvelocity*pulselength/(32*pi^2)) ...
    %          + 2*(gain+sacorrection) + psi;
    sv(:, pingno) = P(:, pingno) + tvg20; %- svconst;
end

figure, imagesc(1:n, (0:m-1)*samplespace, P, [-160 20]), colorbar;
xlabel('Ping number'), ylabel('Depth (m)');

figure, imagesc(1:n, (0:m-1)*samplespace, sv, [-160, 20]), colorbar;
xlabel('Ping number'), ylabel('Depth (m)');

% Bottom detection ------------------------------------------------
% For each ping, locate the maximum and subtract the pulse duration
r0 = round(2.5 / samplespace); % initial distance, in number of samples
power = zeros(pingno, 1);
ix = zeros(pingno, 1);
for pingno = 1:n
    [power(pingno, 1), ix(pingno, 1)] = max(P(r0:end, pingno));
end
ix = ix + r0 - 1;
ix_b = ix - round(pulselength / sampleinterval);
bottom = ix_b * samplespace;

figure, plot(1:n, bottom);
xlabel('Ping number'), ylabel('Depth (m)');

% Ping representation -----------------------------------------------
figure, plot((0:m-1)*samplespace, P(:,1), (0:m-1)*samplespace, P(:,end));
xlabel('Depth (m)'), ylabel('Echo level (dB)');
legend('initial', 'end');

%% Energy integration -----------------------------------------
Pl = 10.^(sv/10);
E = Pl * sampleinterval;

% Cumulative energy curve for the entire water column
Eacum = zeros(m-r0+1, n);
for pingno = 1:n
    Eacum(:, pingno) = cumsum(E(r0:end, pingno).^2);
end

figure, hold all;
for pingno = 1:10:n
    plot((r0:m)*samplespace, Eacum(:, pingno)/max(Eacum(:, pingno)));
end
xlabel('Depth (m)'), ylabel('Cumulative energy normalized');

% Cumulative energy at the bottom
m_bottom = round(1 / 1500 / samplespace);
E_bottom = zeros(1, n);
for pingno = 1:n
    E_bottom(pingno) = sum(E(ix_b(pingno)-m_bottom:ix_b(pingno), pingno));
end

bottom_waveform = hilbert(E_bottom'); % waveform with Hilbert transform
figure, plot(abs(bottom_waveform), 1:pingno);
xlabel('Bottom energy'), ylabel('Ping');

figure;

% Plot 1: Echo level at point 230
subplot(2,1,1);
plot((0:m-1)*samplespace, sv(:,85));
xlabel('Depth (m)'), ylabel('Echo level (dB)');
legend('initial'); % fish detection at point 230 with TVG correction

% Plot 2: Normalized cumulative energy at point 230
subplot(2,1,2);
plot((r0:m)*samplespace, Eacum(:,85)/max(Eacum(:,85)));
xlabel('Depth (m)'), ylabel('Cumulative energy normalized');
