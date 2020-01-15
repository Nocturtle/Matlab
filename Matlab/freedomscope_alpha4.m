%
%% main

% Create a figure window --------------------------------------------------
hFig = figure('Toolbar','none','Menubar', 'none',...
    'NumberTitle','Off','Name','Controls',...'
    'closerequestfcn',['reset(gpuDevice);','imaqreset;','delete(gcf);'],...
    'units','normalized','pos', [0.25 .25 .5 .5]);

% refresh button
uicontrol('string','Refresh Lists',...
    'callback',@refreshlists,...
    'parent',hFig,'Units','normalized','Pos',[0 0 .25 .02]);

% create arduino panel controls -------------------------------------------
arduino_panel = uipanel('title','Arduino Controls',...
    'parent',hFig,'units','normalized','pos', [0 .5 .25 .5]);
arduino_subpanel = uipanel('BorderType','none','parent',arduino_panel,'units','normalized','pos', [0 0 1 .88]);

list = seriallist;
if isempty(list), list = 'no devices found'; end
uicontrol('style','popupmenu','string',list,...
    'tag','mycomlist',...
    'parent',arduino_panel,'units','normalized','pos', [0 .89 .75 .1]);
uicontrol('style','text','string','not connected','horizontalalignment','left',...
    'tag','arduinostatus',...
    'parent',arduino_panel,'units','normalized','pos', [0 .88 0.75 .05]);
uicontrol('string','Connect',...
    'callback',@myconnectarduino,...
    'tag','myarduino',...
    'parent',arduino_panel,'Units','normalized','Pos',[0.75 .93 .25 .07]);
cameralabel = 'ABC';
for i = 1:3
    uicontrol('style','text','string',['LED_',cameralabel(i)],'horizontalalignment','left',...
        'parent',arduino_subpanel,'units','normalized','pos', [0 .75-(i-1)*.25 .1 .06]);
    uicontrol('Style','slider','Value',0,'Max',100,'Min',0,...
        'tooltipstring','Duty Cycle',...
        'tag',['slide',num2str(i)],...
        'callback',@myslider,...
        'parent',arduino_subpanel,'Units','normalized','Pos',[0.1 .75-(i-1)*.25 .75 .06]);
    uicontrol('style','edit','string','0','horizontalalignment','left',...
        'tooltipstring','Duty Cycle',...
        'tag',['edit',num2str(i)],...
        'callback',@myeditor,...
        'parent',arduino_subpanel,'units','normalized','pos', [.85 .75-(i-1)*.25 .1 .06]);
end
set(findall(arduino_subpanel, '-property', 'enable'), 'enable', 'off');

% video panel controls ----------------------------------------------------
video_panel = uipanel('title','Video Controls',...
    'parent',hFig,'units','normalized','pos', [0.25 0 .5 1]);
info = imaqhwinfo('winvideo');
list = cat(1,{info.DeviceInfo(:).DeviceName});
if isempty(info.DeviceInfo), list = 'no devices found'; end

uicontrol('style','text','string','Video Sources','horizontalalignment','left',...
    'parent',video_panel,'units','normalized','pos',[0 .97 .2 .03]);
uicontrol('style','listbox','string',list,'Max',42,'Min',0,...
    'tooltipstring','select one or more video sources',...
    'tag','myvidlist',...
    'createfcn',@createVidObjs,...
    'parent',video_panel,'units','normalized','pos',[0 .85 .35 .12]);

uicontrol('style','text','string','Output File suffix','horizontalalignment','left',...
    'parent',video_panel,'units','normalized','pos',[0.35 .97 .2 .03]);
test=uicontrol('style','edit','string',[{'rodent1'};{'rodent2'};{'rodent3'};{'rodent4'}],'Max',42,'Min',0,'horizontalalignment','left',...
    'tooltipstring','this provides a custom file name for each video source',...
    'tag','suffix',...
    'parent',video_panel,'units','normalized','pos',[0.35 .85 .35 .12]);

uicontrol('style','text','string',['f',8320,' buffer size'],'horizontalalignment','left',...
    'parent',video_panel,'units','normalized','pos',[0.75 .97 .2 .03]);
uicontrol('style','edit','string','90','horizontalalignment','left',...
    'tooltipstring',['during preview, this many frames will be stored on the GPU and summed to calculate f',8320,' for ',916,'f/f'],...
    'tag','buffsize',...
    'parent',video_panel,'units','normalized','pos',[0.9 .97 .2 .03]);
uicontrol('string','Preview',...
    'callback',@startpreview,...
    'tag','preview',...
    'parent',video_panel,'units','normalized','pos',[0.75 .85 .25 .12]);

uicontrol('style','text','string','Record Trigger:','horizontalalignment','left',...
    'parent',video_panel,'units','normalized','pos',[0 .775 .2 .05]);
uicontrol('style','popupmenu','string',{'schedule','manual'},'horizontalalignment','left',...
    'callback',@triggerchange,...
    'parent',video_panel,'units','normalized','pos',[0.2 .775 .2 .05]);

schedule_panel = uipanel('title','Scheduler',...
    'tag','scheduler','userdata',1,...
    'parent',video_panel,'units','normalized','pos',[0 .3 1 .5]);
uicontrol('style','text','string','Start (mm/dd/yy HH:MM:SS):','horizontalalignment','left',...
    'parent',schedule_panel,'units','normalized','pos',[0 .8 .3 .1]);
uicontrol('style','edit','string','now','horizontalalignment','left',...
    'tag','start',...
    'parent',schedule_panel,'units','normalized','pos', [0.3 .8 .7 .1]);
uicontrol('style','text','string','Record Duration (HH:MM:SS):','horizontalalignment','left',...
    'parent',schedule_panel,'units','normalized','pos',[0 .6 .3 .1]);
uicontrol('style','edit','string','00:02:00','horizontalalignment','left',...
    'tag','duration',...
    'parent',schedule_panel,'units','normalized','pos', [0.3 .6 .7 .1]);
uicontrol('style','text','string','Idle Duration (HH:MM:SS):','horizontalalignment','left',...
    'parent',schedule_panel,'units','normalized','pos',[0 .4 .3 .1]);
uicontrol('style','edit','string','00:18:00','horizontalalignment','left',...
    'tag','idle',...
    'parent',schedule_panel,'units','normalized','pos', [0.3 .4 .7 .1]);
uicontrol('style','text','string','Repeat:','horizontalalignment','left',...
    'parent',schedule_panel,'units','normalized','pos',[0 .2 .3 .1]);
uicontrol('style','edit','string','10','horizontalalignment','left',...
    'tag','repeat',...
    'parent',schedule_panel,'units','normalized','pos', [0.3 .2 .7 .1]);

uicontrol('style','text','string','Output File format','horizontalalignment','left',...
    'parent',video_panel,'units','normalized','pos',[0 .25 .1 .05]);
uicontrol('style','popupmenu','string',{'motion jpg 2000','uncompressed avi'},'horizontalalignment','left',...
    'tag','format',...
    'parent',video_panel,'units','normalized','pos',[0.1 .25 .4 .05]);

uicontrol('style','text','string','Output File prefix:','horizontalalignment','left',...
    'parent',video_panel,'units','normalized','pos',[0 .2 .1 .05]);
uicontrol('style','edit','string',datestr(datetime('now'),'mmddyy-HHMM'),'horizontalalignment','left',...
    'tooltipstring','each output file will use this string as a prefix',...
    'tag','prefix',...
    'parent',video_panel,'units','normalized','pos', [0.1 .2 .4 .05]);

uicontrol('style','text','string','Output Path:','horizontalalignment','left',...
    'parent',video_panel,'units','normalized','pos',[0 .15 .1 .05]);
uicontrol('style','edit','string',pwd,'horizontalalignment','left',...
    'tag','outputpath',...
    'parent',video_panel,'units','normalized','pos',[0.1 .15 .4 .05]);
uicontrol('string','browse',...
    'callback',@browseoutputpath,...
    'parent',video_panel,'units','normalized','pos',[0.5 .15 .1 .05]);

uicontrol('string','Start',...
    'callback',@startlogging,...
    'tag','startrecord',...
    'parent',video_panel,'units','normalized','pos',[0 0 .5 .05]);
uicontrol('string','Stop',...
    'callback',@stoplogging,...
    'tag','stoprecord',...
    'parent',video_panel,'units','normalized','pos',[0.5 0 .5 .05]);

% image decompress controls -----------------------------------------------
decomp_panel = uipanel('title','Decompression Controls',...
    'parent',hFig,'units','normalized','pos', [0 .4 .25 .1]);

uicontrol('string','select file(s)',...
    'callback',@selectfile,...
    'parent',decomp_panel,'units','normalized','pos',[0 0 1 1]);

% status controls----------------------------------------------------------
status_panel = uipanel('title','Status',...
    'parent',hFig,'units','normalized','pos',[0 .02 .25 .38]);

uicontrol('style','text','string',{''},'horizontalalignment','left','Max',42,'Min',0,...
    'tag','status',...
    'parent',status_panel,'units','normalized','pos',[0 0 1 1]);

    
%% arduino functions-------------------------------------------------------

function myconnectarduino(src,event)%try to connect to arduino at selected com port
    list=findobj('tag','mycomlist');
    status=findobj('tag','arduinostatus');
    try
        userdata=[];
        src.UserData=userdata;
        if iscell(list.String)
            userdata.a=arduino(list.String{list.Value},'Mega2560');
        else
            userdata.a=arduino(list.String,'Mega2560');
        end
        status.String=['connected to ',userdata.a.Port,' ',userdata.a.Board];
        set(findall(src.Parent.Children(end), '-property', 'enable'), 'enable', 'on');
        src.UserData=userdata;
    catch
        status.String='arduino connect error';
    end
end

%% video preview functions-------------------------------------------------

function createVidObjs(src,event)
    userdata = src.UserData;
    for i = 1:length(src.String)
        try vid(i) = videoinput('winvideo',i,'MJPG_640x480');
            vidsrc = vid(i).Source;
            vidsrc.FrameRate = '30.0000';
        catch vid(i) = videoinput('winvideo',i);
        end
        vid(i).ReturnedColorspace = 'grayscale';
    end
    userdata.vid = vid;
    src.UserData = userdata;
end

function startpreview(src,event)
    vidlist = findobj('tag','myvidlist');
    buffsize = findobj('tag','buffsize');
    buffsize = str2num(buffsize.String);
    selectedvid = vidlist.Value;
    userdata = vidlist.UserData;
    
    for i = 1:length(selectedvid)
        vid = userdata.vid(selectedvid(i));
        if strcmp(vid.Running,'off')
            
            vidRes = vid.VideoResolution;
            imWidth = vidRes(1);
            imHeight = vidRes(2);
            
            offset = selectedvid(i)*50;
            newfig = figure('Toolbar','none','Menubar', 'none',...
            'NumberTitle','Off','Name','Preview',...
            'closerequestfcn',@closepreview,...
            'units','pixels','pos', [offset offset 1.25*imWidth imHeight+12]);
            newfig.UserData = selectedvid(i);
            colormap(newfig,gray(512))
            
            panel = uipanel('parent',newfig,'units','pixels','pos', [0 12 imWidth imHeight]);
            imax = axes(panel);
            imax.Units = 'pixels';
            imax.Position = [0 0 imWidth imHeight];
            colormap(imax,gray(512))
            
            im = image(zeros(imHeight,imWidth));
            im.CDataMapping = 'scaled';
            
            timestamp = uicontrol('style','text','String','Timestamp', ...
            'parent',newfig,'Units','pixels','Position',[0 0 imWidth/2 12]);
            setappdata(im,'TimestampLabel',timestamp);
            
            visualizationpanel = uipanel('parent',newfig,'units','pixels','pos', [imWidth 0 imWidth/4 imHeight+12]);
            
            delta = uicontrol('style','togglebutton','string',[916,'F/F'],...
            'parent',visualizationpanel,'Units','normalized','Pos',[0 .9 1 .1]);
            setappdata(im,'deltafoverf',delta);
            
            overlay = uicontrol('string','select overlay',...
            'callback',@selectoverlay,...
            'parent',visualizationpanel,'Units','normalized','Pos',[0 .8 1 .1]);
            
            overlaylabel = uicontrol('style','text','String','Selected File:','horizontalalignment','left',...
            'parent',visualizationpanel,'Units','normalized','Pos',[0 .75 1 .05]);
            userdata.label = overlaylabel;
            overlay.UserData = userdata;
            
            uicontrol('style','text','String','Select Page',...
            'parent',visualizationpanel,'Units','normalized','Pos',[0 .7 .25 .05]);
            
            page = uicontrol('style','edit','string','1',...
            'parent',visualizationpanel,'Units','normalized','Pos',[0.25 .7 .75 .05]);
            
            display = uicontrol('style','togglebutton','string','display overlay',...
            'callback',{@displayoverlay,im},...
            'tag','dispbtn','enable','off',...
            'parent',visualizationpanel,'Units','normalized','Pos',[0 .6 1 .1]);
            moreuserdata.overlay = overlay;
            moreuserdata.page = page;
            display.UserData = moreuserdata;
            setappdata(im,'displayoverlay',display);
            
            histbtn = uicontrol('style','togglebutton','string','enable histogram',...
            'parent',visualizationpanel,'units','normalized','pos', [0 0.5 1 .05]);
            histax = axes(visualizationpanel);
            histax.Position = [0 0 1 .5];
            setappdata(im,'histbtn',histbtn);
            setappdata(im,'histax',histax);
            
            triggerconfig(vid,'immediate');
            vid.FramesPerTrigger = 1;
            vid.TriggerRepeat=Inf;
            vid.TriggerFcn={@mypreview_fcn,im};
            vid.StartFcn=[];
            vid.StopFcn=[];
            
            viddata.buffsize = buffsize;
            viddata.buffer = gpuArray(ones(imHeight,imWidth,buffsize));
            viddata.index = buffsize;
            
            vid.UserData = viddata;
            
            vid.LoggingMode = 'memory';
            
            start(vid);
        end
    end
end

function mypreview_fcn(obj,event,himage)
    if obj.FramesAvailable
        %set timestamp
        tsl = getappdata(himage,'TimestampLabel');
        tsl.String = datestr(event.Data.AbsTime,'mm/dd/yy HH:MM:SS.FFF');
        %get data
        data = getdata(obj,1);
        %maintain buffer
        userdata = obj.UserData;
        userdata.index = mod(userdata.index,userdata.buffsize)+1;
        userdata.buffer(:,:,userdata.index) = gpuArray(data);
        obj.UserData = userdata;
        flushdata(obj);
        %check display overlay
        overlay = getappdata(himage,'displayoverlay');
        %check delta-f-over-f
        delta = getappdata(himage,'deltafoverf');
        if delta.Value && overlay.Value
            f0 = mean(userdata.buffer,3);
            himage.CData = gather(uint8((userdata.buffer(:,:,userdata.index)-f0)./f0.*100)+himage.UserData);
        elseif delta.Value
            f0 = mean(userdata.buffer,3);
            himage.CData = gather(uint8((userdata.buffer(:,:,userdata.index)-f0)./f0.*100));
        elseif overlay.Value
            himage.CData = gather(uint8(userdata.buffer(:,:,userdata.index))+himage.UserData);
        else
            himage.CData = data;
        end
        %check histogram
        hist = getappdata(himage,'histbtn');
        if hist.Value
            histax = getappdata(himage,'histax');
            axes(histax);
            imhist(himage.CData);
        end
    end
end

function closepreview(src,event)
    %src.Children(1).Value = 0;%disable deltafoverf button
    vidlist = findobj('tag','myvidlist');
    userdata = vidlist.UserData;
    stop(userdata.vid(src.UserData));
    flushdata(userdata.vid(src.UserData));
    userdata.vid(src.UserData).UserData = [];
    delete(src);
end

function selectoverlay(src,event)
    [file,path]=uigetfile({'*.tiff','*.tif'});
    userdata=src.UserData;
    userdata.label.String = ['Selected File: ',file];
    userdata.file=file;
    userdata.path=path;
    src.UserData = userdata;
    dispbtn = findobj(src.Parent,'tag','dispbtn');
    dispbtn.Enable='on';
end

function displayoverlay(src,event,hImage)
    userdata=src.UserData;
    moreuserdata=userdata.overlay.UserData;
    file=[moreuserdata.path,moreuserdata.file];
    page=str2num(userdata.page.String);
    t=Tiff(file);
    t.setDirectory(page);
    hImage.UserData=gpuArray(t.read);
    t.close;
end

%% recording functions-----------------------------------------------------

function triggerchange(src,event)
    P=findobj('tag','scheduler');
    if src.Value == 1
        set(findall(P, '-property', 'enable'), 'enable', 'on');
        P.UserData=1;
    else
        set(findall(P, '-property', 'enable'), 'enable', 'off');
        P.UserData=0;
    end
end

function startlogging(src,event)
    %close any preview windows
    mustclose = findobj('type','Figure');
    for i = 1:length(mustclose)
        if strcmp(mustclose(i).Name,'Preview')
            closepreview(mustclose(i),[]);
        end
    end
    %retrieve various UI variables
    status = findobj('tag','status');
    vidlist = findobj('tag','myvidlist');
    prefix = findobj('tag','prefix');
    suffix = findobj('tag','suffix');
    outputpath = findobj('tag','outputpath');
    schedule = findobj('tag','scheduler');
    format = findobj('tag','format');
    format = format.Value;
    formatstring={'.mj2','Motion JPEG 2000';'.avi','Uncompressed AVI'};
    selectedvid = vidlist.Value;
    numvid=length(selectedvid);
    userdata = vidlist.UserData;
    vid=userdata.vid;
    %set video object parameters
    vid(selectedvid).LoggingMode = 'disk';
    triggerconfig(vid(selectedvid),'immediate');
    vid(selectedvid).FramesPerTrigger = 1;
    %initialize output file names and vid object functions
    for i=1:numvid
        index=selectedvid(i);
        filenames{i} = [outputpath.String,'\',prefix.String,'_',suffix.String{index}];
        
        viddata.txtfile=checkfilename(filenames{i},'.csv');
        viddata.fid=0;
        vid(index).UserData=viddata;
        vid(index).StartFcn=@opentimestamplog;
        vid(index).StopFcn=@closetimestamplog;
        vid(index).TriggerFcn=@logtimestamps;
        
        vidsrc=vid(index).Source;
        framerates(i)=str2double(vidsrc.FrameRate);
    end
    
    if schedule.UserData %run schedule
        %retrieve various UI variables
        starttime = findobj('tag','start');
        dur = findobj('tag','duration');
        idle = findobj('tag','idle');
        repeat = findobj('tag','repeat');
        
        starttime = datetime(starttime.String);
        dur = duration(dur.String);
        idle = duration(idle.String);
        repeat = str2num(repeat.String);
        
        for i=1:numvid
            %only record for a fixed number of frames
            vid(selectedvid(i)).TriggerRepeat=framerates(i)*seconds(dur)-1;
            %preallocate videowriter objects
            for ii=1:repeat
                filename = checkfilename([filenames{i},num2str(ii)],formatstring{format,1});
                vidWriter{ii,i} = VideoWriter(filename,formatstring{format,2});
            end
        end
        status.String=[status.String;{'starting schedule'}];
        
        for ii=1:repeat
            stop(vid(selectedvid));
            for i=1:numvid
                vid(selectedvid(i)).DiskLogger = vidWriter{ii,i};
            end
            while (starttime+((ii-1)*(dur+idle)))>datetime('now')
            end
            start(vid(selectedvid));
            wait(vid(selectedvid),seconds(idle+dur),'logging');
        end
        
        status.String=[status.String;{'schedule complete'}];
        stop(vid(selectedvid));
        
    else %just record until stop button is pushed
        for i=1:numvid
            vidfilename = checkfilename(filenames{i},formatstring{format,1});
            vid(selectedvid(i)).DiskLogger = VideoWriter(vidfilename,formatstring{format,2});
        end
        vid(selectedvid).TriggerRepeat=Inf;
        start(vid(selectedvid));
        status.String=[status.String;{'recording until stop is pressed'}];
    end
end

function stoplogging(src,event)
    vidlist = findobj('tag','myvidlist');
    userdata = vidlist.UserData;
    
    stop(userdata.vid);
end

function opentimestamplog(src,event)
    status = findobj('tag','status');
    userdata=src.UserData;
    userdata.fid=fopen(userdata.txtfile,'a');
    src.UserData=userdata;
    status.String=[status.String;{['opened ',userdata.txtfile]}];
end

function logtimestamps(src,event)
    userdata=src.UserData;
    fwrite(userdata.fid,[datestr(event.Data.AbsTime,'mm/dd/yy HH:MM:SS.FFF'),',']);
end

function closetimestamplog(src,event)
    status = findobj('tag','status');
    userdata=src.UserData;
    userdata.fid=fclose(userdata.fid);
    src.UserData=userdata;
    status.String=[status.String;{['closed ',userdata.txtfile]}];
end

function browseoutputpath(src,event)
    box = findobj('tag','outputpath');
    box.String = uigetdir();
end

%% decompress functions----------------------------------------------------

function selectfile(src,event)
    status = findobj('tag','status');
    [files,path]=uigetfile('*.mj2;*.avi','MultiSelect','On');%avi
    if ~iscell(files), files={files}; end
    
    for i=1:length(files)
        v = VideoReader([path,files{i}]);
        ii=1;
        status.String=[status.String;{['reading ',path,files{i}]}];
        while hasFrame(v)
            im(:,:,ii) = rgb2gray(readFrame(v));
            ii=ii+1;
        end
        filename = checkfilename([path,files{i}(1:end-4)],'.tiff');
        status.String=[status.String;{['saving as ',filename]}];
        saveastiff(im,filename);
    end
    status.String=[status.String;{'done'}];
end

%% utility functions-------------------------------------------------------

function refreshlists(src,event)
    comlist = findobj('tag','mycomlist');
    vidlist = findobj('tag','myvidlist');
    
    list = seriallist;
    if isempty(list), list = 'no devices found'; end
    comlist.String = list;
    
    imaqreset
    info = imaqhwinfo('winvideo');
    list = cat(1,{info.DeviceInfo(:).DeviceName});
    vidlist.Value=1;
    if isempty(list), list = 'no devices found'; end
    vidlist.String = list;
    vidlist.CreateFcn(vidlist);
end

function myslider(src,event)
    %adjust the edit box to reflect changes in the slider
    box = findobj('tag',['edit',src.Tag(end)]);
    box.String = num2str(src.Value);
    %edit hardware settings
    ab = findobj('tag','myarduino');
    data = ab.UserData;
    pins = ['D11';'D13';'D12'];
    pin=pins(str2num(src.Tag(end)),:);
    writePWMDutyCycle(data.a,pin,src.Value/100);
end

function myeditor(src,event)
    %adjust the slider to reflect changes in the edit box
    slide = findobj('tag',['slide',src.Tag(end)]);
    slide.Value = str2num(src.String);
    %edit hardware settings
    ab = findobj('tag','myarduino');
    data = ab.UserData;
    pins = ['D11';'D13';'D12'];
    pin=pins(str2num(src.Tag(end)),:);
    writePWMDutyCycle(data.a,pin,slide.Value/100);
end

function newname = checkfilename(filename,extension)
    status = findobj('tag','status');
    newname=[filename,extension];
    i=1;
    while exist(newname,'file')==2
        status.String=[status.String;{[newname,' already exists']}];
        newname=[filename,'(',num2str(i),')',extension];
        i=i+1;
    end
end
