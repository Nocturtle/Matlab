

%% safety
close all
fclose all
clear all
clc

fout=["default"];% text file name for outputing stimuli information 
%% paste this into file browser to get to fs1: 'smb://fs1/franklab/', then enter credentials

%% settings instructions : 1=enable & 0=disable unless otherwise noted 
%% copy/cut/paste, then iterate B to add or remove blocks of stimuli
sett=struct;
% BLOCK1: 4.5 min grey screen ------------------
B=1;
sett(B).wave=2;% 0=square, 1=sawtooth, 2=sinusoidal gratings
sett(B).split=0;% enable/disable splitscreen
sett(B).ang{1}=[0];% angles to use for left half (or full) of screen. 0 for greyscreen, -1 for CW, -2 for CCW
sett(B).ang{2}=[];% angle to use for thr 60-phase reversal
sett(B).rand=0;% randomize the specified angles
sett(B).sdur=270;% duration of each stimulus (seconds)
sett(B).srep=1;% how many times to repeat each stimulus
sett(B).rev=0;% enable/disable reversal of each angle specified above
sett(B).isien=0;% enable/disable inter-stimulus-interval
sett(B).isidur=0;% duration of inter-stimulus-interval
sett(B).isicol=[.5 .5 .5];% color of inter-stimulus-interval (0-1) [R G B]
sett(B).seg=2;% split the stimulus into this many segments (number of white/black bar pairs, max=126?)
sett(B).gsm=0;% choose gratings speed mode (0 or 1), see next two settings for details
sett(B).gs0=[.2];% (cycles per second) this mode randomizes the gratings' speed pulling values from this list. one cycle is a bar passing from one side of the screen to the other horizontally.
sett(B).gs1=[4 0.25 0.5 2];% [duration(s) modul_fs(hz) min_fs(hz) max_fs(hz)] this mode modulates the gratings' speed using these parameters
sett(B).contrast=100;% 1-100, lowers brightness/whiteness
sett(B).fixsz=0;% radius (pixels) of fixation point (0 to disable)
sett(B).fixcol=[0 0 1;...% color(s) the fixation point will switch between [R G B; R G B; ...];
				0 1 0;...
				.5 .5 .5;...
				];
sett(B).fixparam=[5 0.5 .5 2];% [duration(s) modul_fs(hz) min_fs(hz) max_fs(hz)] parameters for the speed/duration that fixation point changes color
% BLOCK2: x5 two min gratings w/ 30 sec isi ------------------
B=2;
sett(B).wave=2;% 0=square, 1=sawtooth, 2=sinusoidal gratings
sett(B).split=0;% enable/disable splitscreen
sett(B).ang{1}=[360 45 90 135 180];% angles to use for left half (or full) of screen. 0 for greyscreen, -1 for CW, -2 for CCW
sett(B).ang{2}=[];% angle to use for thr 60-phase reversal
sett(B).rand=0;% randomize the specified angles
sett(B).sdur=120;% duration of each stimulus (seconds)
sett(B).srep=1;% how many times to repeat each stimulus
sett(B).rev=0;% enable/disable reversal of each angle specified above
sett(B).isien=1;% enable/disable inter-stimulus-interval
sett(B).isidur=30;% duration of inter-stimulus-interval
sett(B).isicol=[.5 .5 .5];% color of inter-stimulus-interval (0-1) [R G B]
sett(B).seg=2;% split the stimulus into this many segments (number of white/black bar pairs, max=126?)
sett(B).gsm=0;% choose gratings speed mode (0 or 1), see next two settings for details
sett(B).gs0=[.2];% (cycles per second) this mode randomizes the gratings' speed pulling values from this list. one cycle is a bar passing from one side of the screen to the other horizontally.
sett(B).gs1=[4 0.25 0.5 2];% [duration(s) modul_fs(hz) min_fs(hz) max_fs(hz)] this mode modulates the gratings' speed using these parameters
sett(B).contrast=100;% 1-100, lowers brightness/whiteness
sett(B).fixsz=0;% radius (pixels) of fixation point (0 to disable)
sett(B).fixcol=[0 0 1;...% color(s) the fixation point will switch between [R G B; R G B; ...];
				0 1 0;...
				.5 .5 .5;...
				];
sett(B).fixparam=[5 0.5 .5 2];% [duration(s) modul_fs(hz) min_fs(hz) max_fs(hz)] parameters for the speed/duration that fixation point changes color
% BLOCK3: 30 sec grey ------------------
B=3;
sett(B).wave=2;% 0=square, 1=sawtooth, 2=sinusoidal gratings
sett(B).split=0;% enable/disable splitscreen
sett(B).ang{1}=[0];% angles to use for left half (or full) of screen. 0 for greyscreen, -1 for CW, -2 for CCW
sett(B).ang{2}=[];% angle to use for thr 60-phase reversal
sett(B).rand=0;% randomize the specified angles
sett(B).sdur=30;% duration of each stimulus (seconds)
sett(B).srep=1;% how many times to repeat each stimulus
sett(B).rev=0;% enable/disable reversal of each angle specified above
sett(B).isien=0;% enable/disable inter-stimulus-interval
sett(B).isidur=0;% duration of inter-stimulus-interval
sett(B).isicol=[.5 .5 .5];% color of inter-stimulus-interval (0-1) [R G B]
sett(B).seg=2;% split the stimulus into this many segments (number of white/black bar pairs, max=126?)
sett(B).gsm=0;% choose gratings speed mode (0 or 1), see next two settings for details
sett(B).gs0=[.2];% (cycles per second) this mode randomizes the gratings' speed pulling values from this list. one cycle is a bar passing from one side of the screen to the other horizontally.
sett(B).gs1=[4 0.25 0.5 2];% [duration(s) modul_fs(hz) min_fs(hz) max_fs(hz)] this mode modulates the gratings' speed using these parameters
sett(B).contrast=100;% 1-100, lowers brightness/whiteness
sett(B).fixsz=0;% radius (pixels) of fixation point (0 to disable)
sett(B).fixcol=[0 0 1;...% color(s) the fixation point will switch between [R G B; R G B; ...];
				0 1 0;...
				.5 .5 .5;...
				];
sett(B).fixparam=[5 0.5 .5 2];% [duration(s) modul_fs(hz) min_fs(hz) max_fs(hz)] parameters for the speed/duration that fixation point changes color
% BLOCK4: 60 phase reversals ------------------
B=4;
sett(B).wave=2;% 0=square, 1=sawtooth, 2=sinusoidal gratings
sett(B).split=0;% enable/disable splitscreen
sett(B).ang{1}=[45];% angles to use for left half (or full) of screen. 0 for greyscreen, -1 for CW, -2 for CCW
sett(B).ang{2}=[];% angle to use for thr 60-phase reversal
sett(B).rand=0;% randomize the specified angles
sett(B).sdur=1;% duration of each stimulus (seconds)
sett(B).srep=60;% how many times to repeat each stimulus
sett(B).rev=1;% enable/disable reversal of each angle specified above
sett(B).isien=0;% enable/disable inter-stimulus-interval
sett(B).isidur=0;% duration of inter-stimulus-interval
sett(B).isicol=[.5 .5 .5];% color of inter-stimulus-interval (0-1) [R G B]
sett(B).seg=2;% split the stimulus into this many segments (number of white/black bar pairs, max=126?)
sett(B).gsm=0;% choose gratings speed mode (0 or 1), see next two settings for details
sett(B).gs0=[.2];% (cycles per second) this mode randomizes the gratings' speed pulling values from this list. one cycle is a bar passing from one side of the screen to the other horizontally.
sett(B).gs1=[4 0.25 0.5 2];% [duration(s) modul_fs(hz) min_fs(hz) max_fs(hz)] this mode modulates the gratings' speed using these parameters
sett(B).contrast=100;% 1-100, lowers brightness/whiteness
sett(B).fixsz=0;% radius (pixels) of fixation point (0 to disable)
sett(B).fixcol=[0 0 1;...% color(s) the fixation point will switch between [R G B; R G B; ...];
				0 1 0;...
				.5 .5 .5;...
				];
sett(B).fixparam=[5 0.5 .5 2];% [duration(s) modul_fs(hz) min_fs(hz) max_fs(hz)] parameters for the speed/duration that fixation point changes color

%% uncomment to save/load settings
% save('testVSGsettings','sett');
% load('testVSGsettings');

%% Do not edit below this line unless you know what you're doing ---------------------------------------------------------------------------------------------------
try
%% setup 
%rpi gpio
ttl_pin=17;
addpath(genpath('/home/pi/octave-rpi-gpio'));
bcm2835_init();
bcm2835_gpio_fsel(ttl_pin, 1);
bcm2835_gpio_clr(ttl_pin)
%get screen info ----------------------------------------------------
Screen('Preference','VisualDebugLevel',1);
%%Screen('Preference','SkipSyncTests',1);
%%Screen('Preference','SuppressAllWarnings',1vlb);
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

B=length(sett); %number of blocks specified by user

% Look-up tables ------------------------------------------------------------------
%gratings LUT
numLev=252;

for b=1:B
	if sett(b).wave == 0
		LUT{b}=repmat(round(linspace(0,1,numLev))',1,3); %square wave
	elseif sett(b).wave == 1
		LUT{b}=repmat(abs(abs(linspace(-1,1,numLev)')-1),1,3); %sawtooth wave
	elseif sett(b).wave == 2
		LUT{b}=(repmat(cos(linspace(-pi,pi,numLev))',1,3)+1)/2; %sine wave
	end
	LUT{b}(254,:)=.5;% grey 
	LUT{b}(255,:)=sett(b).fixcol(1,:);% reserve for fixation point
	LUT{b}(256,:)=sett(b).isicol;% isi
	LUT{b}=LUT{b}*sett(b).contrast/100;

	% gratings speed LUT
	if sett(b).gsm
		stimdurfr{b}=hz*sett(b).gs1(1); %stim duration in frames
		vel=sett(b).gs1(1)*sett(b).gs1(2)*pi*2;
		WAVE = cos(linspace(0,vel,stimdurfr{b}+1)+pi);
		WAVE = (WAVE+1)/2;
		m1=numLev*sett(b).gs1(3);
		m2=numLev*sett(b).gs1(4);
		WAVE=(WAVE*(m2-m1)+m1)*sett(b).sdur;
		LS{b} = abs(diff(floor(WAVE)))';
	else
		stimdurfr{b}=hz*sett(b).sdur; %stim duration in frames
		ngs=length(sett(b).gs0);
		LS{b}=zeros(stimdurfr{b},ngs);
		for i=1:ngs, LS{b}(:,i)=diff(floor(linspace(1,numLev*sett(b).gs0(i)*sett(b).sdur,stimdurfr{b}+1))); end
	end

	% fixation point color LUT
		FLS{b}=[];
	if sett(b).fixsz>0
		fixdurfr=hz*sett(b).fixparam(1);
		vel=sett(b).fixparam(1)*sett(b).fixparam(2)*2*pi;
		WAVE = cos(linspace(0,vel,fixdurfr)+pi);
		WAVE = (WAVE+1)/2;
		
		n=size(sett(b).fixcol,1);
		test=Shuffle(1:n);
		for i=1:n
			c1=sett(b).fixcol(test(mod(i-1,n)+1),:);
			c2=sett(b).fixcol(test(mod(i,n)+1),:);
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
				FLS{b}=[FLS{b};temp];
		end
		nFLS{b}=length(FLS{b});
		
		[cx,cy]=meshgrid(-sett(b).fixsz:sett(b).fixsz, -sett(b).fixsz:sett(b).fixsz);
		circle = (cx.^2 + cy.^2 <= (sett(b).fixsz)^2);
	end

	% draw gratings textures ---------------------------------------------------
	angs=sett(b).ang{1}(sett(b).ang{1}>0);
	if sett(b).split, angs=[angs,sett(b).ang{2}(sett(b).ang{2}>0)]; w=w/2; end
	angs=unique(angs);

	[x,y]=meshgrid(linspace(-1,1,w),linspace(-1,1,h));
	[a,~]=cart2pol(x.*pi,y.*pi);
	a=mod((a+pi)./2./pi*sett(b).seg,1).*(numLev-1);
	if sett(b).fixsz>0
		idx1=(h/2-sett(b).fixsz):(h/2+sett(b).fixsz);
		idx2=(w/2-sett(b).fixsz):(w/2+sett(b).fixsz);
		ss=a(idx1,idx2);
		ss(circle)=254;
		a(idx1,idx2)=ss;
	end
	tex{b}(1)=Screen('MakeTexture',S,flip(a),[],[]); %CW
	tex{b}(2)=Screen('MakeTexture',S,a,[],[]); %CCW

	n=max(w,h);
	[x,y]=meshgrid(linspace(-1,1,n),linspace(-1,1,n));
	for i=1:length(angs)
		g=cosd(angs(i))*x+sind(angs(i))*y;
		g=mod((g+sqrt(2))/sqrt(8)*sett(b).seg,1)*(numLev-1);
		if sett(b).fixsz>0
			ss=g(idx1,idx2);
			ss(circle)=254;
			g(idx1,idx2)=ss;
		end
		tex{b}(i+2)=Screen('MakeTexture',S,g(1:h,1:w),[],[]); %Gratings
	end

% prepare test order ------------------------------------------------
	test=sett(b).ang{1};
	if sett(b).split, test=CombVec(test,sett(b).ang{2}); end
	if ~sett(b).gsm, test=CombVec(test,sett(b).gs0); end
	test=test';

	testOrder{b}=[];
	for i=1:sett(b).srep
		idx = 1:size(test,1);
		if sett(b).rand, idx=Shuffle(idx); end
		testOrder{b}=[testOrder{b};test(idx,:)];
	end

	testIDX{b}=testOrder{b};
	for i=1:length(angs)
		testIDX{b}(testOrder{b}==angs(i))=i+2;
	end
	if ~sett(b).gsm, testIDX{b}(:,end)=mod(find(testOrder{b}(:,end)'==sett(b).gs0')+ngs-1,ngs)+1; end
	testIDX{b}=abs(testIDX{b});

% prep text output -------------------------
	testOrder{b}=num2cell(testOrder{b});
	testOrder{b}=cellfun(@num2str,testOrder{b},'uniformoutput',false); 
	testOrder{b}(strcmp(testOrder{b},'0'))="graystim";
	testOrder{b}(strcmp(testOrder{b},'-1'))="CW";
	testOrder{b}(strcmp(testOrder{b},'-2'))="CCW";
	if sett(b).split, testOrder{b}(:,1)=strcat(testOrder{b}(:,1),'_',testOrder{b}(:,2)); testOrder{b}(:,2)=[]; end
	if ~sett(b).gsm, testOrder{b}(:,1)=strcat(testOrder{b}(:,1),'__',testOrder{b}(:,2)); testOrder{b}(:,2)=[]; end
	if sett(b).rev, testOrder{b}=[testOrder{b},strcat(testOrder{b},'_reversal')]; end
	if sett(b).isidur>0, testOrder{b}=[repmat({"ISI"},length(testOrder{b}),1),testOrder{b}]; end
	testOrder{b}=reshape(testOrder{b}',[],1);
	%testOrder{b}=[testOrder{b};{"ISI"}];

	abstime{b}=zeros(length(testOrder{b}),1);
end

%% ?!? ------------------------------------------------------------------
% clearvars x y a g circle
%% hold
HideCursor
while(1), if KbStrokeWait, break; end, end
bcm2835_gpio_set(ttl_pin);

%% run
flag=true;
TS = clock;
ts=GetSecs;
for b=1:B
 j=1; k=1; l=1; m=1;
	Screen('LoadNormalizedGammaTable',S,LUT{b},2);
	for i=1:size(testIDX{b},1)
	% ISI ---------------------------------------------------------------------
	if sett(b).isien
		Screen('FillRect',S,255);
		Screen('Flip',S,0,1,1,0);
		t0=GetSecs; t1=t0;
		abstime{b}(j)=t0-ts;
		while(t1-t0<sett(b).isidur) && flag
			t1=GetSecs;
			if KbCheck, flag=false; break; end
		end, j=j+1;
	end
	% stim ------------------------------------------------------------------
		Screen('FillRect',S,253);
		for ii=1:1+sett(b).split
			ang=testIDX{b}(i,ii);
			if ang~=0, Screen('DrawTexture',S,tex{b}(ang),[0 0 w h],[(ii-1)*w 0 ii*w h],[],0); end
		end
		if ~sett(b).gsm, l=testIDX{b}(i,end); end
		t0=GetSecs; t1=t0;
		abstime{b}(j)=t0-ts;
		while(t1-t0<sett(b).sdur) && flag
	##    for k=1:stimdurfr{b}
			shift=LS{b}(k,l);
			LUT{b}=LUT{b}([1+shift:numLev,1:shift,numLev+1:end],:);
      if sett(b).fixsz>0
			col=FLS{b}(m,:);
			LUT{b}(255,:)=col;
			m=mod(m,nFLS{b})+1;
      end
			Screen('LoadNormalizedGammaTable',S,LUT{b},2);
			Screen('Flip',S,0,1,1,0);

			t1=GetSecs; k=mod(k,stimdurfr{b})+1;
			if KbCheck, flag=false; break; end
		end, j=j+1; 
	% reversal ------------------------------------------------------------
		if sett(b).rev
		t0=GetSecs; t1=t0;
		abstime{b}(j)=t0-ts;
		while(t1-t0<sett(b).sdur) && flag
			shift=LS{b}(k,l);
			LUT{b}=LUT{b}([numLev-shift+1:numLev,1:numLev-shift,numLev+1:end],:);
      if sett(b).fixsz
			col=FLS{b}(m,:);
			LUT{b}(255,:)=col;
			m=mod(m,nFLS{b})+1;
      end
			Screen('LoadNormalizedGammaTable',S,LUT{b},2);
			Screen('Flip',S,0,1,1,0);

			t1=GetSecs; k=mod(k,stimdurfr{b})+1;
			if KbCheck, flag=false; break; end
		end, j=j+1;
		end
	% check for user interuption ----
		if ~flag, break; end
	end
end
% last ISI ---------------------
%    Screen('FillRect',S,255);
%    Screen('Flip',S);
%    t0=GetSecs; t1=t0;
%    abstime(j)=t0-ts;
%    while(t1-t0<sett(b).isidur) && flag
%        t1=GetSecs;
%        if KbCheck, flag=false; break; end
%    end

%% wrap -------------------------------------------------------------------------------------------------
bcm2835_gpio_clr(ttl_pin);
bcm2835_close();
ShowCursor
RestoreCluts;
sca;
%write stim log ---------------------------------------------------------------
     i=1;
     pout=[pwd,'/logs/'];
     if ~exist(pout,'dir'); mkdir(pout); end
     filename=[pout,fout,'.log'];
     while exist(filename,'file')==2
         disp([filename,' already exists'])
         filename=[pout,fout,'(',num2str(i),').log'];
         i=i+1;
     end
     disp(['saving as: ',filename])
     fid = fopen(filename,'w');
	 for b=1:B
     for i=1:length(abstime{b})
       fprintf(fid,'%s\t%s\n',datestr(datenum(TS)+abstime{b}(i)/86400,'mm/dd/yyyy	HH:MM:SS.FFF'),testOrder{b}{i});  
     end 
	 end
     fclose(fid);
%%     copyfile(filename,'path to fs1');
%%     disp(['copied ',fout,' to ','path to fs1']);

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





