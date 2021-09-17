%% Advanced settings for batchInterface (only modify if you know what you are doing)
load params


params.threshold_calculation_window = [0, 1.0];  % which part of the recording to do spike detection, 0 = start of recording, 0.5 = midway, 1 = end of recording
% params.absThresholds = {''};  % add absolute thresholds here
% params.subsample_time = [1, 60];  % which part of the recording to subsample for spike detection (In seconds)
% if unspecified, then uses the entire recording
params.run_detection_in_chunks = 0; % whether to run wavelet detection in chunks (0: no, 1:yes)
params.chunk_length = 60;  % in seconds, will be ignored if run_detection_in_chunks = 0


params.multiplier = 3; % multiplier to use  extracting spikes for wavelet (not for detection)

% HSBSCAN is currently not used (and multiple_templates is not used to
% simplify things)
% adding HDBSCAN path (please specify your own path to HDBSCAN)
% currentScriptPath = matlab.desktop.editor.getActiveFilename;
% currFolder = fileparts(currentScriptPath);
% addpath(genpath([currFolder, filesep, 'HDBSCAN']));

% params.custom_threshold_file = load(fullfile(dataPath, 'results', ...
% 'Organoid 180518 slice 7 old MEA 3D stim recording 3_L_-0.3_spikes_threshold_ref.mat'));

params.custom_threshold_method_name = {'thr2p5', 'thr3p5', 'thr4p5'};
params.minPeakThrMultiplier = -5;
params.maxPeakThrMultiplier = -100;
params.posPeakThrMultiplier = 15;

params.nSpikes = 10000;
params.multiple_templates = 0; % whether to get multiple templates to adapt (1: yes, 0: no)
params.multi_template_method = 'amplitudeAndWidthAndSymmetry';  % options are PCA, spikeWidthAndAmplitude, or amplitudeAndWidthAndSymmetry

option = 'list';