%Daniel Harvey
%%
hFig=figure('name','rhd2edf','menubar','none','numbertitle','off','resize','on',...
    'closerequestfcn','delete(gcf);','userdata',1,...
    'units','norm','pos',[.1 .1 .5 .5]);

status = uicontrol('style','edit','tag','status','max',2,'horizontalalignment','left',...
    'string',[{''};{'Intructions:'};...
    {'1. Select the RHD files that you want to split apart and concatenate.'};...
    {'2. Check to make sure that there are no big time gaps between files. Gaps will be filled with zeros in the signal.'};...
    {'3. For each output you indend to create, select from the channels listed by holding shift or ctrl. Be sure to select the same number of channels from each column. You can also deselect cells by holding ctrl.'};...
    {'4. Input a unique file name for each output. Specify a downsample rate if desired and check the output path. Then click the ''create edf'' button'};],...
    'parent',hFig,'units','norm','pos', [0 .8 1 .2]);

filelist=uitable('columnname',{'file','start datetime','duration(s)','fs','#chan'},...
    'cellselectioncallback',@trackindices,...
    'tooltipstring','this is a preview of the selected files',...
    'parent',hFig,'units','norm','pos',[0.2 .7 .7 .1]);

uicontrol('style','text','string','downsample',...
    'tooltipstring','the outputs will contain only every n''th data point',...
    'parent',hFig,'units','norm','pos', [0 0 .1 .1]);
ds = uicontrol('style','edit','string','1',...
    'tooltipstring','the outputs will contain only every n''th data point',...
    'parent',hFig,'units','norm','pos', [0.1 0 .1 .1]);

uicontrol('style','text','string','output path',...
    'parent',hFig,'units','norm','pos', [0.2 0 .1 .1]);
outpath = uicontrol('style','edit','string',pwd,...
    'parent',hFig,'units','norm','pos', [0.4 0 .5 .1]);
uicontrol('string','browse','callback',{@browseoutpath,outpath},...
    'parent',hFig,'units','norm','pos', [0.3 0 .1 .1]);

tabgp = uitabgroup(hFig,'pos',[0 .1 1 .6]);
for i=1:16 outlists(i)=uitab(tabgp,'title',['output',num2str(i)],'createfcn',@initoutlists,'userdata',i); end

uicontrol('string','select input RHD files',...
    'callback',{@selectfiles,filelist,outlists},...
    'parent',hFig,'units','norm','pos', [0 .7 .2 .1]);
uicontrol('string','remove file(s)','callback',{@removefile,filelist,outlists},...
    'parent',hFig,'units','norm','pos',[0.9 .7 .1 .1]);

uicontrol('string','create edf files',...
    'tag','dostuff',...
    'callback',{@dothestuff,filelist,outlists,ds,outpath},...
    'parent',hFig,'units','norm','pos', [0.9 0 .1 .1]);

%% callback functions
function selectfiles(src,event,filelist,outlists)
    [files, path] = uigetfile('*.rhd', 'Select RHD2000 Data File(s)','multiselect','on');
    if path %this is here only to supress an error message if the cancel button is pressed
    if ~iscell(files), files={files}; end %this is here in case only one file is selected
    
    userdata=[];
    userdata.files=files;
    userdata.path=path;
    filelist.UserData = userdata;
    
    updatelists(filelist,outlists);
    end
end

function removefile(src,event,filelist,outlists)
    userdata = filelist.UserData;
    files = userdata.files;
    if isfield(userdata,'tracker')
        tracker = userdata.tracker;
        files(unique(tracker(:,1)))=[];
        userdata.files=files;
        filelist.UserData=userdata;

        updatelists(filelist,outlists);
    end
end

function initoutlists(src,event)
    uicontrol('style','text','string','output file name',...
    'parent',src,'units','norm','pos', [0 .9 .2 .1]); 
    uicontrol('style','edit','string',['default',num2str(src.UserData)],...
    'parent',src,'units','norm','pos', [0.2 .9 .8 .1]);
    uitable('cellselectioncallback',@trackindices,...
    'tooltipstring','these are the names of the channels in each file',...
    'parent',src,'units','norm','pos',[0 0 1 .9]);
end

function trackindices(src,event)
    userdata = src.UserData;
    if isfield(userdata,'tracker') 
        tracker = userdata.tracker;
    else
        tracker = [];
    end
    tracker=event.Indices;
    userdata.tracker=tracker;
    src.UserData = userdata;
end

function browseoutpath(src,event,outpath)
    outpath.String = uigetdir(outpath.String);
end

function dothestuff(src,event,filelist,outlists,ds,outpath)
    userdata = filelist.UserData;
    files=userdata.files;
    path=userdata.path;
    dur=userdata.duration;
    fs_param=userdata.fs;
    fs=fs_param.amplifier_sample_rate;
    fs_aux=fs_param.aux_input_sample_rate;
    gaps=[userdata.gaps;ceil(dur)-dur];
    ds=str2num(ds.String);
    
    %start by checking indices of selected channels for errors
    err=0; indx=[];
    for o=1:16 %o is for output
        tracker=outlists(o).Children(1).UserData;
        if isfield(tracker,'tracker')
            tracker=tracker.tracker;
            indx=[indx,o];
            if ~isempty(tracker) %make sure channels are selected
                [~,~,ic]=unique(tracker(:,1));
                if range(accumarray(ic,1))~=0 %make sure the same number of channels are selected for each file in each output
                    updatestatus(['ERROR! there are a different number of channels selected for at least one file in output',num2str(o)]);
                    err=1;
                end
                if length(unique(tracker(:,2)))~=length(files)%check if there are channels selected for each file
                    updatestatus(['Error! there are some files in output',num2str(o),' that have no channels selected']);
                    err=1;
                end
                if sum(sum(contains(outlists(o).Children(1).Data(tracker),{'n/a'})))
                    updatestatus(['ERROR, a ''n/a'' channel is selected in output',num2str(o)]);
                    err=1;
                end
            end
        else
        end
    end
    if isempty(indx)
        updatestatus('error, no channels are selected for any output'); 
        err=1;
    end
    if err, return, end
    
    %write edf
    for o=indx
        tracker=outlists(o).Children(1).UserData;
        tracker=tracker.tracker;
        if ~isempty(tracker)
            name = checkfilename([outpath.String,'\',outlists(o).Children(2).String],'.edf');
            numsigs=length(unique(tracker(tracker(:,1)<=userdata.num_ch,1)));
            numaux=length(unique(tracker(tracker(:,1)>userdata.num_ch,1)));
            
            %check available memory
            [~,mem]=memory;
            if mem.PhysicalMemory.Available<(64*dur*(fs*numsigs+fs_aux*numaux))
                updatestatus('WARNING!!! there is not enough system memory available for this dataset. This may take a while...');
            end
            
            %read and prepare signals
            signals=[];
            aux=[];
            for i=1:length(files)
                channels = tracker(tracker(:,2)==i,1)';
                data=my_read_Intan_RHD2000(files{i},path,channels);
                signals=[signals,data.data(:,1:ds:int32(floor(data.record_time)*floor(fs/ds))*ds),zeros(numsigs,int32(gaps(i)*floor(fs/ds)))];
                aux=[aux,data.auxdata(:,1:ds:int32(floor(data.record_time)*floor(fs_aux/ds))*ds),zeros(numaux,int32(gaps(i)*floor(fs_aux/ds)))];
                if i==1, recdate=datetime(data.s.date)-seconds(data.record_time); end %save timestamp of start of first file
            end
            
            %set-up file header
            header = struct;
            header.edf_ver = '0';
            header.patient_id = name;
            header.local_rec_id = '';
%             recdate=datetime(data(1).s.date)-seconds();
            header.recording_startdate = datestr(recdate,'dd.mm.yy');
            header.recording_starttime = datestr(recdate,'HH.MM.SS');
            header.num_header_bytes = 256+256*(numsigs+numaux);
            header.reserve_1 = ' ';
            header.num_data_records = ceil(dur);
            header.data_record_duration = 1;
            header.num_signals = (numsigs+numaux);
            %set-up signal headers
            signalHeader = struct('signal_labels','','tranducer_type','','physical_dimension','','physical_min',0,...
            'physical_max',0,'digital_min',0,'digital_max',0,'prefiltering','','samples_in_record',0,'reserve_2','');
            for i = 1:numsigs
                signalHeader(i).signal_labels = data(1).channels(i).custom_channel_name;
                signalHeader(i).tranducer_type = 'dunno';
                signalHeader(i).physical_dimension = 'uV';
                signalHeader(i).physical_min = max(floor(min(signals(i,:))),-32767);
                signalHeader(i).physical_max = min(ceil(max(signals(i,:))),32767);
                signalHeader(i).digital_min = -32767;
                signalHeader(i).digital_max = 32767;
                signalHeader(i).prefiltering = [num2str(data(1).freq_param.desired_lower_bandwidth),'-',num2str(data(1).freq_param.desired_upper_bandwidth),'hz w/',num2str(data(1).freq_param.notch_filter_frequency),'hz notch'];
                signalHeader(i).samples_in_record = floor(fs/ds);
                signalHeader(i).reserve_2 = ' ';
            end
            for ii=i+1:i+numaux
                idx=ii-i;
                signalHeader(ii).signal_labels = data(1).aux_channels(idx).custom_channel_name;
                signalHeader(ii).tranducer_type = 'dunno';
                signalHeader(ii).physical_dimension = 'V';
                signalHeader(ii).physical_min = max(floor(min(aux(idx,:))),-32767);
                signalHeader(ii).physical_max = min(ceil(max(aux(idx,:))),32767);
                signalHeader(ii).digital_min = -32767;
                signalHeader(ii).digital_max = 32767;
                signalHeader(ii).prefiltering = 'n/a';
                signalHeader(ii).samples_in_record = floor(fs_aux/ds);
                signalHeader(ii).reserve_2 = ' ';
            end
            
            updatestatus(['writing ',name]);
        blockEdfWrite(name, header, signalHeader,[mat2cell(signals,ones(1,numsigs),ceil(dur)*floor(fs/ds));mat2cell(aux,ones(1,numaux),ceil(dur)*floor(fs_aux/ds))]);
            
        clearvars signals
        end
    end
    
    updatestatus('done')
end

%% util functions
function updatelists(filelist,outlists)
    userdata = filelist.UserData;
    files=userdata.files;
    path=userdata.path;

    for i=1:length(files)%preview the data
        data(i)=my_read_Intan_RHD2000(files{i},path,0);
        ch(i)=length(data(i).channels);
        aux(i)=length(data(i).aux_channels);
    end
    s=cat(1,data.s);
    d=datetime({s.date},'InputFormat','dd-MMM-yyyy HH:mm:ss')-seconds(floor([data.record_time]));
    [~,indx]=sort(d);
    
    %calculate total duration
    totalduration = datetime(s(indx(end)).date,'InputFormat','dd-MMM-yyyy HH:mm:ss')-d(indx(1));
    updatestatus('');
    updatestatus(['total duration of all input files is (days.Hrs:Min:Sec) ',datestr(totalduration,'dd.HH:MM:SS')]);
    %calculate gaps between files
    e=datetime({s.date},'InputFormat','dd-MMM-yyyy HH:mm:ss');
    d=d(indx)';%start datetime of ea. file
    e=e(indx)';%end datetime of ea. file
    gaps=d(2:end)-e(1:end-1);
    updatestatus('the gaps between selected files are (Hrs:Min:Sec)');
    updatestatus(strjoin(cellstr(datestr(gaps,'HH:MM:SS '))));
    
    f=cat(1,data.freq_param);
    if range([f(indx).amplifier_sample_rate])~=0, updatestatus('WARNING! concatenating mismatched sampling frequencies is not supported in this version'); end
    
    filelist.Data = [files(indx)',cellstr(datestr(d(:))),{data(indx).record_time}',{f(indx).amplifier_sample_rate}',num2cell(ch(indx))'];
    
    %put together channel names
    for i=1:length(files)
        ch_names(:,i)=[strcat({data(i).channels.native_channel_name}',{' '},{data(i).channels.custom_channel_name}');repmat({'n/a'},max(ch)-ch(i),1)];
        aux_names(:,i)=[strcat({data(i).aux_channels.native_channel_name}',{' '},{data(i).aux_channels.custom_channel_name}');repmat({'n/a'},max(aux)-aux(i),1)];
    end
    %
    for i=1:length(outlists)
        set(findall(outlists(i).Children,'type','uitable'),'columnname',files,'data',[ch_names;aux_names]);
    end
    
    userdata.gaps=seconds(gaps);
    userdata.duration=seconds(totalduration);
    userdata.fs=data.freq_param;
    userdata.files = files(indx);
    userdata.num_ch=length(ch_names);
    userdata.num_aux=length(aux_names);
    
    filelist.UserData = userdata;
end

function newname = checkfilename(filename,extension)
    newname=[filename,extension];
    i=1;
    while exist(newname,'file')==2
        updatestatus([newname,' already exists']);
        newname=[filename,'(',num2str(i),')',extension];
        i=i+1;
    end
end

function updatestatus(newstring)
    status=findobj('tag','status');
    status.String=[{newstring};status.String];
%     jh=findjobj(status);
%     j=jh.getComponent(0).getComponent(0);
%     j.setCaretPosition(j.getDocument.getLength);
    drawnow
end

%% intan read rhd functions
function output=my_read_Intan_RHD2000(file,path,channels)
% modified for franklab at wsu spokane
% Reads Intan Technologies RHD2000 data file generated by evaluation board GUI or Intan Recording Controller.

if (file == 0)
    return;
end

filename = [path,file];
fid = fopen(filename, 'r');

s = dir(filename);
filesize = s.bytes;

% Check 'magic number' at beginning of file to make sure this is an Intan Technologies RHD2000 data file.
magic_number = fread(fid, 1, 'uint32');
if magic_number ~= hex2dec('c6912702')
    error('Unrecognized file type.');
end

% Read version number.
data_file_main_version_number = fread(fid, 1, 'int16');
data_file_secondary_version_number = fread(fid, 1, 'int16');

updatestatus(sprintf('Reading %s: Intan Technologies RHD2000 Data File, Version %d.%d', ...
    file, data_file_main_version_number, data_file_secondary_version_number));

if (data_file_main_version_number == 1)
    num_samples_per_data_block = 60;
else
    num_samples_per_data_block = 128;
end

% Read information of sampling rate and amplifier frequency settings.
sample_rate = fread(fid, 1, 'single');
dsp_enabled = fread(fid, 1, 'int16');
actual_dsp_cutoff_frequency = fread(fid, 1, 'single');
actual_lower_bandwidth = fread(fid, 1, 'single');
actual_upper_bandwidth = fread(fid, 1, 'single');

desired_dsp_cutoff_frequency = fread(fid, 1, 'single');
desired_lower_bandwidth = fread(fid, 1, 'single');
desired_upper_bandwidth = fread(fid, 1, 'single');

% This tells us if a software 50/60 Hz notch filter was enabled during the data acquisition.
notch_filter_mode = fread(fid, 1, 'int16');
notch_filter_frequency = 0;
if (notch_filter_mode == 1)
    notch_filter_frequency = 50;
elseif (notch_filter_mode == 2)
    notch_filter_frequency = 60;
end

desired_impedance_test_frequency = fread(fid, 1, 'single');
actual_impedance_test_frequency = fread(fid, 1, 'single');

% Place notes in data strucure
notes = struct( ...
    'note1', fread_QString(fid), ...
    'note2', fread_QString(fid), ...
    'note3', fread_QString(fid) );
    
% If data file is from GUI v1.1 or later, see if temperature sensor data was saved.
num_temp_sensor_channels = 0;
if ((data_file_main_version_number == 1 && data_file_secondary_version_number >= 1) ...
    || (data_file_main_version_number > 1))
    num_temp_sensor_channels = fread(fid, 1, 'int16');
end

% If data file is from GUI v1.3 or later, load eval board mode.
eval_board_mode = 0;
if ((data_file_main_version_number == 1 && data_file_secondary_version_number >= 3) ...
    || (data_file_main_version_number > 1))
    eval_board_mode = fread(fid, 1, 'int16');
end

% If data file is from v2.0 or later (Intan Recording Controller), load name of digital reference channel.
if (data_file_main_version_number > 1)
    reference_channel = fread_QString(fid);
end

% Place frequency-related information in data structure.
frequency_parameters = struct( ...
    'amplifier_sample_rate', sample_rate, ...
    'aux_input_sample_rate', sample_rate / 4, ...
    'supply_voltage_sample_rate', sample_rate / num_samples_per_data_block, ...
    'board_adc_sample_rate', sample_rate, ...
    'board_dig_in_sample_rate', sample_rate, ...
    'desired_dsp_cutoff_frequency', desired_dsp_cutoff_frequency, ...
    'actual_dsp_cutoff_frequency', actual_dsp_cutoff_frequency, ...
    'dsp_enabled', dsp_enabled, ...
    'desired_lower_bandwidth', desired_lower_bandwidth, ...
    'actual_lower_bandwidth', actual_lower_bandwidth, ...
    'desired_upper_bandwidth', desired_upper_bandwidth, ...
    'actual_upper_bandwidth', actual_upper_bandwidth, ...
    'notch_filter_frequency', notch_filter_frequency, ...
    'desired_impedance_test_frequency', desired_impedance_test_frequency, ...
    'actual_impedance_test_frequency', actual_impedance_test_frequency );

% Define data structure for spike trigger settings.
spike_trigger_struct = struct( ...
    'voltage_trigger_mode', {}, ...
    'voltage_threshold', {}, ...
    'digital_trigger_channel', {}, ...
    'digital_edge_polarity', {} );

new_trigger_channel = struct(spike_trigger_struct);
spike_triggers = struct(spike_trigger_struct);

% Define data structure for data channels.
channel_struct = struct( ...
    'native_channel_name', {}, ...
    'custom_channel_name', {}, ...
    'native_order', {}, ...
    'custom_order', {}, ...
    'board_stream', {}, ...
    'chip_channel', {}, ...
    'port_name', {}, ...
    'port_prefix', {}, ...
    'port_number', {}, ...
    'electrode_impedance_magnitude', {}, ...
    'electrode_impedance_phase', {} );

new_channel = struct(channel_struct);

% Create structure arrays for each type of data channel.
amplifier_channels = struct(channel_struct);
aux_input_channels = struct(channel_struct);
supply_voltage_channels = struct(channel_struct);
board_adc_channels = struct(channel_struct);
board_dig_in_channels = struct(channel_struct);
board_dig_out_channels = struct(channel_struct);

amplifier_index = 1;
aux_input_index = 1;
supply_voltage_index = 1;
board_adc_index = 1;
board_dig_in_index = 1;
board_dig_out_index = 1;

% Read signal summary from data file header.

number_of_signal_groups = fread(fid, 1, 'int16');

for signal_group = 1:number_of_signal_groups
    signal_group_name = fread_QString(fid);
    signal_group_prefix = fread_QString(fid);
    signal_group_enabled = fread(fid, 1, 'int16');
    signal_group_num_channels = fread(fid, 1, 'int16');
    signal_group_num_amp_channels = fread(fid, 1, 'int16');

    if (signal_group_num_channels > 0 && signal_group_enabled > 0)
        new_channel(1).port_name = signal_group_name;
        new_channel(1).port_prefix = signal_group_prefix;
        new_channel(1).port_number = signal_group;
        for signal_channel = 1:signal_group_num_channels
            new_channel(1).native_channel_name = fread_QString(fid);
            new_channel(1).custom_channel_name = fread_QString(fid);
            new_channel(1).native_order = fread(fid, 1, 'int16');
            new_channel(1).custom_order = fread(fid, 1, 'int16');
            signal_type = fread(fid, 1, 'int16');
            channel_enabled = fread(fid, 1, 'int16');
            new_channel(1).chip_channel = fread(fid, 1, 'int16');
            new_channel(1).board_stream = fread(fid, 1, 'int16');
            new_trigger_channel(1).voltage_trigger_mode = fread(fid, 1, 'int16');
            new_trigger_channel(1).voltage_threshold = fread(fid, 1, 'int16');
            new_trigger_channel(1).digital_trigger_channel = fread(fid, 1, 'int16');
            new_trigger_channel(1).digital_edge_polarity = fread(fid, 1, 'int16');
            new_channel(1).electrode_impedance_magnitude = fread(fid, 1, 'single');
            new_channel(1).electrode_impedance_phase = fread(fid, 1, 'single');
            
            if (channel_enabled)
                switch (signal_type)
                    case 0
                        amplifier_channels(amplifier_index) = new_channel;
                        spike_triggers(amplifier_index) = new_trigger_channel;
                        amplifier_index = amplifier_index + 1;
                    case 1
                        aux_input_channels(aux_input_index) = new_channel;
                        aux_input_index = aux_input_index + 1;
                    case 2
                        supply_voltage_channels(supply_voltage_index) = new_channel;
                        supply_voltage_index = supply_voltage_index + 1;
                    case 3
                        board_adc_channels(board_adc_index) = new_channel;
                        board_adc_index = board_adc_index + 1;
                    case 4
                        board_dig_in_channels(board_dig_in_index) = new_channel;
                        board_dig_in_index = board_dig_in_index + 1;
                    case 5
                        board_dig_out_channels(board_dig_out_index) = new_channel;
                        board_dig_out_index = board_dig_out_index + 1;
                    otherwise
                        error('Unknown channel type');
                end
            end
            
        end
    end
end

% Summarize contents of data file.
num_amplifier_channels = amplifier_index - 1;
num_aux_input_channels = aux_input_index - 1;
num_supply_voltage_channels = supply_voltage_index - 1;
num_board_adc_channels = board_adc_index - 1;
num_board_dig_in_channels = board_dig_in_index - 1;
num_board_dig_out_channels = board_dig_out_index - 1;

% Determine how many samples the data file contains.

% Each data block contains num_samples_per_data_block amplifier samples.
bytes_per_block = num_samples_per_data_block * 4;  % timestamp data
bytes_per_block = bytes_per_block + num_samples_per_data_block * 2 * num_amplifier_channels;
% Auxiliary inputs are sampled 4x slower than amplifiers
bytes_per_block = bytes_per_block + (num_samples_per_data_block / 4) * 2 * num_aux_input_channels;
% Supply voltage is sampled once per data block
bytes_per_block = bytes_per_block + 1 * 2 * num_supply_voltage_channels;
% Board analog inputs are sampled at same rate as amplifiers
bytes_per_block = bytes_per_block + num_samples_per_data_block * 2 * num_board_adc_channels;
% Board digital inputs are sampled at same rate as amplifiers
if (num_board_dig_in_channels > 0)
    bytes_per_block = bytes_per_block + num_samples_per_data_block * 2;
end
% Board digital outputs are sampled at same rate as amplifiers
if (num_board_dig_out_channels > 0)
    bytes_per_block = bytes_per_block + num_samples_per_data_block * 2;
end
% Temp sensor is sampled once per data block
if (num_temp_sensor_channels > 0)
   bytes_per_block = bytes_per_block + 1 * 2 * num_temp_sensor_channels; 
end

% How many data blocks remain in this file?
data_present = 0;
bytes_remaining = filesize - ftell(fid);
if (bytes_remaining > 0)
    data_present = 1;
end

num_data_blocks = bytes_remaining / bytes_per_block;

num_amplifier_samples = num_samples_per_data_block * num_data_blocks;
num_aux_input_samples = (num_samples_per_data_block / 4) * num_data_blocks;
num_supply_voltage_samples = 1 * num_data_blocks;
num_board_adc_samples = num_samples_per_data_block * num_data_blocks;
num_board_dig_in_samples = num_samples_per_data_block * num_data_blocks;
num_board_dig_out_samples = num_samples_per_data_block * num_data_blocks;

record_time = num_amplifier_samples / sample_rate;

output.s=s;
output.record_time=record_time;
output.freq_param=frequency_parameters;
output.channels=amplifier_channels;
output.aux_channels=aux_input_channels;


if channels
    if (data_present)
        updatestatus(sprintf('File contains %0.3f seconds of data.  Amplifiers were sampled at %0.2f kS/s.', ...
            record_time, sample_rate / 1000));
    else
        updatestatus(sprintf('Header file contains no data.  Amplifiers were sampled at %0.2f kS/s.', ...
            sample_rate / 1000));
    end

    if (data_present)

        % Pre-allocate memory for data.
        updatestatus('Allocating memory for data...');

        t_amplifier = zeros(1, num_amplifier_samples);

        amplifier_data = zeros(num_amplifier_channels, num_amplifier_samples);
        aux_input_data = zeros(num_aux_input_channels, num_aux_input_samples);
        supply_voltage_data = zeros(num_supply_voltage_channels, num_supply_voltage_samples);
        temp_sensor_data = zeros(num_temp_sensor_channels, num_supply_voltage_samples);
        board_adc_data = zeros(num_board_adc_channels, num_board_adc_samples);
        board_dig_in_data = zeros(num_board_dig_in_channels, num_board_dig_in_samples);
        board_dig_in_raw = zeros(1, num_board_dig_in_samples);
        board_dig_out_data = zeros(num_board_dig_out_channels, num_board_dig_out_samples);
        board_dig_out_raw = zeros(1, num_board_dig_out_samples);

        % Read sampled data from file.
        updatestatus('Reading data from file...');

        amplifier_index = 1;
        aux_input_index = 1;
        supply_voltage_index = 1;
        board_adc_index = 1;
        board_dig_in_index = 1;
        board_dig_out_index = 1;

        print_increment = 20;
        percent_done = print_increment;
        for i=1:num_data_blocks
            % In version 1.2, we moved from saving timestamps as unsigned integeters to signed integers to accomidate negative (adjusted) timestamps for pretrigger data.
            if ((data_file_main_version_number == 1 && data_file_secondary_version_number >= 2) || (data_file_main_version_number > 1))
                t_amplifier(amplifier_index:(amplifier_index + num_samples_per_data_block - 1)) = fread(fid, num_samples_per_data_block, 'int32');
            else
                t_amplifier(amplifier_index:(amplifier_index + num_samples_per_data_block - 1)) = fread(fid, num_samples_per_data_block, 'uint32');
            end
            if (num_amplifier_channels > 0)
                amplifier_data(:, amplifier_index:(amplifier_index + num_samples_per_data_block - 1)) = fread(fid, [num_samples_per_data_block, num_amplifier_channels], 'uint16')';
            end
            if (num_aux_input_channels > 0)
                aux_input_data(:, aux_input_index:(aux_input_index + (num_samples_per_data_block / 4) - 1)) = fread(fid, [(num_samples_per_data_block / 4), num_aux_input_channels], 'uint16')';
            end
            if (num_supply_voltage_channels > 0)
                supply_voltage_data(:, supply_voltage_index) = fread(fid, [1, num_supply_voltage_channels], 'uint16')';
            end
            if (num_temp_sensor_channels > 0)
                temp_sensor_data(:, supply_voltage_index) = fread(fid, [1, num_temp_sensor_channels], 'int16')';
            end
            if (num_board_adc_channels > 0)
                board_adc_data(:, board_adc_index:(board_adc_index + num_samples_per_data_block - 1)) = fread(fid, [num_samples_per_data_block, num_board_adc_channels], 'uint16')';
            end
            if (num_board_dig_in_channels > 0)
                board_dig_in_raw(board_dig_in_index:(board_dig_in_index + num_samples_per_data_block - 1)) = fread(fid, num_samples_per_data_block, 'uint16');
            end
            if (num_board_dig_out_channels > 0)
                board_dig_out_raw(board_dig_out_index:(board_dig_out_index + num_samples_per_data_block - 1)) = fread(fid, num_samples_per_data_block, 'uint16');
            end

            amplifier_index = amplifier_index + num_samples_per_data_block;
            aux_input_index = aux_input_index + (num_samples_per_data_block / 4);
            supply_voltage_index = supply_voltage_index + 1;
            board_adc_index = board_adc_index + num_samples_per_data_block;
            board_dig_in_index = board_dig_in_index + num_samples_per_data_block;
            board_dig_out_index = board_dig_out_index + num_samples_per_data_block;

            fraction_done = 100 * (i / num_data_blocks);
            if (fraction_done >= percent_done)
                updatestatus(sprintf('%d%% done...', percent_done));
                percent_done = percent_done + print_increment;
            end
        end

        % Make sure we have read exactly the right amount of data.
        bytes_remaining = filesize - ftell(fid);
        if (bytes_remaining ~= 0)
            %error('Error: End of file not reached.');
        end

    end

    if (data_present)

        updatestatus('Parsing data...');

        % Extract digital input channels to separate variables.
        for i=1:num_board_dig_in_channels
           mask = 2^(board_dig_in_channels(i).native_order) * ones(size(board_dig_in_raw));
           board_dig_in_data(i, :) = (bitand(board_dig_in_raw, mask) > 0);
        end
        for i=1:num_board_dig_out_channels
           mask = 2^(board_dig_out_channels(i).native_order) * ones(size(board_dig_out_raw));
           board_dig_out_data(i, :) = (bitand(board_dig_out_raw, mask) > 0);
        end

        % Scale voltage levels appropriately.
        amplifier_data = 0.195 * (amplifier_data - 32768); % units = microvolts
        aux_input_data = 37.4e-6 * aux_input_data; % units = volts
        supply_voltage_data = 74.8e-6 * supply_voltage_data; % units = volts
        if (eval_board_mode == 1)
            board_adc_data = 152.59e-6 * (board_adc_data - 32768); % units = volts
        elseif (eval_board_mode == 13) % Intan Recording Controller
            board_adc_data = 312.5e-6 * (board_adc_data - 32768); % units = volts    
        else
            board_adc_data = 50.354e-6 * board_adc_data; % units = volts
        end
        temp_sensor_data = temp_sensor_data / 100; % units = deg C

        % Check for gaps in timestamps.
        num_gaps = sum(diff(t_amplifier) ~= 1);
        if (num_gaps == 0)
            updatestatus('No missing timestamps in data.');
        else
            updatestatus(sprintf('Warning: %d gaps in timestamp data found.  Time scale will not be uniform!', ...
                num_gaps));
        end

        % Scale time steps (units = seconds).
        t_amplifier = t_amplifier / sample_rate;
        t_aux_input = t_amplifier(1:4:end);
        t_supply_voltage = t_amplifier(1:num_samples_per_data_block:end);
        t_board_adc = t_amplifier;
        t_dig = t_amplifier;
        t_temp_sensor = t_supply_voltage;

        % If the software notch filter was selected during the recording, apply the same notch filter to amplifier data here.
        if (notch_filter_frequency > 0)
            updatestatus(sprintf('Applying notch filter...'));

            print_increment = 20;
            percent_done = print_increment;
            for i=channels(channels<=num_amplifier_channels) %this takes a while, so only filter channels that will be used in the current file set
                amplifier_data(i,:) = ...
                    notch_filter(amplifier_data(i,:), sample_rate, notch_filter_frequency, 10);

                fraction_done = 100 * (i / length(channels(channels<=num_amplifier_channels)));
                if (fraction_done >= percent_done)
                    updatestatus(sprintf('%d%% done...', percent_done));
                    percent_done = percent_done + print_increment;
                end

            end
        end
        updatestatus('');
    end
    output.present=data_present;
    output.data=amplifier_data(channels(channels<=num_amplifier_channels),:);
    output.auxdata=aux_input_data(channels(channels>num_amplifier_channels)-num_amplifier_channels,:);
end
% Close data file.
fclose(fid);
end

function a = fread_QString(fid)

% a = read_QString(fid)
%
% Read Qt style QString.  The first 32-bit unsigned number indicates
% the length of the string (in bytes).  If this number equals 0xFFFFFFFF,
% the string is null.

a = '';
length = fread(fid, 1, 'uint32');
if length == hex2num('ffffffff')
    return;
end
% convert length from bytes to 16-bit Unicode words
length = length / 2;

for i=1:length
    a(i) = fread(fid, 1, 'uint16');
end

end

function s = plural(n)

% s = plural(n)
% 
% Utility function to optionally plurailze words based on the value
% of n.

if (n == 1)
    s = '';
else
    s = 's';
end

end

function out = notch_filter(in, fSample, fNotch, Bandwidth)

% out = notch_filter(in, fSample, fNotch, Bandwidth)
%
% Implements a notch filter (e.g., for 50 or 60 Hz) on vector 'in'.
% fSample = sample rate of data (in Hz or Samples/sec)
% fNotch = filter notch frequency (in Hz)
% Bandwidth = notch 3-dB bandwidth (in Hz).  A bandwidth of 10 Hz is
%   recommended for 50 or 60 Hz notch filters; narrower bandwidths lead to
%   poor time-domain properties with an extended ringing response to
%   transient disturbances.
%
% Example:  If neural data was sampled at 30 kSamples/sec
% and you wish to implement a 60 Hz notch filter:
%
% out = notch_filter(in, 30000, 60, 10);

tstep = 1/fSample;
Fc = fNotch*tstep;

L = length(in);

% Calculate IIR filter parameters
d = exp(-2*pi*(Bandwidth/2)*tstep);
b = (1 + d*d)*cos(2*pi*Fc);
a0 = 1;
a1 = -b;
a2 = d*d;
a = (1 + d*d)/2;
b0 = 1;
b1 = -2*cos(2*pi*Fc);
b2 = 1;

out = zeros(size(in));
out(1) = in(1);  
out(2) = in(2);
% (If filtering a continuous data stream, change out(1) and out(2) to the
%  previous final two values of out.)

% Run filter
for i=3:L
    out(i) = (a*b2*in(i-2) + a*b1*in(i-1) + a*b0*in(i) - a2*out(i-2) - a1*out(i-1))/a0;
end

end


function move_to_base_workspace(variable)

% move_to_base_workspace(variable)
%
% Move variable from function workspace to base MATLAB workspace so
% user will have access to it after the program ends.

variable_name = inputname(1);
assignin('base', variable_name, variable);

end

