

%% safety
close all
fclose all
clear all
clc
%% settings : 1=enable & 0=disable unless otherwise noted
sett=struct;
sett.sinus=1;% enable/disable sinusoidal gratings
sett.split=0;% enable/disable splitscreen
sett.ang{1}=[180];% angles to use for left half (or full) of screen. 0 for greyscreen, -1 for CW, -2 for CCW
sett.ang{2}=[90 360];% angles for right half (not used if splitscreen==0)
sett.sdur=10;% duration of each stimulus (seconds)
sett.srep=2;% how many times to repeat each stimulus
sett.rev=0;% enable/disable reversal of each angle specified above
sett.isidur=1;% duration of inter-stimulus-interval
sett.isicol=[0 0 0];% color of inter-stimulus-interval (0-1) [R G B]
sett.seg=2;% split the stimulus into this many segments (number of white/black bar pairs, max=126?)
sett.gsm=0;% choose gratings speed mode (0 or 1), see next two settings for details
sett.gs0=[.2];% (cycles per second) this mode randomizes the gratings' speed pulling values from this list. one cycle is a bar passing from one side of the screen to the other horizontally.
sett.gs1=[4 0.25 0.5 2];% [duration(s) modul_fs(hz) min_fs(hz) max_fs(hz)] this mode modulates the gratings' speed using these parameters
sett.contrast=100;% 1-100, lowers brightness/whiteness
sett.fixsz=10;% radius (pixels) of fixation point (0 to disable)
sett.fixcol=[0 0 1;...% color(s) the fixation point will switch between [R G B; R G B; ...];
            0 1 0;...
            .5 .5 .5;...
            ];
sett.fixparam=[5 0.5 .5 2];% [duration(s) modul_fs(hz) min_fs(hz) max_fs(hz)] parameters for the speed/duration that fixation point changes color
sett.fout=["default"];% text file name for outputing stimuli information 
##sett.foutfs1=['smb://fs1/franklab/D.Harvey/VSGlogs'];

%% uncomment to save/load settings
% save('testVSGsettings','set');
% load('testVSGsettings');
try
%% setup 
%rpi gpio
ttl_pin=4;
addpath(genpath('/home/pi/octave-rpi-gpio'));
bcm2835_init();
bcm2835_gpio_fsel(ttl_pin, 1);
bcm2835_gpio_clr(ttl_pin)
%get screen info ----------------------------------------------------
Screen('Preference','VisualDebugLevel',1);
##Screen('Preference','SkipSyncTests',1);
##Screen('Preference','SuppressAllWarnings',1vlb);
PsychGPUControl('FullScreenWindowDisablesCompositor',1);

ss=Screen('Screens');
ssn=max(ss);%screens num
% origLUT=Screen('ReadNormalizedGammaTable',ssn);
% nLUT=size(origLUT,1);
hz=Screen('FrameRate',ssn);
[w,h]=Screen('WindowSize',ssn);

PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','AllViews','EnableCLUTMapping');
S=PsychImaging('OpenWindow',ssn,0);

% Look-up tables ------------------------------------------------------------------
%gratings LUT
numLev=252;
if sett.sinus, LUT=(repmat(cos(linspace(-pi,pi,numLev))',1,3)+1)/2;
else, LUT=repmat(round(linspace(0,1,numLev))',1,3); 
end
##LUT=zeros(256,3);
##LUT(1:10,:)=1;
LUT(254,:)=.5;% grey 
LUT(255,:)=sett.fixcol(1,:);% reserve for fixation point
LUT(256,:)=sett.isicol;% isi
LUT=LUT*sett.contrast/100;
Screen('LoadNormalizedGammaTable',S,LUT,2);

% gratings speed LUT
if sett.gsm
    stimdurfr=hz*sett.gs1(1); %stim duration in frames
    vel=sett.gs1(1)*sett.gs1(2)*pi*2;
    WAVE = cos(linspace(0,vel,stimdurfr+1)+pi);
    WAVE = (WAVE+1)/2;
    m1=numLev*sett.gs1(3);
    m2=numLev*sett.gs1(4);
    WAVE=(WAVE*(m2-m1)+m1)*sett.sdur;
    LS = abs(diff(floor(WAVE)))';
else
    stimdurfr=hz*sett.sdur; %stim duration in frames
    ngs=length(sett.gs0);
    LS=zeros(stimdurfr,ngs);
    for i=1:ngs, LS(:,i)=diff(floor(linspace(1,numLev*sett.gs0(i)*sett.sdur,stimdurfr+1))); end
end

% fixation point color LUT
if sett.fixsz>0
    fixdurfr=hz*sett.fixparam(1);
    vel=sett.fixparam(1)*sett.fixparam(2)*2*pi;
    WAVE = cos(linspace(0,vel,fixdurfr)+pi);
    WAVE = (WAVE+1)/2;
    
    n=size(sett.fixcol,1);
    FLS=[];
    test=Shuffle(1:n);
    for i=1:n
        c1=sett.fixcol(test(mod(i-1,n)+1),:);
        c2=sett.fixcol(test(mod(i,n)+1),:);
            for k=1:3
                if c1(k)>c2(k)
                  temp(:,k)=(1-WAVE)*(c1(k)-c2(k))+c2(k);
                elseif c1(k)<c2(k)
                  temp(:,k)=WAVE*(c2(k)-c1(k))+c1(k);
                elseif c1(k)==c2(k) && c1(k)>0
                  temp(:,k)=ones(fixdurfr,1)*c1(k);
                else
                  temp(:,k)=zeros(fixdurfr,1);
                endif
            end
            FLS=[FLS;temp];
    end
    nFLS=length(FLS);
    
    [cx,cy]=meshgrid(-sett.fixsz:sett.fixsz, -sett.fixsz:sett.fixsz);
    circle = (cx.^2 + cy.^2 <= (sett.fixsz)^2);
end

% draw gratings textures ---------------------------------------------------
angs=sett.ang{1}(sett.ang{1}>0);
if sett.split, angs=[angs,sett.ang{2}(sett.ang{2}>0)]; w=w/2; end
angs=unique(angs);

[x,y]=meshgrid(linspace(-1,1,w),linspace(-1,1,h));
[a,~]=cart2pol(x.*pi,y.*pi);
a=mod((a+pi)./2./pi*sett.seg,1).*(numLev-1);
if sett.fixsz>0
    idx1=(h/2-sett.fixsz):(h/2+sett.fixsz);
    idx2=(w/2-sett.fixsz):(w/2+sett.fixsz);
    ss=a(idx1,idx2);
    ss(circle)=254;
    a(idx1,idx2)=ss;
end
tex(1)=Screen('MakeTexture',S,flip(a),[],[]); %CW
tex(2)=Screen('MakeTexture',S,a,[],[]); %CCW

n=max(w,h);
[x,y]=meshgrid(linspace(-1,1,n),linspace(-1,1,n));
for i=1:length(angs)
    g=cosd(angs(i))*x+sind(angs(i))*y;
    g=mod((g+sqrt(2))/sqrt(8)*sett.seg,1)*(numLev-1);
    if sett.fixsz>0
        ss=g(idx1,idx2);
        ss(circle)=254;
        g(idx1,idx2)=ss;
    end
    tex(i+2)=Screen('MakeTexture',S,g(1:h,1:w),[],[]); %Gratings
end

% prepare test order ------------------------------------------------
test=sett.ang{1};
if sett.split, test=CombVec(test,sett.ang{2}); end
if ~sett.gsm, test=CombVec(test,sett.gs0); end
test=test';

testOrder=[];
for i=1:sett.srep
    idx=Shuffle(1:size(test,1));
    testOrder=[testOrder;test(idx,:)];
end

testIDX=testOrder;
for i=1:length(angs)
    testIDX(testOrder==angs(i))=i+2;
end
if ~sett.gsm, testIDX(:,end)=mod(find(testOrder(:,end)'==sett.gs0')+ngs-1,ngs)+1; end
testIDX=abs(testIDX);

% prep text output -------------------------
testOrder=num2cell(testOrder);
testOrder=cellfun(@num2str,testOrder,'uniformoutput',false); 
testOrder(strcmp(testOrder,'0'))="graystim";
testOrder(strcmp(testOrder,'-1'))="CW";
testOrder(strcmp(testOrder,'-2'))="CCW";
if sett.split, testOrder(:,1)=strcat(testOrder(:,1),'_',testOrder(:,2)); testOrder(:,2)=[]; end
if ~sett.gsm, testOrder(:,1)=strcat(testOrder(:,1),'__',testOrder(:,2)); testOrder(:,2)=[]; end
if sett.rev, testOrder=[testOrder,strcat(testOrder,'_reversal')]; end
if sett.isidur>0, testOrder=[repmat({"ISI"},length(testOrder),1),testOrder]; end
testOrder=reshape(testOrder',[],1);
testOrder=[testOrder;{"ISI"}];

abstime=zeros(length(testOrder),1);

%% ?!? ------------------------------------------------------------------
% clearvars x y a g circle
%% hold
HideCursor
while(1), if KbStrokeWait, break; end, end
bcm2835_gpio_set(ttl_pin);

%% run
flag=true;
TS = clock;
ts=GetSecs; j=1; k=1; l=1; m=1;
for i=1:size(testIDX,1)
% ISI ---------------------------------------------------------------------
    Screen('FillRect',S,255);
    Screen('Flip',S,0,1,1,0);
    t0=GetSecs; t1=t0;
    abstime(j)=t0-ts;
    while(t1-t0<sett.isidur) && flag
        t1=GetSecs;
        if KbCheck, flag=false; break; end
    end, j=j+1;
% stim ------------------------------------------------------------------
    Screen('FillRect',S,253);
    for ii=1:1+sett.split
        ang=testIDX(i,ii);
        if ang~=0, Screen('DrawTexture',S,tex(ang),[0 0 w h],[(ii-1)*w 0 ii*w h],[],0); end
    end
    if ~sett.gsm, l=testIDX(i,end); end
    t0=GetSecs; t1=t0;
    abstime(j)=t0-ts;
    while(t1-t0<sett.sdur) && flag
##    for k=1:stimdurfr
        shift=LS(k,l);
        LUT=LUT([1+shift:numLev,1:shift,numLev+1:end],:);
        col=FLS(m,:);
        LUT(255,:)=col;
        Screen('LoadNormalizedGammaTable',S,LUT,2);
        Screen('Flip',S,0,1,1,0);

        t1=GetSecs; k=mod(k,stimdurfr)+1;
        m=mod(m,nFLS)+1;
        if KbCheck, flag=false; break; end
    end, j=j+1; 
% reversal ------------------------------------------------------------
    if sett.rev
    t0=GetSecs; t1=t0;
    abstime(j)=t0-ts;
    while(t1-t0<sett.sdur) && flag
        shift=LS(k,l);
        LUT=LUT([numLev-shift+1:numLev,1:numLev-shift,numLev+1:end],:);
        col=FLS(m,:);
        LUT(255,:)=col;
        Screen('LoadNormalizedGammaTable',S,LUT,2);
        Screen('Flip',S,0,1,1,0);

        t1=GetSecs; k=mod(k,stimdurfr)+1;
        m=mod(m,nFLS)+1;
        if KbCheck, flag=false; break; end
    end, j=j+1;
    end
% check for user interuption ----
    if ~flag, break; end
end
% last ISI ---------------------
    Screen('FillRect',S,255);
    Screen('Flip',S);
    t0=GetSecs; t1=t0;
    abstime(j)=t0-ts;
    while(t1-t0<sett.isidur) && flag
        t1=GetSecs;
        if KbCheck, flag=false; break; end
    end

%% wrap
bcm2835_gpio_clr(ttl_pin);
bcm2835_close();
ShowCursor
RestoreCluts;
sca;
%write stim log ---------------------------------------------------------------
     ii=1;
     pout=[pwd,'/logs/'];
     if ~exist(pout,'dir'); mkdir(pout); end
     filename=[pout,sett.fout,'.log'];
     while exist(filename,'file')==2
         disp([filename,' already exists'])
         filename=[pout,sett.fout,'(',num2str(ii),').log'];
         ii=ii+1;
     end
     disp(['saving as: ',filename])
     fid = fopen(filename,'w');
     for ii=1:j-1
       fprintf(fid,'%s\t%s\n',datestr(datenum(TS)+abstime(ii)/86400,'mm/dd/yyyy	HH:MM:SS.FFF'),testOrder{ii});  
     end 
     fclose(fid);
##     copyfile(filename,sett.foutfs1);
##     disp(['copied ',sett.fout,' to ',sett.foutfs1]);

catch err
disp(err)
bcm2835_gpio_clr(ttl_pin);
bcm2835_close();
ShowCursor
RestoreCluts;
sca;
end


%% local funtions



%% junk






