function getSpikesTS(dataPath, savePath, varargin)

% Master script for spike detection
% See: https://github.com/jeremi-chabros/CWT
% Author: JJC 2020/11

addpath(dataPath)

% Load parameters

if ~exist(varargin, 'var')
    load('params.mat');
else
    params = varargin{1};
end

multiplier = params.multiplier;
nSpikes = params.nSpikes;
nScales = params.nScales;
wid = params.wid;
grd = params.grd;
costList = params.costList;
wnameList = params.wnameList;
minPeakThrMultiplier = params.minPeakThrMultiplier;
maxPeakThrMultiplier = params.maxPeakThrMultiplier;
posPeakThrMultiplier = params.posPeakThrMultiplier;

%%

% Get files
% Modify the '*string*.mat' wildcard to include subset of recordings

files = dir([dataPath '*slice1_1*.mat']);

for recording = 1:numel(files)
    
    progressbar(['File: ' num2str(recording) '/' num2str(numel(files))]);
    progressbar(recording/numel(files));
    fileName = files(recording).name;
    
    % Load data
    disp(['Loading ' fileName ' ...']);
    file = load(fileName);
    disp(['File loaded']);
    
    data = file.dat;
    channels = file.channels;
    fs = file.fs;
    ttx = contains(fileName, 'TTX');
    params.duration = length(data)/fs;
    
    % Truncate the data if specified
    if isfield(params, 'subsample_time')
        if ~isempty(params.subsample_time)
            start_frame = params.subsample_time(1) * fs;
            end_frame = params.subsample_time(2) * fs;
        end
        data = data(start_frame:end_frame, :);
        params.duration = length(data)/fs;
    end
    
    
    

        for L = costList
            saveName = [savePath fileName(1:end-4) '_L_' num2str(L) '_spikes.mat'];
                if ~exist(saveName, 'file');
            params.L = L;
            tic
            disp('Detecting spikes...');
            disp(['L = ' num2str(L)]);
            
            spikeTimes = {};
            spikeWaveforms = {};
            
            % Run spike detection
            for channel = 1:length(channels)
                
                spikeStruct = struct();
                waveStruct = struct();
                trace = data(:, channel);
                
                for wname = wnameList
                    
                    wname = char(wname);
                    valid_wname = strrep(wname, '.', 'p');
                    spikeWaves = [];
                    spikeFrames = [];
                    
                    if ~(ismember(channel, grd))
                        
                        [spikeFrames, spikeWaves, ~, ~] = ...
                            detectSpikesCWT(trace,fs,wid,wname,L,nScales, ...
                            multiplier,nSpikes,ttx, minPeakThrMultiplier, ...
                            maxPeakThrMultiplier, posPeakThrMultiplier);
                        
                        waveStruct.(valid_wname) = spikeWaves;
                        spikeStruct.(valid_wname) = spikeFrames;
                        
                    end
                end
                
                spikeTimes{channel} = spikeStruct;
                spikeWaveforms{channel} = waveStruct;
                
            end
            
            toc
            
            % Save results
            
            save_suffix = ['_' strrep(num2str(L), '.', 'p')];
            params.save_suffix = save_suffix;
            params.fs = fs;
            
            spikeDetectionResult = struct();
            spikeDetectionResult.method = 'CWT';
            spikeDetectionResult.params = params;
            
            saveName = [savePath fileName(1:end-4) '_L_' num2str(L) '_spikes.mat'];
            disp(['Saving results to: ' saveName]);
            
            varsList = {'spikeTimes', 'channels', 'spikeDetectionResult', ...
                'spikeWaveforms'};
            save(saveName, varsList{:}, '-v7.3');
        end
    end
end
progressbar(1);
end