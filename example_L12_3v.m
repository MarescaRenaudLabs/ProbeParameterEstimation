clc
clear
close all

addpath('functions')

%% load L12-3v data
load('data\data_L12_3v.mat')

%% Configure parameter search

% some info about the data
P.Fs = Receive(1).decimSampleRate * 1e6; % Hz, sampling frequency
P.Fc = Trans.frequency * 1e6; % Hz, center frequency
P.Ftx = TW.Parameters(1) * 1e6; % Hz, transmit frequency
P.pitch = Trans.spacingMm / 1000; % m
P.Nz_RF = Receive(1).endSample; % number of samples in RF data for one transmit
P.num_elements = size(RFData, 2); % number of transducer elements

% P.ttp_guess = 1 / P.Ftx;
P.ttp_guess = TW.peak / (Trans.frequency * 1e6);

% parameter search settings
P.numSamplesMute = 40; % mute sample 1 till n, only for visualization
P.applyFilter = 1;
P.applyTGC = 1;
P.half_width_aperture_nh_el = 20; % half aperture number of elements to use. Nb in paper is 2*nh+1

% set min and max round trip to restrict search space and save time
P.min_round_trip = 1.4e-6; % s
P.max_round_trip = 2.6e-6; % s

P.NR_to_use = 1; % reflections to use, specified as list (1, 1:2)
P.t_rt_matching_layers = 0; % s, round trip time in matching layers

% to use primary and secondary reflection as introduced in discussion paper:
% P.NR_to_use = 1:2; % reflections to use, specified as list (1, 1:2)
% P.t_rt_matching_layers = 1/P.Fc; % s, round trip time in matching layers

P.NDelay = 50; % number of values for delay to test
P.NThickness = 100; % number of values for thickness to test
P.NCLens = 100; % number of values for lens sound speed to test

% P.NDelay = 25; % number of values for delay to test
% P.NThickness = 50; % number of values for thickness to test
% P.NCLens = 50; % number of values for lens sound speed to test

P.ttp_values_test = linspace(-1 / P.Ftx, 3 / P.Ftx, P.NDelay) + P.ttp_guess; % s, TTP values to test in grid search
P.thickness_values_test = linspace(0.4e-3, 0.9e-3, P.NThickness); % m, thickness values to test in grid search
P.c_values_test = linspace(950, 1050, P.NCLens); % m/s, sound speed values to test in grid search

%% Preprocess RF and view to check if parameters are correct
data = preprocessRFData(P, RFData);
previewRFData(P, data);

%% Find Transducer parameters and
result = findProbeParameters(P, data);
plotProbeParameters(P, data, result);
