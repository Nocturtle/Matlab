hFig = figure('NumberTitle','Off','Name','vsg9_franklab',...
    'closerequestfcn',['delete(gcf);'],...
    'units','norm','pos', [.25 .25 .25 .5]);

inputs=uicontrol('string','change settings',...
    'callback',{@settings},'userdata',{'1','0 42 69 177','0','5','4','0','5','.5 .5 .5','4','1','.5 1 2', '100','10','blue green grey','1 0.5 1 10','stim_timings'},...
    'parent',hFig,'units','norm','pos',[0 .85 .3 .15]);
uicontrol('string','save settings',...
    'callback',{@savesettings,inputs},...
    'parent',hFig,'units','norm','pos',[0 .7 .3 .15]);
uicontrol('string','load settings',...
    'callback',{@loadsettings,inputs},...
    'parent',hFig,'units','norm','pos',[0 .55 .3 .15]);

flag=uicontrol('style','togglebutton','string','start','BackgroundColor','g',...
    'callback',{@start,inputs},'userdata',0,...
    'parent',hFig,'units','norm','pos',[0 .4 .3 .15]);
uicontrol('string','stop','BackgroundColor','r',...
    'callback',{@stop,flag},...
    'parent',hFig,'units','norm','pos',[0 .25 .3 .15]);

status=uicontrol('style','edit','tag','status','max',2,'horizontalalignment','left',...
    'string',cell(42,1),...[{''};{'^^^^Status^^^^'};],...
    'parent',hFig,'units','norm','pos',[0.3 0 .7 1]);

vsgInit;

%%

function updatestatus(newstring)
    status=findobj('tag','status');
    status.String(2:end)=status.String(1:end-1);
    
    if ~iscell(newstring)
        status.String{1}=newstring;
    else
        status.String(1)=newstring;
    end
    drawnow
end

function settings(src,~)
    inputs=src.UserData;
    prompt = {'Do you want split screen for this experiment? (1 for yes, 0 for no)',...
    'Angles for left half of (or full) screen? (separate with spaces, 0 for greyscreen, -1 for CW, -2 for CCW)', ...
    'Angles for right half of screen? (not used if ''no'' to question 1)', ...
    'How long would you like each stimulus to appear? (in seconds)', ...
    'How many times do you want each stimulus to appear?', ...
    'Do you want each angle specified above to be immediatly followed by a reversal? (1 for yes, 0 for no)', ...
    'inter-stimulus interval duration (s)', ...
    'inter-stimulus interval color (0-1) [R G B]', ...
    'Split stimulus into this many segments', ...
    'Grating speed duration/frequency mode (1 or 2)', ...
    'Grating speed duration/frequency parameters: 1:[cycles per second separated with spaces] or 2:[duration(s) modul_fs(hz) min_fs(hz) max_fs(hz)]', ...
    'Contrast: (1-100) ', ...
    'size of fixation point (0 to disable)',...
    'color(s) of fixation point (red blue green black white grey)',...
    'fixation point duration/frequency parameters: [duration(s) modul_fs(hz) min_fs(hz) max_fs(hz)]'...
    'Text file name for writing stimuli information: ',};
    title = 'Gratings';
    inputs = inputdlg(prompt,title,1,inputs,'on');
err=0;
a=1;b=1;c=crsGetNumVideoPages;
if ~isempty(inputs)%in case cancel button is pressed
    if ~isempty(inputs{2})
        a=strsplit(inputs{2},' ');
        if(isempty(a{end})), a=a(1:end-1); end
        a=length(cellfun(@str2num,a));
        if a>c
            updatestatus(['not enuf video memory for more than ',num2str(c),' angles']);
            err=1;
        end
    end
    if ~isempty(inputs{3})
        b=length(cellfun(@str2num,strsplit(inputs{3},' ')));
        if b>c
            updatestatus(['not enuf video memory for more than ',num2str(c),' angles']);
            err=1;
        end
    end
    if (a*b)>c
        updatestatus('too many combinations of angles');
        updatestatus(['not enuf video memory for more than ',num2str(c),' angles']);
        err=1;
    end
    if isempty(inputs{2}) && isempty(inputs{3})
        updatestatus('no angles input');
        err=1;
    end
else
    err=1;
    updatestatus('settings canceled');
end
if ~err
    src.UserData=inputs;
else
    updatestatus('settings canceled, no changes were saved');
end
end
function savesettings(~,~,inputs)
    inputs=inputs.UserData;
    out='[';
    for i=1:length(inputs)
        out=[out,'"',inputs{i},'",'];
    end
    out(end)=']';
    [f,p]=uiputfile('*.txt');
    fid=fopen([p,f],'w');
    fwrite(fid,out);
    fclose(fid);
    updatestatus(['saved ',p,f])
end
function loadsettings(~,~,inputs)
    [f,p]=uigetfile('*.txt');
    fid=fopen([p,f],'r');
    line=fgetl(fid);
    fclose(fid);
    inputs.UserData=eval(line);
    updatestatus(['loaded ',p,f])
end

function start(src,~,inputs)
    global CRS
if src.Value
updatestatus('preparing to start')
inputs=inputs.UserData;
    src.UserData=1;
    vsgInit;
    pause(1)
    crsSetTriggerOptions(CRS.TRIGGER_OPTIONS_PRESENT,0,0,12,0,0,0);
    crsObjSetTriggers(CRS.TRIG_ONPRESENT,0,0);
    pause(2)%wait for settings to apply
    
    crsResetTimer;
    inittime=datetime('now');
    T=tic;
    
	ScreenWidth  = crsGetScreenWidthPixels;
	ScreenHeight = crsGetScreenHeightPixels;
    
    %parse inputs------------------------------------------------------------------------------------
    ss = str2double(inputs{1}); %split screen
    gA = cellfun(@str2num,strsplit(inputs{2},' '),'uniformoutput',false)';%grating angles
    if iscell(gA)
        gA = gA(~cellfun(@isempty,gA));
        gA = cat(1,gA{:});
    end
    stimDur = str2double(inputs{4}); %stimulus duration
    reps = str2double(inputs{5}); % number of repetitions
    rev = str2double(inputs{6}); % reversal
    isiDur = str2double(inputs{7}); %inter stimulus interval duration
    isiColor = cellfun(@str2double,strsplit(inputs{8},' '))'; %inter stimulus interval color
    n = str2double(inputs{9}); %number of bars/wedges
    m = str2double(inputs{10}); %grating speed mode
    velP = cellfun(@str2double,strsplit(inputs{11},' '))'; %gratings speed duration/frequency parameters
    contrast = str2double(inputs{12});
    fixS = str2double(inputs{13});%size of fixation point
    fixC = strsplit(inputs{14},' ')';%color(s) of fixation point
    fixP = cellfun(@str2double,strsplit(inputs{15},' '))';%fixation point duration/frequency parameters
    filename = inputs{16};
    nV=1;
    if ss && m==1
        gHA = cellfun(@str2num,strsplit(inputs{3},' '))'; %grating angles for half screen
        numPages = length(gA)*length(gHA);
        gAb = allcomb(gA,gHA);
        gA = allcomb(gA,gHA,velP);
        ScreenWidth = ScreenWidth/2;
        nV=length(velP);
    elseif ss
        gHA = cellfun(@str2num,strsplit(inputs{3},' '))'; %grating angles for half screen
        numPages = length(gA)*length(gHA);
        gA = allcomb(gA,gHA);
        ScreenWidth = ScreenWidth/2;
    elseif m==1
        numPages = length(gA);
        gAb = gA;
        gA=allcomb(gA,velP);
        nV=length(velP);
    else
        numPages = length(gA);
    end
    
    
	%check limits-> crsGetNumObjects<=numPages	
    if(crsGetNumVideoPages<=(numPages)); updatestatus('error: VSG does not have enough memory'); return; end
    
    % Define some pages
    startPage = 1;
    endPage   = startPage + numPages - 1;
    pages     = startPage:endPage;
    blackPage = endPage + 1;
    % Define some colors
    black = [0,0,0];
    white = [1,1,1];
    grey  = (black + white) ./ 2;
    red   = [1,0,0];
    green   = [0,1,0];
    blue   = [0,0,1];
    % Define some pixel levels
    startLev  = 1;
    endLev    = 251;
    numLev = endLev-startLev;
	
    %init test order
    [index,~,ballbagState] = crsPsychMethodBallBag(1:length(gA),reps);
    testOrder = cellfun(@num2str,num2cell(gA(ballbagState.values_to_test,:)),'uniformoutput',false);
    testOrder(strcmp(testOrder,'0'))={'graystim'};
    testOrder(strcmp(testOrder,'-1'))={'CW'};
    testOrder(strcmp(testOrder,'-2'))={'CCW'};
    if ss && m==1
         testOrder=strcat(testOrder(:,1),'_',testOrder(:,2),'__',testOrder(:,3)); 
    elseif ss
         testOrder=strcat(testOrder(:,1),'_',testOrder(:,2)); 
    elseif m==1
         testOrder=strcat(testOrder(:,1),'__',testOrder(:,2)); 
    end
    if rev, testOrder=[testOrder,strcat(testOrder,'_reversal')]; end
    
    if isiDur>0
    testOrder=[testOrder,repmat({'ISI'},length(gA)*reps,1)];
    testOrder=reshape(testOrder',[],1);
    testOrder=[{'ISI'};testOrder];
    else
    testOrder=reshape(testOrder',[],1);
    end
    
    %init array to store timing
    abstime=zeros(length(testOrder),1);
    
    %prepare for drawing-----------------------------------------------------------------------------
    crsSetDrawPage(CRS.VIDEOPAGE,blackPage,1);
    crsSetBackgroundColour(black);
%     crsDrawMatrixPalettised(ones(ScreenHeight,ScreenWidth).*256);
    crsSetZoneDisplayPage(CRS.VIDEOPAGE,blackPage);
    crsSetPen1(CRS.FIXATION);
	%draw stimuli for all the pages
    for i=pages
        crsSetDrawPage(CRS.VIDEOPAGE,i,CRS.BACKGROUND);
        crsSetBackgroundColour(grey);
        if ss
            l=getstim(ScreenWidth, ScreenHeight, gAb(i,1),n,startLev,numLev);
            r=getstim(ScreenWidth, ScreenHeight, gAb(i,2),n,startLev,numLev);
            stim = [l,r];
        else
            stim=getstim(ScreenWidth, ScreenHeight, gAb(i),n,startLev,numLev);
        end
        crsDrawMatrixPalettised(stim);
        if ss
            if gAb(i,1)~=0
                crsDrawOval([-ScreenWidth/2 0],[fixS fixS]);
            end
            if gAb(i,2)~=0
                crsDrawOval([ScreenWidth/2 0],[fixS fixS]);
            end
        else
            if gAb(i)~=0
                crsDrawOval([0 0],[fixS fixS]);
            end
        end
    end
    
% write Look-Up-Table --------------------------------------
screenFs = crsGetFrameRate;
stimDurFr = stimDur*screenFs;
switch m
    case 1
        vels = gA(ballbagState.values_to_test,2+ss);
        TimeMS = linspace(0,stimDur*1000,stimDurFr); % Time vector, in milliseconds
        VelDPS = ones(size(TimeMS)).*vels;%****
        if rev
          stimDurFr = stimDurFr*2;
          VelDPS = [VelDPS,-VelDPS];
        end
        VelDPS = reshape(VelDPS',1,[]);

        % Position (Phase) is the integral of velocity
        PosDEG = cumsum(VelDPS)/screenFs;         % cycles.
        PosDMP = mod(PosDEG,(1/n));           % cycles, modulo size of one period.
        PosNOR = PosDMP / (1/n);              % Normalised Units, relative to size of period.
        PosPIX = startLev + round(PosNOR * numLev); % Pixel levels. (palette entries)

        LUT = ones(256,stimDurFr*length(vels));
        for ii = 1:stimDurFr*length(vels)
            FromPIX   = PosPIX(ii);
            ToPIX     = FromPIX + floor(numLev/2);
            PixelLevs = [FromPIX:ToPIX];
            PixelLevs = floor(startLev + mod(PixelLevs,numLev));
            LUT(PixelLevs,ii) = 0;
        end
    case 2
        velCycles = velP(1)*velP(2);
        velRadians = 2*pi*velCycles;
        velFrames = screenFs * velP(1);
        velMaxFs = velP(4);%/screenFs
        velMinFs = velP(3);%/screenFs
        
        % Create our modulating functional form *************************************
        Sinus = sin(linspace(-pi/2,velRadians-pi/2,velFrames));    % Modulating functional form
        while length(Sinus)<stimDurFr
            Sinus=[Sinus,Sinus];
        end
        Sinus=Sinus(1:stimDurFr);
        Sinus = (Sinus + 1) / 2;                          % ...Normalised,
%         Sinus = (Sinus + velMinFs) .* (velMaxFs - velMinFs); % ...in Cycles per Frame
        Sinus=rescale(Sinus,velMinFs,velMaxFs);
%         Sinus = 2 * pi * Sinus;                           % ...in Radians per Frame
        
        if rev
          velFrames = velFrames*2;
          Sinus = [Sinus,-Sinus];
        end
        
        % Finally our luminance temporal profile ************************************
%         SinusFM = sin(cumsum(Sinus)); % Modulated functional form
%         SinusFM = (SinusFM + 1) / 2;  % ...Normalised,
        PosDEG = cumsum(Sinus)/screenFs;         % cycles.
        PosDMP = mod(PosDEG,(1/n));           % cycles, modulo size of one period.
        PosNOR = PosDMP / (1/n);              % Normalised Units, relative to size of period.
        PosPIX = startLev + round(PosNOR * numLev); % Pixel levels. (palette entries)
        
        LUT = ones(256,velFrames);
        for ii = 1:velFrames
            FromPIX   = PosPIX(ii);
            ToPIX     = FromPIX + floor(numLev/2);
            PixelLevs = [FromPIX:ToPIX];
            PixelLevs = floor(startLev + mod(PixelLevs,numLev));
            LUT(PixelLevs,ii) = 0;
        end
end
  
  LUT = LUT*contrast/100;
  LUT(254,:)=.5;
  R = LUT;
  G = LUT;
  B = LUT;
  
if fixS>0
    %fixation point stuff
    fixCycles = fixP(1)*fixP(2);
    fixRadians = 2*pi*fixCycles;
    fixFrames = screenFs * fixP(1);
    fixMaxFs = fixP(4)/screenFs;
    fixMinFs = fixP(3)/screenFs;

    % Create our modulating functional form *************************************
    Sinus = sin(linspace(1,fixRadians,fixFrames));    % Modulating functional form
    Sinus = (Sinus + 1) / 2;                          % ...Normalised,
    Sinus = (Sinus + fixMinFs) .* (fixMaxFs - fixMinFs); % ...in Cycles per Frame
    Sinus = 2 * pi * Sinus;                           % ...in Radians per Frame

    % Finally our luminance temporal profile ************************************
    SinusFM = sin(cumsum(Sinus)); % Modulated functional form
    SinusFM = (SinusFM + 1) / 2;  % ...Normalised,  

    fixBag = randperm(length(fixC));
    fix=[];
    fixLUT=zeros(3,length(SinusFM));
    i=1;
    while(size(fix,2)<size(R,2))
        if isempty(fix)
            switch(fixC{fixBag(i)})
                case 'red'
                  prev = red;
                case 'green'
                  prev = green;
                case 'blue'
                  prev = blue;
                case 'white'
                  prev = white;
                case 'black'
                  prev = black;
                case 'grey'
                  prev = grey;
            end
            i=i+1;
        end
        switch(fixC{fixBag(i)})
            case 'red'
                fixLUT = (SinusFM+prev').*abs(red-prev)';
            case 'green'
                fixLUT = (SinusFM+prev').*abs(green-prev)';
            case 'blue'
                fixLUT = (SinusFM+prev').*abs(blue-prev)';
            case 'white'
                fixLUT = (SinusFM+prev').*abs(white-prev)';
            case 'black'
                fixLUT = (SinusFM+prev').*abs(black-prev)';
            case 'grey'
                fixLUT = (SinusFM+prev').*abs(grey-prev)';
        end
        fix=[fix fixLUT];
        i=i+1;
        if i>length(fixC)
            i=1;
            next = randperm(length(fixC));
            while next(1)==fixBag(end)
            next = randperm(length(fixC));
            end
            fixBag=next;
        end
    end
    
    fix=fix(:,1:size(R,2));
    R(CRS.FIXATION,:)=fix(1,:);
    G(CRS.FIXATION,:)=fix(2,:);
    B(CRS.FIXATION,:)=fix(3,:);
end

  crsLUTBUFFERWrite(1,R,G,B);
% crsLUTBUFFERCyclingSetup(number,framedelay,firstLUT,lastLUT,  LUTStoSkip,startLUT,triggerLUT)
  crsLUTBUFFERCyclingSetup(    -1,         1,       1,size(R,2),         1,       1,         1);
  
    i=1;
% run experiment ----------------------------------------------------------
    while(src.UserData)
% initial stimuli --------------------------------------------------------------
        if i==1 && isiDur>0
            crsSetBackgroundColour(isiColor);
            crsSetDrawPage(CRS.VIDEOPAGE,blackPage,CRS.BACKGROUND);
            crsSetZoneDisplayPage(CRS.VIDEOPAGE,blackPage);
            updatestatus(testOrder(i))
            abstime(i)=toc(T);
            crsPresent();
            while((toc(T)-abstime(i))<isiDur && src.UserData), end, i=i+1;%drawnow, 
        end
% normal stimuli ---------------------------------------------------------------
        crsSetZoneDisplayPage(CRS.VIDEOPAGE,pages(mod(ceil(index/nV)-1,numPages)+1));
        crsSetCommand(CRS.CYCLELUTENABLE);
        crsSetBackgroundColour(grey);
        updatestatus(testOrder(i))
        abstime(i)=toc(T);
            while((toc(T)-abstime(i))<stimDur && src.UserData), end, i=i+1;
% reverse stimuli --------------------------------------------------------------
        if rev
            updatestatus(testOrder(i))
            abstime(i)=toc(T);
            while((toc(T)-abstime(i))<stimDur && src.UserData), end, i=i+1;
        end
        crsSetCommand(CRS.CYCLELUTDISABLE);
% inter-stimuli-interval -------------------------------------------------
        if isiDur>0
            crsSetBackgroundColour(isiColor);
            crsSetDrawPage(CRS.VIDEOPAGE,blackPage,CRS.BACKGROUND);
            crsSetZoneDisplayPage(CRS.VIDEOPAGE,blackPage);
            updatestatus(testOrder(i))
            abstime(i)=toc(T);
        	while((toc(T)-abstime(i))<isiDur && src.UserData), end, i=i+1;
        end

% update index -------------------
        [index,is_finished] = crsPsychMethodBallBag;
        if src.UserData, src.UserData = ~is_finished; end
    end
% wrap up ------------------------
    crsSetBackgroundColour(black);
    crsSetDrawPage(CRS.VIDEOPAGE,blackPage,CRS.BACKGROUND);
    crsSetZoneDisplayPage(CRS.VIDEOPAGE,blackPage);
%write stim log ---------------------------------------------------------------
    ii=1;
    temp = filename;
    filename=[filename,'.log'];
    while exist(filename,'file')==2
%         updatestatus([filename,' already exists'])
        filename=[temp,'(',num2str(ii),').log'];
        ii=ii+1;
    end
    updatestatus(['saving as: ',filename])
    fid = fopen(filename,'w');
    for ii=1:i-1
       fprintf(fid,'%s\t%s\n',datestr(inittime+seconds(abstime(ii)),'mm/dd/yyyy	HH:MM:SS.FFF'),testOrder{ii});  
    end 
    fclose(fid);
    updatestatus('done')
    updatestatus('')
    src.Value=0;
    vsgInit;
else
    src.Value=1;
end
end
function stop(~,~,flag)
    flag.UserData=0;
    flag.Value=0;
end
function out = getstim(width,height,stim,n,StartLev,NumLev)
s=max(width,height);
  [a,~] = utilCRSgenCoordsPolar(s,s);
  [x,y] = utilCRSgenCoordsCart(s,s);
  
    x=x-min(x(:)); x=x/max(x(:));
    y=y-min(y(:)); y=y/max(y(:));
    a=a-min(a(:)); a=a/max(a(:));
    
  if stim~=0
      switch(stim)
          case -2
              out = a;
          case -1
              out = flip(a);
          otherwise
%               updatestatus('unknown input for stim')
                  r=[cosd(stim) -sind(stim); sind(stim) cosd(stim)];
                  Z=cat(3,x,y);
                  Z=permute(Z,[1 3 2]);
                  for i=1:size(Z,3)
                      Z(:,:,i)=Z(:,:,i)*r;
                  end
                  Z=permute(Z,[1 3 2]);
                  
                  out = Z(:,:,2);
%               return;
      end
      
      out=mod(out(1:height,1:width).*n,1);
      out=round(StartLev+(out.*(NumLev-1)));
  else
      out = ones(height,width).*254;
  end
end