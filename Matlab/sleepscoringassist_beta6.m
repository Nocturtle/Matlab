classdef sleepscoringassist_beta6 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        Panel                           matlab.ui.container.Panel
        GridLayout                      matlab.ui.container.GridLayout
        status                          matlab.ui.control.TextArea
        TabGroup                        matlab.ui.container.TabGroup
        importTab                       matlab.ui.container.Tab
        importgrid                      matlab.ui.container.GridLayout
        importPan                       matlab.ui.container.Panel
        addSubj                         matlab.ui.control.Button
        ImportDone                      matlab.ui.control.Button
        AnalysisTab                     matlab.ui.container.Tab
        analysisgrid                    matlab.ui.container.GridLayout
        AnalysisTabGroup                matlab.ui.container.TabGroup
        SettingsTab                     matlab.ui.container.Tab
        settingsgrid                    matlab.ui.container.GridLayout
        SaveButton                      matlab.ui.control.Button
        LoadButton                      matlab.ui.control.Button
        epochfeatures                   matlab.ui.container.Panel
        epochfeaturesgrid               matlab.ui.container.GridLayout
        bandsperHzEditFieldLabel        matlab.ui.control.Label
        bandsperHz                      matlab.ui.control.NumericEditField
        includeZC                       matlab.ui.control.CheckBox
        minimumexplainedLabel           matlab.ui.control.Label
        minimumexplained                matlab.ui.control.NumericEditField
        EEGFFTrangeHzEditFieldLabel     matlab.ui.control.Label
        eegpsdL                         matlab.ui.control.NumericEditField
        EMGFFTrangeHzEditFieldLabel     matlab.ui.control.Label
        emgpsdL                         matlab.ui.control.NumericEditField
        toeegEditFieldLabel             matlab.ui.control.Label
        eegpsdH                         matlab.ui.control.NumericEditField
        toemgEditFieldLabel             matlab.ui.control.Label
        emgpsdH                         matlab.ui.control.NumericEditField
        outlierremovalmethodDropDownLabel  matlab.ui.control.Label
        outlierremovalmethodDropDown    matlab.ui.control.DropDown
        PCArowsDropDownLabel            matlab.ui.control.Label
        PCArowsDropDown                 matlab.ui.control.DropDown
        epochlengthsecEditFieldLabel    matlab.ui.control.Label
        epochlength                     matlab.ui.control.NumericEditField
        findandreplace                  matlab.ui.container.Panel
        findandreplacegrid              matlab.ui.container.GridLayout
        rules                           matlab.ui.control.Table
        clusters                        matlab.ui.container.Panel
        clustersgrid                    matlab.ui.container.GridLayout
        pdistmethodDropDownLabel        matlab.ui.control.Label
        pdistmethodDropDown             matlab.ui.control.DropDown
        linkagemethodDropDownLabel      matlab.ui.control.Label
        linkagemethodDropDown           matlab.ui.control.DropDown
        clusterfeatures                 matlab.ui.container.Panel
        clusterfeaturesgrid             matlab.ui.container.GridLayout
        clustersfeaturestable           matlab.ui.control.Table
        StateLabelsPanel                matlab.ui.container.Panel
        statelabelsgrid                 matlab.ui.container.GridLayout
        statelabelstable                matlab.ui.control.Table
        autoscoringtruthtablePanel      matlab.ui.container.Panel
        truthtablegrid                  matlab.ui.container.GridLayout
        truthtable                      matlab.ui.control.Table
        ScoreTab                        matlab.ui.container.Tab
        scoregrid                       matlab.ui.container.GridLayout
        Features                        matlab.ui.control.UIAxes
        runanalysisButton               matlab.ui.control.Button
        ApplyFindandReplaceRulesButton  matlab.ui.control.Button
        clusterdetails                  matlab.ui.control.Table
        BatchModeCheckBox               matlab.ui.control.CheckBox
        redoclustersButton              matlab.ui.control.Button
        previewpanel                    matlab.ui.container.Panel
        previewgrid                     matlab.ui.container.GridLayout
        rawdatapan                      matlab.ui.container.Panel
        rawdatagrid                     matlab.ui.container.GridLayout
        WindowepochsEditFieldLabel      matlab.ui.control.Label
        EpochWindow                     matlab.ui.control.NumericEditField
        EpochNoSliderLabel              matlab.ui.control.Label
        EpochNoSlider                   matlab.ui.control.Slider
        scoreplot                       matlab.ui.control.UIAxes
        EpochNo                         matlab.ui.control.NumericEditField
        EpochNoTimestamp                matlab.ui.control.EditField
        windowL                         matlab.ui.control.Button
        windowR                         matlab.ui.control.Button
        manualeditDropDownLabel         matlab.ui.control.Label
        manualeditDropDown              matlab.ui.control.DropDown
        manualeditwindowEditFieldLabel  matlab.ui.control.Label
        manualeditwindowEditField       matlab.ui.control.NumericEditField
        IDDropDownLabel                 matlab.ui.control.Label
        ID                              matlab.ui.control.DropDown
        numberofclustersLabel           matlab.ui.control.Label
        numclusters                     matlab.ui.control.NumericEditField
        highlightepochsinmanualeditwindowCheckBox  matlab.ui.control.CheckBox
        changeshow                      matlab.ui.control.DropDown
        showLabel                       matlab.ui.control.Label
        disable3dplotButton             matlab.ui.control.StateButton
        onlyplotepochsinpreviewwindowCheckBox  matlab.ui.control.CheckBox
        ExportTab                       matlab.ui.container.Tab
        exportgrid                      matlab.ui.container.GridLayout
        ExportTabGroup                  matlab.ui.container.TabGroup
        resultsfilesTab                 matlab.ui.container.Tab
        resultsfilegrid                 matlab.ui.container.GridLayout
        ExportTable                     matlab.ui.control.Table
        ExportDone                      matlab.ui.control.Button
        CompareCheckBox                 matlab.ui.control.CheckBox
        outputfilesuffixEditField       matlab.ui.control.EditField
        outputfilesuffixLabel           matlab.ui.control.Label
        rosettaStone                    matlab.ui.control.Table
        WhattowritetotheresultsfileLabel  matlab.ui.control.Label
        FFTavgstateTab                  matlab.ui.container.Tab
        FFTavgstateGrid                 matlab.ui.container.GridLayout
        FFTavgstateTabGroup             matlab.ui.container.TabGroup
        Tab                             matlab.ui.container.Tab
        Tab2                            matlab.ui.container.Tab
        WIPTab                          matlab.ui.container.Tab
        plaintextButton                 matlab.ui.control.Button
    end

    
    properties (Access=private)
        subjs=[]; % handle to each subjects panel
        axhandles=[]; % handles to axes for plotting raw data
        highlight=cell(10,1); % handle to scatter3 plot for highlighting features in the preview window
        updateExportList=false; % Description
        outthresh=[]; % Description
        scoreplothandle=[]; % Description
        statelabels={'?','W','NR','R'};
        lookup_zdb= {'Sleep-Wake','Sleep-SWS','Sleep-Paradoxical','Sleep-REM','Sleep-Artifact','Sleep-Unknown',' '};
        lookup_raf =[1 3 4 2 7 0 0];
        lookup_key  = {'W','NR','P','R','X','?','NaN'};
        mycolors=[];%colormap(app.Features,jet(4));
        
        featuresrc={'default'}; % Description
        settings={'[epochs'' features]','[clustering]','[clusters'' features]','[f&r rules]','[state labels]'};
%         settingshandles=[app.epochfeaturesgrid.Children,]; % Description
        manualeditwindow=[]; % Description
    end
    
    methods (Access=private)
        
        function updatestatus(app,newstring) %tell the user what's going on
            app.status.Value=[{newstring};app.status.Value];
            drawnow
        end
        
        function browsepath(~,~,~,path) %get the user to tell you where the data is
            p=uigetdir(pwd);
            path.Value=p;
        end
        
        function filename = checkfilename(app,file)
            ext=strsplit(file,'.');
            temp=strjoin(ext(1:end-1),'.');
            ext=ext{end};
            filename=[temp,'.',ext];
            i=1;
            while exist(filename,'file')==2
                filename=[temp,'(',num2str(i),').',ext];
                i=i+1;
            end
        end
        
        function rmSubj(app,src,~) %remove a subject's panel from the app
            h=src.Parent;
            todelete=allchild(h);
            for ii=1:length(todelete)
                delete(todelete(ii));
            end
            delete(h);
            idx=isvalid(app.subjs);
            for ii=1:length(idx)
                if ~idx(ii), app.subjs(ii)=[]; break
                else
                    app.subjs(ii).Position=app.subjs(ii).Position - [0 201 0 0];
                end
            end
        end
        
        function addfiles(app,src,~) %add files to a subject & store some inportant info
            h=src.Parent;
            eeg=str2double(strsplit(h.Children(6).Value,' '));%which signals are eeg
            emg=h.Children(4).Value;
            if ~isempty(emg), emg=str2double(strsplit(emg,' ')); end%which signals are emg
            h=h.Children(1);
            userdata=h.UserData;
            if ~isfield(userdata,'sigparams'), userdata.sigparams={}; end
            if ~isfield(userdata,'samples_per_record'), userdata.samples_per_record={}; end
            
            [files,path]=uigetfile({'*.edf;*.kcd'},"MultiSelect","on");
            if ~iscell(files), files={files}; end
            if(files{1})
                
                %initialize variable that will go into table data
                path={path};
                    stuff=dir(path{1});
                path=repmat(path,1,length(files));
                starttime=cell(1,length(files)); %start time of file
                resultfiles=repmat({'...'},1,length(files));
                dur=cell(1,length(files));%duration
                fs=cell(1,length(files));%sampling frequency
                numsig=cell(1,length(files));%number of signals
                txEn=num2cell(false(1,length(files)));%whether or not this file contains treatment data (sleep dep, drug injections etc...)
                txST=repmat({'MM-dd-yy HH:mm:ss'},1,length(files));%starttime of treatment
                txDur=repmat({'00:00:00:00'},1,length(files));%duration of treatment
                
                %read the header of each file
                for i=1:length(files)
                    if(contains(files{i},'.edf'))
                        [header, sheader]=blockEdfLoad([path{i},files{i}]); %to do: replace this function
                        sfs=cat(1,sheader.samples_in_record)./header.data_record_duration;
                        ns=header.num_signals;
                        starttime{i}=datetime([header.recording_startdate,header.recording_starttime],'InputFormat','dd.MM.yyHH.mm.ss');
                        starttime{i}.Format='MM-dd-yy HH:mm:ss';
                        starttime{i}=char(starttime{i});
                        ds=seconds(header.data_record_duration*header.num_data_records);
                        ds.Format='hh:mm:ss';
                        dur{i}=char(ds);
                        fs{i}=num2str(sfs');%max(sfs);
                        numsig{i}=ns;
                        userdata.sigparams=[userdata.sigparams,{[cat(1,sheader.digital_min),cat(1,sheader.digital_max),cat(1,sheader.physical_min),cat(1,sheader.physical_max)]}];
                        userdata.samples_per_record=[userdata.samples_per_record,{cat(1,sheader.samples_in_record)}];
                    elseif(contains(files{i},'.kcd'))
                        kcdSize=[10     ,           14,     22,       1,       1,       1,     10,     6];
                        kcdForm={'uint8','uint8=>char','uint8','uint16','uint32','double','uint8','uint16'};
                        data=cell(1,8);
                        fid=fopen([path{i},files{i}]);
                        for ii=1:8
                            data{ii}=fread(fid,kcdSize(ii),kcdForm{ii});
                        end
                        fclose(fid);
                        starttime{i}=datetime(data{8}(1),data{8}(2),data{8}(3),data{8}(4),data{8}(5),data{8}(6));
                        starttime{i}.Format='MM-dd-yy HH:mm:ss';
                        starttime{i}=char(starttime{i});
                        ds=seconds(data{5}/data{6});
                        ds.Format='hh:mm:ss';
                        dur{i}=char(ds);
                        fs{i}=num2str(repmat(floor(data{6}),1,data{4}));
                        numsig{i}=double(data{4});
                        userdata.sigparams=[userdata.sigparams,{[ones(data{4},1).*-32767,ones(data{4},1).*32768,ones(data{4},1).*-10,zeros(data{4},1)]}];
                        userdata.samples_per_record=[userdata.samples_per_record,{ones(data{4},1)}];
                    elseif(contains(files{i},'.rhd'))
                        %to do: add support for rhd files
                    else, app.updatestatus(['format not recognized: ',files{i}])
                    end
                    %look for raf/zdb
                    for ii=1:length(stuff)
                        if (contains(stuff(ii).name,'.raf')||contains(stuff(ii).name,'.zdb')) && contains(stuff(ii).name,files{i}(1:end-4))
                            resultfiles{i}=[stuff(ii).folder,'\',stuff(ii).name];
                        end
                    end
                end
                
                h.Data=[h.Data;[path',files',starttime',dur',fs',numsig',txEn',txST',txDur',resultfiles']];
                
                %sort all files by starttime
                [~,idx]=sort(datetime(h.Data(:,3),'InputFormat','MM-dd-yy HH:mm:ss'));
                h.Data=h.Data(idx,:);
                userdata.sigparams=userdata.sigparams(idx);
                userdata.samples_per_record=userdata.samples_per_record(idx);
                
                %check to make sure selected eeg/emg fs all match
                fs=h.Data(:,5);
%                 selected=[];
%                 for i=1:length(fs)
%                     test=strsplit(fs{i},' ');
%                     selected=[selected,test([eeg,emg])];
%                 end
%                 if length(unique(selected))>1, app.updatestatus('warning: not all fs for specified eeg/emg match. make sure to fix this before moving on'); end
                
                %save extra signal parameters
                h.UserData=userdata;
                app.updateExportList = true;
            end
        end
        
        function rmfiles(app,src,~) %remove files from a subject
            try
                h=src.Parent.Children(1);
                userdata=h.UserData;
                userdata.sigparams(userdata.selected(:,1))=[];
                userdata.samples_per_record(userdata.selected(:,1))=[];
                h.Data(userdata.selected(:,1),:)=[];
                h.UserData=userdata;
                app.updateExportList = true;
            catch
                app.updatestatus('select a different column')
            end
        end
        
        function trackselectedfiles(~,src,event) %
            h=src.Parent.Children(1);
            userdata=h.UserData;
            userdata.selected=event.Indices;
            h.UserData=userdata;
        end
        
        function checkTXinput(~,src,event) %
            h=src.Parent.Children(1);
            if event.Indices(2)==7%TX checkbox
                if event.NewData
                    h.ColumnEditable=[false,false,false,false,false,false,true,true,true,true];
                    h.Data(event.Indices(1),8:9)=h.Data(event.Indices(1),3:4);
                elseif ~event.NewData
                    h.ColumnEditable=[false,false,false,false,false,false,true,false,false,true];
                    h.Data(event.Indices(1),8:9)=[{'MM-dd-yy HH:mm:ss'},{'00:00:00:00'}];
                end
            elseif event.Indices(2)==10%raf
                if strcmp(h.Data{event.Indices(1),10},'...')
                    file=h.Data{event.Indices(1),2};
                    [file,path]=uigetfile('*.raf',['find results file for ',file]);
                    if file~=0
                    h.Data{event.Indices(1),10}=[path,file];
                    end
                end
            end
        end
        
        function checkSIGinput(app,src,event) %
            h=src.Parent.Children(1);
            if ~isempty(h.Data)
            test=strsplit(event.Value,',');
            test=cellfun(@str2double,test);
            if sum(test>h.Data{1,6})>0
                app.updatestatus('error, specified eeg/emg channels must be less than the number of signals in the file')
                src.Value=event.PreviousValue;
            end
            end
        end
        
        function checkDSinput(app,src,event) %
            if event.Value<1
                app.updatestatus('error, downsampling decimation factor must be greater than 0')
                src.Value=event.PreviousValue;
            end
        end
        
        function results=findtimestamp(app,id,value) %find datetime stamp from epoch
%             id=app.ID.Value;
            h=app.subjs(id).Children(1).Data;%handle to this subjs data summary
            if ~isempty(h)
                eL=app.epochlength.Value;
                de=zeros(size(h,1),1);%duration in epochs
                for i=1:size(h,1)
                    de(i)=floor(seconds(duration(h{i,4}))/eL);%,'inputformat','dd:hh:mm:ss'
                end
                de=[0;cumsum(de)];
                val=find(value>=de,1,'last');
                TS=datetime(h(val,3),'InputFormat','MM-dd-yy HH:mm:ss');
                results=datestr(TS+seconds((value-1-de(val))*eL),'mm-dd-yy HH:MM:ss');
            else
                results = 'MM-dd-yy HH:mm:ss';
            end
        end
        
        function updatefeatures(app) %scatter plot features
            id=app.ID.Value;
            userdata = app.subjs(id).UserData;
            if isfield(userdata,'feat') && ~app.disable3dplotButton.Value
                f=(userdata.feat);
                ne=size(f,1);%num epochs
                s=ones(ne,1);
                if isfield(userdata,'clust'), C=userdata.clust;
                else, C=s;
                end
                    if strcmp(app.changeshow.Value,'imported score') && isfield(userdata,'scoreI'), s=userdata.scoreI+1;
                    elseif strcmp(app.changeshow.Value,'score') && isfield(userdata,'score'), s=userdata.score+1;
                    end
                if app.onlyplotepochsinpreviewwindowCheckBox.Value
                    ss = app.EpochNo.Value:app.EpochNo.Value+app.EpochWindow.Value;
                    f=f(ss,:);
                    s=s(ss);
                    C=C(ss);
                end
                
                cla(app.Features); %clear the plot
                
                if strcmp(app.changeshow.Value,'clusters')
                        scatter3(app.Features,f(:,1),f(:,2),f(:,3),2,C,'filled','MarkerEdgeColor','none');
                        C(C==0)=inf;
                        colormap(app.Features,jet(length(unique(C))));
                        c=colorbar(app.Features);
                        caxis(app.Features,[min(C) max(C)])
                        c.Label.String = 'clusters';
                else
                        colorbar(app.Features,'off');
                    
                    %scatter plot features
                    list = unique(s)';
                    hold(app.Features,'on');
                    p=[];
                    for i=list
                        p=[p,scatter3(app.Features,f(s==i,1),f(s==i,2),f(s==i,3),2,app.mycolors(i,:),'filled','DisplayName',app.statelabels{i},'MarkerEdgeColor','none')]; 
                    end
                    legend(p,'location','northeast')%app.Features,
                end
                
                pbaspect(app.Features,[1 1 1])
                grid(app.Features,'on')
                try
                app.Features.XLim=[min(userdata.feat(:,1)) max(userdata.feat(:,1))];
                app.Features.YLim=[min(userdata.feat(:,2)) max(userdata.feat(:,2))];
                app.Features.ZLim=[min(userdata.feat(:,3)) max(userdata.feat(:,3))];
                catch ME
                end
                
                hold(app.Features,'off');
            else
                cla(app.Features);
            end
        end
        
        function updatescoreplot(app)
                id=app.ID.Value;
            eL=app.epochlength.Value;
            if ~isempty(id)
                userdata=app.subjs(id).UserData;
                if ~isempty(app.subjs(id).Children(1).Data)
                    dur=seconds(duration(app.subjs(id).Children(1).Data(:,4)));%duration in seconds
                    ne=floor(sum(dur)/eL);
                    s=zeros(ne,1);
                    cla(app.scoreplot);
                    hold(app.scoreplot,'on');
                    if strcmp(app.changeshow.Value,'clusters') && isfield(userdata,'clust')
                        if isfield(userdata,'clust')
                            c=userdata.clust-1;
                            C=unique(c);
                            nC=length(C);
                            for i=1:nC, x=find(c==(i-1)); scatter(app.scoreplot,x,ones(length(x),1).*(i-1),1); end
                            colormap(app.scoreplot,'jet')
%                             app.scoreplot.XLim=[0 length(s)];
                            app.scoreplot.YLim=[-1 nC];
                        end
                    else
                        if strcmp(app.changeshow.Value,'imported score') && isfield(userdata,'scoreI'), s=userdata.scoreI;
                        elseif strcmp(app.changeshow.Value,'score') && isfield(userdata,'score'), s=userdata.score;
                        end
                        for i=1:length(app.statelabels), x=find(s==(i-1)); scatter(app.scoreplot,x,ones(length(x),1).*(i-1),1,app.mycolors(i,:),'.',"DisplayName",app.statelabels{i}); end
%                         app.scoreplot.XLim=[0 length(s)];
                        app.scoreplot.YLim=[-1 length(app.statelabels)];
                    end
                end
            end
        end
        
        function updatestatelabels(app,new)
        if size(new,1)>1, new=new'; end
            app.statelabels=new;
            temp=colormap(app.Features,jet(length(new)));
            temp(1,:)=[.5 .5 .5];
            app.mycolors=temp*.75;
            app.truthtable.ColumnFormat(1)={new};
            app.clusterdetails.ColumnFormat{3}=new;
            app.manualeditDropDown.Items=new;
            idx=ones(length(new),1).*7;
            for i=1:length(new)
                n=find(strcmp(new(i),app.lookup_key));
                if ~isempty(n), idx(i)=n; end
            end
            app.rosettaStone.Data=[new',num2cell(app.lookup_raf(idx))',app.lookup_zdb(idx)'];
        end
        
        function displaystatedistribution(app,s,name)
        ne=length(s);
                    n=length(app.statelabels);
                    summary=zeros(1,n);
                    for ii=1:n, summary(ii)=(mean(sum(s==ii-1),2)/ne*100); end
                    app.updatestatus(sprintf([name,':',strjoin(strcat('\t',app.statelabels),':%0.2f%%'),':%0.2f%%\n'],summary))%app.subjs(id).Children(8).Value    ':\t?:%0.2f%%\tW:%0.2f%%\tNR: %0.2f%%\tR:%0.2f%%'
            
        end
        
        function psd = mypmtm(~,xin,fs,bins_per_hz)
            [m, n] = size(xin);%m=length of signal, n=num signals
            k=fs*bins_per_hz;
            nfft = 2^nextpow2(m+k-1);%- Length for power-of-two fft.
            [E,V] = dpss(m,4);
            g=gpuDevice;
            s=nfft*8*length(V)*2*2*2;%how many bytes will be needed for ea. signal
            ne=floor(g.AvailableMemory/s);%number of signals that can be processed at once with the available gpu memory
            indx=[0:ne:n,n];%number of iterations that will be necessary
            
            psd=zeros(bins_per_hz*100,n);%initialize output
            
            for i=1:length(indx)-1
                x=gpuArray(xin(:,1+indx(i):indx(i+1)));
        
                x=x.*permute(E,[1 3 2]); %apply dpss windows
        
                %------- Premultiply data.
                ww = exp(-1i .* 2 .* pi ./ k) .^ ((( (-m+1):max(k-1,m-1) )' .^ 2) ./ 2);   % <----- Chirp filter is 1./ww
        
                %------- Fast convolution via FFT.
                x = fft(  x .* ww(m+(0:(m-1))'), nfft );
                fv = fft( 1 ./ ww(1:(k-1+m)), nfft );   % <----- Chirp filter.
                x  = ifft( x .* fv );
        
                %------- Final multiply.
                x = abs(x( m:(m+k-1), : , :) .* ww( m:(m+k-1) )).^2;
        
                x=x.*permute(V,[2 3 1])/length(V);%'eigen' method of estimating average
        
                x=sum(x,3);
        
                x=x(2:end/2+1,:)./fs;
        
                psd(:,1+indx(i):indx(i+1))=gather(x(1:bins_per_hz*100,:));
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.addSubjButtonPushed(app);
%             app.rules.Data=[{'W>?>W'},{'NR>?>NR'},{'R>?>R'},{'R>W>R'},{'R>NR>R'},{'NR>W>R'},{'W>R'};... %,{'W>NR>R'}
%                             {'W>W>W'},{'NR>NR>NR'},{'R>R>R'},{'R>R>R'},{'R>R>R'},{'NR>R>R'},{'W>W'}];   %,{'W>NR>W'}
            app.rules.ColumnFormat={'char','char','logical','logical'};
            app.rules.Data=[[{'W>?>W'};{'NR>?>NR'};{'R>?>R'};{'R>W>R'};{'R>NR>R'};{'NR>W>R'};{'W>R'}],...
                            [{'W>W>W'};{'NR>NR>NR'};{'R>R>R'};{'R>R>R'};{'R>R>R'};{'NR>R>R'};{'W>W'}],...
                            num2cell(false(7,1)),num2cell(false(7,1))];
                        
            app.statelabelstable.Data=[app.statelabels',num2cell(false(4,1)),num2cell(false(4,1))];
            app.statelabelstable.ColumnFormat={'char','logical','logical'};
            
            app.clustersfeaturestable.Data={'delta','EEG Averaged','1:4','median',false,false;...
                                            'theta','EEG Averaged','6:9','median',false,false;...
                                            'emg','EMG Averaged','80:100','median',false,false;...
                                            'zc','EEG Averaged','ZC','midrange',false,false};
            app.clustersfeaturestable.ColumnFormat={'char',{'test'},'char','char','logical','logical'};
            
            app.truthtable.ColumnName={'State','delta','theta','emg','zc'};
            app.truthtable.ColumnWidth={'auto',50,50,50,50};
            idx=false(16,4);
            for i=1:4, idx(reshape([2^i/2+1:2^i]'+([0:2^(i):(2^4-1)]),1,[]),5-i)=true; end
            temp={'low','high'};
            app.truthtable.Data=[{'NR';'?';'?';'W';'R';'R';'?';'W';'NR';'?';'?';'W';'NR';'?';'?';'W'},temp(idx+1)];
            app.truthtable.ColumnEditable=[true,false(1,4)];
            
            app.Features.ZLabel.String='PC3';
            axis(app.scoreplot,'off');
            
            app.updatestatelabels(app.statelabels);
            
            app.outlierremovalmethodDropDown.ItemsData=str2double(app.outlierremovalmethodDropDown.ItemsData);
            app.PCArowsDropDown.ItemsData=str2double(app.PCArowsDropDown.ItemsData);
            app.outlierremovalmethodDropDown.Value=0;
            app.PCArowsDropDown.Value=1;
            
%             try 
%                 opengl software
%             catch ME
%                 
%             end
        end

        % Button pushed function: addSubj
        function addSubjButtonPushed(app, event)
            for i=1:length(app.subjs)
                app.subjs(i).Position=app.subjs(i).Position + [0 201 0 0];
            end
            app.subjs=[app.subjs,uipanel('Parent',app.importPan,'scrollable','on',...
                'Position',[1 60 1266 201])];
            
            uibutton(app.subjs(end),'text','-','ButtonPushedFcn',@app.rmSubj,...
                'Tooltip','remove subject','Position',[1 25 25 100]);
            uibutton(app.subjs(end),'text','rmv','ButtonPushedFcn',@app.rmfiles,...
                'Tooltip','remove files','Position',[25 25 75 50]);
            uibutton(app.subjs(end),'text','add','ButtonPushedFcn',@app.addfiles,...
                'Tooltip','add files','Position',[25 75 75 50]);
            
            uilabel(app.subjs(end),'text','ID',...
                'Position',[1 155 25 25]);
            uieditfield(app.subjs(end),'Value',['default',num2str(length(app.subjs))],...
                'Tooltip','subject ID','Position',[25 150 100 40]);
            
            uilabel(app.subjs(end),'text','eeg signal',...
                'Position',[150 155 75 25]);
            uieditfield(app.subjs(end),'Value','1 2','ValueChangedFcn',@app.checkSIGinput,...
                'Tooltip',{'specify which signals are',' EEG (separate by spaces)'},'Position',[225 150 100 40]);
            
            uilabel(app.subjs(end),'text','emg signal',...
                'Position',[350 155 75 25]);
            uieditfield(app.subjs(end),'Value','3','ValueChangedFcn',@app.checkSIGinput,...
                'Tooltip',{'specify which signals are',' EMG (separate by spaces)'},'Position',[425 150 100 40]);
            
            uilabel(app.subjs(end),'text','downsample',...
                'Position',[550 155 75 25]);
            uieditfield(app.subjs(end),'numeric','Value',1,'ValueChangedFcn',@app.checkDSinput,...
                'Tooltip','downsample decimation factor (use only every ''n'' samples)','Position',[625 150 100 40]);
            
            uitable(app.subjs(end),'CellSelectionCallback',@app.trackselectedfiles,'CellEditCallback',@app.checkTXinput,...
                'ColumnEditable',[false,false,false,false,false,false,true,false,false,true],...
                'ColumnName',{'path','file name','start time','duration','fs','num sig','Tx','Tx start time','Tx duration','results file (.raf or .zbd)'},...
                'ColumnFormat',{'char','char','char','char','char','numeric','logical','char','char','char'},...
                'ColumnWidth',{40 'auto' 150 100 100 50 50 150 100 'auto'},...
                'Position',[101 1 1160 140]);
        end

        % Button pushed function: ImportDone
        function ImportDonePushed(app, event)
            app.TabGroup.SelectedTab=app.AnalysisTab;
            app.TabGroupSelectionChanged;
        end

        % Selection change function: TabGroup
        function TabGroupSelectionChanged(app, event)
            selectedTab=app.TabGroup.SelectedTab;
            subjIDs=cell(1,length(app.subjs));
            for i=1:length(app.subjs)
                subjIDs{i}=app.subjs(i).Children(8).Value;
            end
            
            if selectedTab == app.AnalysisTab
                app.ID.Items=subjIDs;
                app.ID.ItemsData=1:length(subjIDs);
                app.IDValueChanged;
              
            elseif selectedTab == app.ExportTab
                if app.updateExportList
                paths=[];
                datafiles=[];
                resultfiles=[];
                for i=1:length(app.subjs)
                    if ~isempty(app.subjs(i).Children(1).Data)
                        paths=[paths;app.subjs(i).Children(1).Data(:,1)];
                        datafiles=[datafiles;app.subjs(i).Children(1).Data(:,2)];
                        resultfiles=[resultfiles;app.subjs(i).Children(1).Data(:,10)];
                    end
                end
                app.ExportTable.Data=[num2cell(true(length(datafiles),1)),[paths,datafiles],resultfiles];
                app.updateExportList = false;
                end
                
                tg=app.FFTavgstateTabGroup;
                if ~isempty(tg.Children)
                    for i=1:length(tg.Children)
                        delete(tg.Children(end));
                    end
                end
                    n=length(subjIDs);
                    m=length(app.statelabels);
                    
%                     for i=1:n
%                         h=app.subjs(i);
%                         if isfield(h.UserData,'psd')
%                            eegidx=str2double(strsplit(h.Children(6).Value,' '));%which signals are eeg
%                            neeg=length(eegidx);
%                            t=uitab(tg,'title',subjIDs{i});
%                            g=uigridlayout(t,'padding',[0 0 0 0],"ColumnWidth",repmat({'1x'},1,m),"RowHeight",{'1x'});
%                            lim=max(nanmean(nanmean(h.UserData.psd(:,1:end-1,1:neeg),1),3));
%                            for j=1:m
%                                ax=uiaxes(g);
%                                ss=h.UserData.score==(j-1);
%                                b=app.bandsperHz.Value;
%                                plot(ax,1/b:1/b:100,nanmean(nanmean(h.UserData.psd(ss,1:end-1,1:neeg),1),3))%h.UserData.fs/2
%                                set(ax,'tickdir','out','ylim',[0 lim],'xlim',[0 30])
%                                 ax.Title.String=app.statelabels{j};
%                                 ax.XLabel.String='Hz';
%                                 ax.YLabel.String='power';
%                            end
%                         end
%                     end
            end
        end

        % Cell selection callback: ExportTable
        function ExportTableCellSelection(app, event)
            indices=event.Indices;
            if indices(2)==3%strcmp(app.ExportTable.Data{indices(1),3},'...')
                file=strsplit(app.ExportTable.Data{indices(1),1},'\');
                file=file{end};
                [file,path]=uigetfile({'*.raf';'*.zdb';'*.*'},['find results file for ',file]);
                if file~=0
                app.ExportTable.Data{indices(1),3}=[path,file];
                end
            end
        end

        % Value changed function: ID
        function IDValueChanged(app, event)
            id=app.ID.Value;
            eL=app.epochlength.Value;
            if ~isempty(id)
                h=app.subjs(id);
                if ~isempty(h.Children(1).Data)
                    eeg=str2double(strsplit(h.Children(6).Value,' '));%which signals are eeg
                    neeg=length(eeg);
                    emg=h.Children(4).Value;
                    if ~isempty(emg), emg=str2double(strsplit(emg,' ')); end%which signals are emg
                    nemg=length(emg);
                    
                        %update epoch slider/indicator/timestamp
                        h=h.Children(1).Data;
                        dur=seconds(duration(h(:,4)));%duration in seconds
                        numEpochs=floor(sum(dur)/eL);
                        app.EpochNoSlider.Limits=[1 numEpochs];
                        app.EpochNoSlider.MajorTicks=1:3600/eL:numEpochs;
                        temp=repmat({''},1,length(1:3600/eL:numEpochs));
                        temp{1}='1';
                        temp{end}=num2str(numEpochs);
                        app.EpochNoSlider.MajorTickLabels=temp;
                        app.scoreplot.XLim=[0 numEpochs];
                        
                        if app.EpochNo.Value > numEpochs
                            app.EpochNo.Value=1;
                            app.EpochNoSlider.Value=1;
                            app.EpochNoTimestamp.Value=app.findtimestamp(id,1);
                        end
                        
                        %update raw data axes
                        ns=neeg+nemg;
                        app.rawdatagrid.RowHeight=[repmat({'2x'},1,ns),{'1x'}];
                        todelete=allchild(app.rawdatagrid);
                        for i=1:length(todelete)
                            cla(todelete(i));
                            delete(todelete(i));
                        end
                        app.axhandles=gobjects(ns+1,1);
                        app.manualeditwindow=gobjects(ns+1,1);
                        app.scoreplothandle=gobjects(2,1);
                        for i=1:ns+1
                            app.axhandles(i)=uiaxes(app.rawdatagrid,'TickLength',[0 0]); 
%                             app.axhandles(i).YLabel.Extent=[.5 .5 1 1];
%                             app.manualeditwindow=[app.manualeditwindow,rectangle(app.axhandles(end),'position',[0 0 1 1],'curvature',.2,'LineWidth',sqrt(2),'LineStyle',":")];
                        end
%                         linkprop(app.axhandles,'extent')
                        
                        temp=[];
                        if neeg>1, temp={'EEG Averaged'}; end
                        temp=[temp,strcat(repmat({'EEG'},1,neeg)',num2str((1:neeg)'))'];
                        if nemg>1, temp=[temp,{'EMG Averaged'}]; end
                        temp=[temp,strcat(repmat({'EMG'},1,nemg)',num2str((1:nemg)'))'];
                        app.clustersfeaturestable.ColumnFormat{2}=temp;
                        
                    if isfield(app.subjs(id).UserData,'guess'), app.clusterdetails.Data=app.subjs(id).UserData.guess;
                    else, app.clusterdetails.Data=[];
                    end, app.changeshowValueChanged;
                end
            end
        end

        % Value changed function: EpochNo
        function EpochNoValueChanged(app, event)
            value=app.EpochNo.Value;
            value=fix(value);
            app.EpochNoSlider.Value=value;
            app.EpochWindowValueChanged(app);
        end

        % Value changed function: EpochNoSlider
        function EpochNoSliderValueChanged(app, event)
            value=app.EpochNoSlider.Value;
            value=fix(value);
            app.EpochNo.Value=value;
            app.EpochWindowValueChanged(app);
        end

        % Value changed function: EpochNoTimestamp
        function EpochNoTimestampValueChanged(app, event)
            value=app.EpochNoTimestamp.Value;
            id=app.ID.Value;
            h=app.subjs(id).Children(1).Data;%handle to this subjs data summary
            eL=app.epochlength.Value;
            try
            value=datetime(value,'InputFormat','MM-dd-yy HH:mm:ss');
            TS=datetime(h(:,3),'InputFormat','MM-dd-yy HH:mm:ss');
            val=find(value>=TS,1);
            de=1;
            for i=1:val-1
                de=de+floor(seconds(duration(h(i,4)))/eL);
            end
            de=de+floor(seconds(value-TS(val))/eL);
            app.EpochNo.Value=de;
            app.EpochNoSlider.Value=de;
            app.EpochWindowValueChanged;
            catch err
                app.updatestatus(err.message)
                app.EpochNoTimestamp.Value=app.findtimestamp(id,app.EpochNo.Value);
            end
        end

        % Value changed function: EpochWindow
        function EpochWindowValueChanged(app, event)
            value=app.EpochWindow.Value;%requested number of epochs for preview
            if value>0
            %gather some info about the subject
            eL=app.epochlength.Value;
            id=app.ID.Value;
            h=app.subjs(id);
            eegidx=str2double(strsplit(h.Children(6).Value,' '));%which signals are eeg
            neeg=length(eegidx);
            emgidx=h.Children(4).Value;
            if ~isempty(emgidx), emgidx=str2double(strsplit(emgidx,' ')); end%which signals are emg
            ds=h.Children(2).Value;%downsample factor
            h=h.Children(1);%handle to this subjs data summary
            userdata=h.UserData;
            h=h.Data;
            if ~isempty(h)
                %figure out which file(s) to open
                start=app.EpochNo.Value;
                stop=start+value-1;
                de=zeros(size(h,1),1);%duration in epochs
                for i=1:size(h,1)
                    de(i)=floor(seconds(duration(h(i,4)))/eL);%,'inputformat','dd:hh:mm:ss'
                end
                de=[0;cumsum(de)];
                if de(end)<stop || de(end)<start
%                     app.updatestatus('warning: window has exceeded the selected data')
                    start=de(end)-value+1;
                    stop=de(end);
                    app.EpochNo.Value=start;
                    app.EpochNoSlider.Value=start;
                end
                toopen=unique([find(start>de,1,'last' ),find(stop<de(2:end),1,'first' )]);
                if length(toopen)==2, toopen=toopen(1):toopen(2); end
                
                idx=[eegidx,emgidx];
                data=cell(length(idx),1);
                %read only the requested data
                for i=toopen
                    %get file info
                    file=[h{i,1},h{i,2}];
                    dur=seconds(duration(h(i,4)));%duration in seconds
                    fs=str2double(strsplit(h{i,5},' '));%sampling freq
                    ns=h{i,6};%num signals
                    try
                    params=userdata.sigparams{i}(idx,:);%params:(1)=digital_min,(2)=digital_max,(3)=physical_min,(4)=physical_max
                    catch
                        app.updatestatus('error: check eeg/emg signal specification on import tab')
                    end
                    spr=userdata.samples_per_record{i};%
                    drd=spr(1)/fs(1);%data record duration
                    
                    %find where to start & how much to read
                    if start<de(i), start=de(i)+1; end
                    offset1=mod(start-1,drd);
                    val=floor(dur/eL)-(start-de(i))+1;
                    if value>val, value=value-val; offset2=0;
                    else, val=value; offset2=mod(drd-mod(val,drd),drd); end
                    
                    %read the data
                    format='int16';
                    if contains(file,'.edf'), format='int16=>single';
                    elseif contains(file,'.kcd'), format='uint16=>single';
                    end
                    fid=fopen(file);
                    fseek(fid,-floor(sum(fs)*dur*2),'eof');%seek to start of data within this file
                    fseek(fid,floor(sum(fs)*(start-de(i)-1-offset1)*eL*2),'cof');%seek to start of requested data within this file
                    [temp,count]=fread(fid,floor((val+offset1+offset2)*eL*sum(fs)),format,2*(ds-1));
                    fclose(fid);
                    
                    %digitally transform & reshape data
                    temp=reshape(temp, sum(spr), count/sum(spr))';
                    spr=[0;cumsum(spr)];
                    if isempty(data), data=cell(length(idx),1); end
                    for ii=1:length(idx)
                        temp2=reshape(temp(:,spr(idx(ii))+1:spr(idx(ii)+1))',[],1);
                        temp2=temp2(1+offset1*fs(idx(ii))*eL:end-offset2*fs(idx(ii))*eL);
                        data{ii}=[data{ii};(temp2-params(ii,1))/(params(ii,2)-params(ii,1)).*(params(ii,4)-params(ii,3))+params(ii,3)];
                    end
                end
                %plot raw data
                            lab=[strcat(repmat({'EEG'},1,neeg)',num2str((1:neeg)'))',repmat({'EMG'},1,length(emgidx))];
                start=app.EpochNo.Value;
                fs=fs(idx(end));
                for i=1:length(data)
                    lim=max(abs(data{i}));
                    if lim==0, lim=.001; end
                    if contains(class(app.manualeditwindow(i)),'Placeholder') || ~isvalid(app.manualeditwindow(i))
                        p=[0 -lim fs*eL*app.manualeditwindowEditField.Value lim*2];
                    else
                        p=app.manualeditwindow(i).Position;
                    end
                    cla(app.axhandles(i));
                    hold(app.axhandles(i),'on');
%                     line(app.axhandles(i),[(0:fs*eL*m:length(data{end}))' (0:fs*eL*m:length(data{end}))'],[-ylim ylim],'color',[.42 .42 .42],'linestyle','--');
                    plot(app.axhandles(i),data{i},'displayname',lab{i});
                    app.axhandles(i).XLim=[0 length(data{i})];
                    app.axhandles(i).YLim=[-lim lim];
                    app.axhandles(i).XTick=[];
                    app.axhandles(i).XTickLabel={};
                    app.axhandles(i).YLabel.String=lab{i};
                    app.manualeditwindow(i)=rectangle(app.axhandles(i),'position',p,'curvature',.2,'LineWidth',sqrt(2),'LineStyle',":");
                end
                
                %plot scoring                
                y=zeros(stop-start+1,1);
                if strcmp(app.changeshow.Value,'clusters') && isfield(app.subjs(id).UserData,'clust')
                    y=app.subjs(id).UserData.clust(start:stop)-1;
                    C=unique(app.subjs(id).UserData.clust);
                    N=length(C);
                    thesecolors=colormap(app.axhandles(end),jet(N));
                app.axhandles(end).YLabel.String='cluster';
%                 app.axhandles(end).YTickLabel=app.statelabels;
                else
                    if strcmp(app.changeshow.Value,'imported score') && isfield(app.subjs(id).UserData,'scoreI'), y=app.subjs(id).UserData.scoreI(start:stop);
                    elseif strcmp(app.changeshow.Value,'score') && isfield(app.subjs(id).UserData,'score'), y=app.subjs(id).UserData.score(start:stop);
                    end
                    N=length(app.statelabels);
                    thesecolors=app.mycolors;
                app.axhandles(end).YLabel.String='score';
                app.axhandles(end).YTickLabel=app.statelabels;
                end
                
                if contains(class(app.manualeditwindow(end)),'Placeholder') || ~isvalid(app.manualeditwindow(end))
                    p=[0 0 app.manualeditwindowEditField.Value N-1];
                else, p=app.manualeditwindow(end).Position;
                end
                cla(app.axhandles(end));
                hold(app.axhandles(end),'on');
                for i=1:N, x=find(y==(i-1)); scatter(app.axhandles(end),x-.5,ones(length(x),1).*(i-1),100,thesecolors(i,:),'.'); end%,"DisplayName",app.statelabels{i}
                colormap(app.axhandles(end),'jet')
                app.axhandles(end).XLim=[0 length(y)];
                app.axhandles(end).YLim=[0 N-1];
                app.axhandles(end).YTick=0:N-1;
                app.manualeditwindow(end)=rectangle(app.axhandles(end),'position',p,'curvature',.2,'LineWidth',sqrt(2),'LineStyle',":");
                
                m=floor(app.EpochWindow.Value/100)+1;
                app.axhandles(end).XTick=0.5:m:stop-start+1;
                app.axhandles(end).XTickLabel=cellfun(@num2str,num2cell(start:m:stop+1),'uniformoutput',false);
                app.axhandles(end).XTickLabelRotation=30;
                
                if ~all(isvalid(app.scoreplothandle)) || contains(class(app.scoreplothandle),'Placeholder')
                app.scoreplothandle=line(app.scoreplot,[[start;start] [stop;stop]],[-1 N],'color','k');
                else
                    app.scoreplothandle(1).XData=[start start];
                    app.scoreplothandle(2).XData=[stop stop];
                    app.scoreplothandle(1).YData=[-1 N];
                    app.scoreplothandle(2).YData=[-1 N];
                end
                
                app.highlightepochsinmanualeditwindowCheckBoxValueChanged;
                
            app.EpochNoTimestamp.Value=app.findtimestamp(id,start);
            end
            else
                        for i=1:length(app.axhandles)
                            cla(app.axhandles(i));
                        end
            end
        end

        % Value changed function: 
        % highlightepochsinmanualeditwindowCheckBox
        function highlightepochsinmanualeditwindowCheckBoxValueChanged(app, event)
            value = app.highlightepochsinmanualeditwindowCheckBox.Value;
            if ~isempty(app.highlight{1}), delete(app.highlight{1}); end
            if value
            id=app.ID.Value;
            if isfield(app.subjs(id).UserData,'feat')
            ss = (app.manualeditwindow(end).Position(1)+app.EpochNo.Value):(app.manualeditwindow(end).Position(1)+app.EpochNo.Value+app.manualeditwindowEditField.Value);
                    hold(app.Features,'on')
                    app.highlight{1}=scatter3(app.Features,app.subjs(id).UserData.feat(ss,1),app.subjs(id).UserData.feat(ss,2),app.subjs(id).UserData.feat(ss,3),10,[0 0 0],'*','linewidth',1,'displayname','window');
                    hold(app.Features,'off')
            end
            else
            end
% app.updatefeatures
        end

        % Window key press function: UIFigure
        function UIFigureWindowKeyPress(app, event)
            key = event.Key;
            m=event.Modifier;
            id=app.ID.Value;
            win=app.EpochWindow.Value;
            mewin=app.manualeditwindowEditField.Value;
            eL=app.epochlength.Value;
            if isempty(m),m=''; end
            if app.TabGroup.SelectedTab == app.AnalysisTab && app.AnalysisTabGroup.SelectedTab == app.ScoreTab
                if strcmp(key,'rightarrow') 
                    p=app.manualeditwindow(end).Position(1);
                    if isfield(app.subjs(id).UserData,'fs'), fs=app.subjs(id).UserData.fs;
                    else, fs=str2double(strsplit(app.subjs(id).Children(1).Data{1,5},' ')); fs=fs(1);
                    end
                    if strcmp(m,'control') || (p+mewin)>=win
                    app.windowRPushed;
                        for i=1:length(app.manualeditwindow)-1
                            app.manualeditwindow(i).Position(1)=0;
                        end,app.manualeditwindow(end).Position(1)=0;
                    else
                        for i=1:length(app.manualeditwindow)-1
                            app.manualeditwindow(i).Position=app.manualeditwindow(i).Position+[eL*fs 0 0 0];
                        end,app.manualeditwindow(end).Position=app.manualeditwindow(end).Position+[1 0 0 0];
                    end
                elseif strcmp(key,'leftarrow')
                    p=app.manualeditwindow(end).Position(1);
                    if isfield(app.subjs(id).UserData,'fs'), fs=app.subjs(id).UserData.fs;
                    else, fs=str2double(strsplit(app.subjs(id).Children(1).Data{1,5},' ')); fs=fs(1);
                    end
                    if strcmp(m,'control') || p==0
                    app.windowLPushed;
                        for i=1:length(app.manualeditwindow)-1
                            app.manualeditwindow(i).Position(1)=eL*fs*(win-mewin);
                        end,app.manualeditwindow(end).Position(1)=win-mewin;
                    else
                        for i=1:length(app.manualeditwindow)-1
                            app.manualeditwindow(i).Position=app.manualeditwindow(i).Position-[eL*fs 0 0 0];
                        end,app.manualeditwindow(end).Position=app.manualeditwindow(end).Position-[1 0 0 0];
                    end
                elseif strcmp(key,'uparrow')
                    if strcmp(m,'control')
                        app.manualeditwindowEditField.Value=app.manualeditwindowEditField.Value+1;
                        app.manualeditwindowEditFieldValueChanged;
                    else
                        i=find(strcmp(app.manualeditDropDown.Value,app.manualeditDropDown.Items))-1;
                        n=length(app.statelabels);
                        i=mod(i-1,n)+1;
                        app.manualeditDropDown.Value=app.manualeditDropDown.Items(i);
                    end
                elseif strcmp(key,'downarrow')
                    if strcmp(m,'control')
                        if app.manualeditwindowEditField.Value-1>0
                        app.manualeditwindowEditField.Value=app.manualeditwindowEditField.Value-1;
                        app.manualeditwindowEditFieldValueChanged;
                        end
                    else
                        i=find(strcmp(app.manualeditDropDown.Value,app.manualeditDropDown.Items))-1;
                        n=length(app.statelabels);
                        i=mod(i+1,n)+1;
                        app.manualeditDropDown.Value=app.manualeditDropDown.Items(i);
                    end
                elseif strcmp(key,'space')
                    if ~isfield(app.subjs(id).UserData,'score')
                        app.subjs(id).UserData.score=zeros(app.EpochNoSlider.Limits(end),1);
                    end
                    a=app.manualeditwindow(end).Position(1)+app.EpochNo.Value;
                    b=app.manualeditwindowEditField.Value;
                    c=find(strcmp(app.manualeditDropDown.Value,app.statelabels))-1;
                    app.subjs(id).UserData.score(a:(a+b-1))=c;
                    app.changeshowValueChanged;
                end
                        app.highlightepochsinmanualeditwindowCheckBoxValueChanged;
            end
        end

        % Value changed function: manualeditwindowEditField
        function manualeditwindowEditFieldValueChanged(app, event)
            value = app.manualeditwindowEditField.Value;
                eL=app.epochlength.Value;
            id=app.ID.Value;
                    if isfield(app.subjs(id).UserData,'fs'), fs=app.subjs(id).UserData.fs;
                    else, fs=str2double(strsplit(app.subjs(id).Children(1).Data{1,5},' ')); fs=fs(1);
                    end
                    for i=1:length(app.manualeditwindow)-1
                        app.manualeditwindow(i).Position(3)=value*eL*fs;
                    end
                        app.manualeditwindow(end).Position(3)=value;
        end

        % Button pushed function: windowL
        function windowLPushed(app, event)
            if app.EpochWindow.Value>=app.EpochNo.Value, app.EpochNo.Value = 1;
            else, app.EpochNo.Value = app.EpochNo.Value - app.EpochWindow.Value;
            end
            app.EpochNoValueChanged(app);
        end

        % Button pushed function: windowR
        function windowRPushed(app, event)
            app.EpochNo.Value = app.EpochNo.Value + app.EpochWindow.Value;
            app.EpochNoValueChanged(app);
        end

        % Cell edit callback: rules
        function rulesCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;
            if indices(2)==3%add
                app.rules.Data=[app.rules.Data(1:indices(1),:);{'default','default',false,false};app.rules.Data(indices(1)+1:end,:)]; 
                app.rules.Data(indices(1),indices(2))={false};
            elseif indices(2)==4%remove
                app.rules.Data(indices(1),:)=[];
            end
        end

        % Cell edit callback: clustersfeaturestable
        function clustersfeaturestableCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;
                h=app.clustersfeaturestable;
            if indices(2)==5%add
                h.Data=[h.Data(1:indices(1),:);{'default',app.featuresrc{1},'N/A','median',false,false};h.Data(indices(1)+1:end,:)]; 
                h.Data(indices(1),indices(2))={false};
                m=size(h.Data,1); n=2^m; 
                idx=false(n,m);
                for i=1:m, idx(reshape([2^i/2+1:2^i]'+([0:2^(i):(2^m-1)]),1,[]),m+1-i)=true; end
                temp={'low','high'};
                app.truthtable.Data=[repmat(app.statelabels(1),n,1),temp(idx+1)];
                app.truthtable.ColumnName=[{'state'};h.Data(:,1)];
                app.truthtable.ColumnWidth=[{'auto'},num2cell(ones(1,5).*50)];
            elseif indices(2)==6%remove
                h.Data(indices(1),:)=[];
                m=size(h.Data,1); n=2^m; 
                idx=false(n,m);
                for i=1:m, idx(reshape([2^i/2+1:2^i]'+([0:2^(i):(2^m-1)]),1,[]),m+1-i)=true; end
                temp={'low','high'};
                app.truthtable.Data=[repmat(app.statelabels(1),n,1),temp(idx+1)];
                app.truthtable.ColumnName=[{'state'};h.Data(:,1)];
            elseif indices(2)==1%label change
                app.truthtable.ColumnName{indices(1)+1}=newData;
            end
        end

        % Cell edit callback: clusterdetails
        function clusterdetailsCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;
            id=app.ID.Value;
            userdata=app.subjs(id).UserData;
            
            c=app.clusterdetails.Data{indices(1),1};
            ss=userdata.clust==c;
            if indices(2)==2 %show
                if newData
                    hold(app.Features,'on')
                    app.highlight{c+1}=scatter3(app.Features,userdata.feat(ss,1),userdata.feat(ss,2),userdata.feat(ss,3),10,[0 0 0],'x','linewidth',1,'displayname',num2str(c));
                    hold(app.Features,'off')
                else
                    delete(app.highlight{c+1});
                end
            elseif indices(2)==3 %score
                s=find(strcmp(app.statelabels,newData))-1;
                userdata.score(ss)=s;
                userdata.guess=app.clusterdetails.Data;
                app.subjs(id).UserData = userdata;
                app.changeshowValueChanged;
                app.displaystatedistribution(userdata.score,app.ID.Items{id});
            end
        end

        % Cell edit callback: statelabelstable
        function statelabelstableCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;
            h=app.statelabelstable;
            if indices(2)==2%add
                h.Data=[h.Data(1:indices(1),:);{'default',false,false};h.Data(indices(1)+1:end,:)]; 
                h.Data(indices(1),indices(2))={false};
            elseif indices(2)==3%remove
                h.Data(indices(1),:)=[];
            end
            app.updatestatelabels(h.Data(:,1)')
        end

        % Button pushed function: SaveButton
        function SaveButtonPushed(app, event)
            [file,path]=uiputfile('*.ini');
            fid=fopen([path,file],'w');
            %%--------------------------------------------------------------
            fprintf(fid,[app.settings{1},'\n']);
            h=app.epochfeaturesgrid.Children;
            for i=1:length(h)
                if contains(class(h(i)),'Label'), b=h(i+1).Value;
                elseif contains(class(h(i)),'CheckBox'), b=h(i).Value;
                else, continue
                end
                if iscell(h(i).Text), a=strjoin(h(i).Text,',');
                else, a=h(i).Text;
                end
                fprintf(fid,'%s=%f\n',a,b);
            end
            %%--------------------------------------------------------------
            fprintf(fid,['\n',app.settings{2},'\n']);
            h=app.clustersgrid.Children;
            for i=1:length(h)
                if contains(class(h(i)),'Label')
                    fprintf(fid,'%s=%s\n',h(i).Text,h(i+1).Value);
                end
            end
            %%--------------------------------------------------------------
            fprintf(fid,['\n',app.settings{3},'\n']);
            h=app.clustersfeaturestable.Data;
            for i=1:size(h,1)
                fprintf(fid,'F%d=%s\n',i,strjoin(h(i,1:4),','));
            end
            fprintf(fid,'guess=%s\n',strjoin(app.truthtable.Data(:,1),','));
            %%--------------------------------------------------------------
            fprintf(fid,['\n',app.settings{4},'\n']);
            h = app.rules.Data;
            for i=1:size(h,1)
                fprintf(fid,'rule%d=%s\n',i,strjoin(h(i,1:2),','));
            end
            %%--------------------------------------------------------------
            fprintf(fid,['\n',app.settings{5},'\n']);
            h=app.statelabelstable.Data;
            fprintf(fid,'labels=%s\n',strjoin(h(:,1)',','));
            %%--------------------------------------------------------------
            fclose(fid);
            app.updatestatus(['saved ',path,file]);
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
            [file,path]=uigetfile('*.ini');
            fid=fopen([path,file],'r');
            setting=0;
            app.clustersfeaturestable.Data={};
            while ~feof(fid)
                A=fgetl(fid);
                if ~isempty(A)
                    if A(1)=='[' && A(end)==']'
                        setting=find(strcmp(A,app.settings));
                        if isempty(setting), app.updatestatus(['error reading section ',A]); end
                    else
                    a=strsplit(A,'=');
                    b=strsplit(a{1},',');
                    if length(b)==1, b=b{:}; else, b=b'; end
                    c=strsplit(a{2},',');
                    if length(c)==1, c=c{:}; end
                        switch setting
                            case 1
                                h=app.epochfeaturesgrid.Children;
                                idx=find(h==findobj(h,'Text',b));
                                if contains(class(h(idx)),'Label'), idx=idx+1; end
                                h(idx).Value=str2double(c);
                            case 2
                                h=app.clustersgrid.Children;
                                idx=find(h==findobj(h,'Text',b))+1;
                                h(idx).Value=c;
                            case 3
                                h=app.clustersfeaturestable;
                                if b(1)=='F'
                                    h.Data(str2num(b(2)),:)=[c,{false,false}];
                                else
                                    n=length(c); m=log2(n);
                                    idx=false(n,m);
                                    for i=1:m, idx(reshape([2^i/2+1:2^i]'+([0:2^(i):(2^m-1)]),1,[]),m+1-i)=true; end
                                    temp={'low','high'};
                                    app.truthtable.Data=[c',temp(idx+1)];
                                    app.truthtable.ColumnName=[{'state'};h.Data(:,1)];
                                end
                            case 4
                                h = app.rules;
                                idx=str2num(b(5:end));
                                h.Data(idx,1:2)=c;
                            case 5
                                h=app.statelabelstable;
                                h.Data=[c',num2cell(false(length(c),2))];
                                app.updatestatelabels(c');
                            otherwise
                        end
                    end
                end
            end
            fclose(fid);
            app.updatestatus(['loaded ',path,file]);
        end

        % Button pushed function: runanalysisButton
        function runanalysisButtonPushed(app, event)
            if app.BatchModeCheckBox.Value, id=1:length(app.subjs);
            else, id=app.ID.Value;
            end
            for iii=id
                if ~isempty(app.subjs(iii).Children(1).Data)
                app.updatestatus([app.subjs(iii).Children(8).Value,': reading files'])
                
                %gather some info about the subject
                h=app.subjs(iii);
                eegidx=str2double(strsplit(h.Children(6).Value,' '));%which signals are eeg
                emgidx=h.Children(4).Value;
                if ~isempty(emgidx), emgidx=str2double(strsplit(emgidx,' ')); else emgidx=[]; end %which signals are emg
                ds=h.Children(2).Value;%downsample factor
                idx=[eegidx,emgidx];
                neeg=length(eegidx);
                nemg=length(emgidx);
                h=h.Children(1);
                userdata=h.UserData;
                eL=app.epochlength.Value;
                h=h.Data;
                data=cell(length(idx),1);
                    Tdur=0;
                
                % get the data ------------------------------------------------------------------------------------------------------------------------------------------------------------
                for i=1:size(h,1)
                    %file info
                    file=[h{i,1},h{i,2}];
                    dur=seconds(duration(h(i,4)));%duration in seconds
                    fs=str2double(strsplit(h{i,5},' '));%sampling freq
                    params=userdata.sigparams{i}(idx,:);%params:(1)=digital_min,(2)=digital_max,(3)=physical_min,(4)=physical_max
                    spr=userdata.samples_per_record{i};%
                    
                    %read the file
                    format='int16';
                    if contains(file,'.edf'), format='int16=>single';
                    elseif contains(file,'.kcd'), format='uint16=>single';
                    end
                    fid=fopen(file);
                    fseek(fid,-floor(sum(fs)*dur*2),'eof');%seek to start of data within this file
                    [temp,count]=fread(fid,floor(sum(fs)*dur*2),format);
                    fclose(fid);
                    fs=fs./ds;
                    
                    %digitally transform & reshape data
                    temp=reshape(temp, sum(spr), count/sum(spr))';%reshape so that each row is 1 data record
                    spr=[0;cumsum(spr)];
                    dur=(dur-mod(dur,eL));
                    for ii=1:length(idx)
                        temp2=reshape(temp(:,spr(idx(ii))+1:ds:spr(idx(ii)+1))',[],1); %
                        temp2=temp2(1:dur*fs(idx(ii)));
                        data{ii}=[data{ii};(temp2-params(ii,1))/(params(ii,2)-params(ii,1)).*(params(ii,4)-params(ii,3))+params(ii,3)];
                    end
                    
                Tdur=Tdur+dur;
                end
                clearvars file params spr format fid temp temp2 Fstart Fdur TXstart TXdur dif txidx
                
                %some useful variables
                b=app.bandsperHz.Value; %number of spectral bands to make per Hz
                beeg=(1+app.eegpsdL.Value*b):app.eegpsdH.Value*b;
                bemg=(1+app.emgpsdL.Value*b):app.emgpsdH.Value*b;
                ns=length(data);%number of signals
                ne=Tdur/eL; %number of epochs
                fs=fs(eegidx(1));
                
                %extract the features' ------------------------------------------------------------------------------------------------------------------------------------------------------------
                app.updatestatus('fft')
                for i=1:ns, data{i}=reshape(data{i},fs*eL,[])'; end %put each epoch into a row
                psd=zeros(b*100,ne,ns);%fs*b/2
                zc=zeros(ne,ns);
                try %try to use gpu
                    gpuDevice(1);
                    for i=1:ns, psd(:,:,i)=mypmtm(app,data{i}',fs,b); end %calculate power spectral density
                    g=gpuDevice(1);
                    for i=1:ns %count zero crossings
                        [m,n]=size(data{i});
                        mem=g.AvailableMemory;
                        o=floor(mem/n/4/2);
                        indx=[0:o:m,m];
                        for ii=1:length(indx)-1
                            temp=gpuArray(-abs(data{i}(indx(ii)+1:indx(ii+1),:)));
                            zc(indx(ii)+1:indx(ii+1),i)=gather(sum(and(temp(:,2:end-1)>temp(:,3:end),temp(:,2:end-1)>temp(:,1:end-2)),2)); 
                        end
                        clearvars temp
                    end 
                catch %otherwise use cpu
                    fb=1/b:1/b:fs/2;
                    for i=1:ns %calculate power spectral density
                        temp=data{i}'; 
                        parfor ii=1:ne
                            temp2=pmtm(temp(:,ii),4,fb,fs);
                            psd(:,ii,i)=temp2(1:100*b);
                        end
                    end 
                    clearvars temp2 temp
                    for i=1:ns, temp=(-abs(data{i})); zc(:,i)=sum(and(temp(:,2:end-1)>temp(:,3:end),temp(:,2:end-1)>temp(:,1:end-2)),2); end %count zero crossings
                end
                psd=permute(psd,[2 1 3]);
                
                psd(psd==0)=NaN;
                zc(zc==0)=NaN;
                
                temp=[];
                for i=1:neeg
                    if app.includeZC.Value
                        temp=[temp,log(psd(:,beeg,i)),zc(:,i)];
                    else
                        temp=[temp,log(psd(:,beeg,i))];
                    end
                end
                for i=1:nemg
                    temp=[temp,log(psd(:,bemg,neeg+i))];
                end
                
m=app.outlierremovalmethodDropDown.Value;
                if m>0
                app.updatestatus('looking for outlier epochs')% ------------------------------------------------------------------------------------------------------------------------------------------------------------
                a=zeros(1,size(temp,2));
                    parfor i=1:size(temp,2) %for each psd band
                        dat=temp(:,i);%,ii);
                        A_L=false(length(dat),1);
                        A_H=false(length(dat),1);
                        T=4.1;
                        % look for outliers
                        while kurtosis(dat(~A_L&~A_H))>4
                            aL=true(nansum(~A_L&~A_H),1);
                            aH=true(nansum(~A_L&~A_H),1);
                            T=T-.1;
                            while(sum(aL|aH))>0
                                A=~A_L&~A_H;
                                aL=nanzscore(dat(A))<-T;
                                aH=nanzscore(dat(A))>T;
                                A_H(A)=aH;
                                A_L(A)=aL;
                            end
                        end
                        % deal with outliers
                        if m == 1
                            dat(A_H)=max(dat(~A_H));
                            dat(A_L)=min(dat(~A_L));
                        else
                            dat(A_H)=NaN;
                            dat(A_L)=NaN;
                        end
%                         test(:,i)=zscore(dat);
                        temp(:,i)=dat;
                        a(i)=sum(A_H|A_L)
                    end
                end
                
                app.updatestatus('pca')% ------------------------------------------------------------------------------------------------------------------------------------------------------------
                    [~,temp,~,~,explained]=pca(temp-nanmean(temp),'rows',app.PCArowsDropDown.Items{app.PCArowsDropDown.Value});
                    n=3; while sum(explained(1:n))*100<app.minimumexplained.Value, n=n+1; end
                    F=single(temp(:,1:n));
                app.updatestatus(['using ',num2str(n),' principle components'])
                app.updatestatus('linkage')
clearvars data
l=any(isnan(F),2);
ne=ne-sum(l);
Z=zeros(ne-1,3);
[~, sV] = memory;
mem=sV.SystemMemory.Available;
req=sum(1:ne-1)*32;
n=1;
if req>mem
    while req>mem
        n=n+1;
        Z=zeros(floor(ne/n)-1,3,n);
        mem=sV.SystemMemory.Available;
        req=sum(1:ne/n-1)*32;
    end
    app.updatestatus(['warning, pairwise distance calculations between all epochs in this dataset requires more memory than is available. it will be analyzed in ',num2str(n),' chunks, which may affect results'])
end
f=F(~l,:);
for i=1:n
        Z(:,:,i)=linkage(f(1+(i-1)*floor(ne/n):i*floor(ne/n),:),app.linkagemethodDropDown.Value,app.pdistmethodDropDown.Value);
end
                
                %save the important stuff to userdata  ------------------------------------------------------------------------------------------------------------------------------------------------------------
                userdata=[];
                userdata.feat=F;
                userdata.links=Z;
                userdata.art=l;
                userdata.psd=cat(2,psd,permute(zc,[1 3 2]));%psd;
                userdata.fs=fs;
                userdata.eL=eL;
                app.subjs(iii).UserData = userdata;
                
                if ~app.BatchModeCheckBox.Value
                app.redoclustersButtonPushed;
                end
                
                app.updatestatus([app.subjs(iii).Children(8).Value,' is done'])
                end
            end
                if app.BatchModeCheckBox.Value
                app.redoclustersButtonPushed;
                end
        end

        % Button pushed function: redoclustersButton
        function redoclustersButtonPushed(app, event)
            if app.BatchModeCheckBox.Value, id=1:length(app.subjs);
            else, id=app.ID.Value;
            end    
            for iii=id
                userdata=app.subjs(iii).UserData;
                h=app.subjs(iii);
                eegidx=str2double(strsplit(h.Children(6).Value,' '));%which signals are eeg
                neeg=length(eegidx);
                emgidx=h.Children(4).Value;
                if ~isempty(emgidx), emgidx=str2double(strsplit(emgidx,' ')); end %which signals are emg
                nemg=length(emgidx);
                b=app.bandsperHz.Value; %number of spectral bands to make per Hz
                
                if isfield(userdata,'links')
                    n=size(userdata.links,3);
                    %find clusters
                    app.updatestatus('clustering')
                    ne=size(userdata.feat,1);
                    nena=ne-sum(userdata.art);
                    f=userdata.feat(~userdata.art,:);
                    nC=app.numclusters.Value;
                    c=[];
                    nCo=0;
                    for ii=1:n
                        if nC<2
                            test=[];
                            for i=2:42
                                test(:,i-1)=cluster(userdata.links(:,:,ii),'maxclust',i);
                            end
                            eval=evalclusters(single(f(1+(ii-1)*floor(nena/n):ii*floor(nena/n),:)),single(test),'CalinskiHarabasz');
                            nCn=eval.OptimalK;
                            c=[c;test(:,nCn-1)+nCo];
                            nCo=nCo+nCn;
                            if n>1, app.updatestatus(['chunk ',num2str(ii),' has ',num2str(nCn),' clusters']); 
                            else, app.updatestatus([' using ',num2str(nCn),' clusters']); end
                        else
                            c=[c;cluster(userdata.links(:,:,ii),'maxclust',nC)+nCo];
                            nCo=nCo+nC;
                        end
                    end
                    c=[c;zeros(mod(nena,floor(nena/n)),1)];
                    s=zeros(ne,1);
                    C=s;
                    C(~userdata.art)=c;
                    nE=zeros(nCo,1);
%                     dens=zeros(nC,1);
                    guess=repmat({'???'},nCo,1);
                    
                    %set thresholds
                    stuff=app.clustersfeaturestable.Data;
                    nF=size(stuff,1);
                    F=zeros(nCo,nF);
                    T=zeros(nF,1);
                    src=cell(nF,1);
                    rng=cell(nF,1);
                    for i=1:nF
                        if contains(stuff{i,2},'EEG')
                            if contains(stuff{i,2},'Averaged')
                                src{i}=1:neeg;
                            else
                                temp=str2num(stuff{i,2}(end));
                                src{i}=temp;
                            end
                        elseif contains(stuff{i,2},'EMG')
                            if contains(stuff{i,2},'Averaged')
                                src{i}=neeg+1:neeg+nemg;
                            else
                                temp=str2num(stuff{i,2}(end));
                                src{i}=neeg+temp;
                            end
                        elseif contains(stuff{i,2},'density')
                        else
                            app.updatestateus('error in settings')
                            return
                        end
                        if contains(stuff{i,3},["ZC","zc"])
                            rng{i}=size(userdata.psd,2);
                        else
                            temp=strsplit(stuff{i,3},':');
                            if length(temp)~=2, app.updatestatus('error in settings'); return, 
                            else, rng{i}=str2num(temp{1})*b:str2num(temp{2})*b; end
                        end
                        if contains(stuff{i,4},["median","med"])
                            T(i)=nanmedian(nansum(nanmean(userdata.psd(~userdata.art,rng{i},src{i}),3),2));
                        elseif contains(stuff{i,4},["midrange","mid"])
                            temp=nansum(nanmean(userdata.psd(~userdata.art,rng{i},src{i}),3),2);
                            T(i)=(max(temp)-min(temp))/2+min(temp);
%                         elseif contains(stuff{i,4},["harm","harmonic"])
%                             T(i)=harmmean(nansum(nanmean(userdata.psd(~userdata.art,rng{i},src{i}),3),2),'omitnan');
%                         elseif contains(stuff{i,4},["geo","geometric"])
%                             T(i)=geomean(nansum(nanmean(userdata.psd(~userdata.art,rng{i},src{i}),3),2),'omitnan');
                        elseif contains(stuff{i,4},["mean","average","avg"])
                            T(i)=nanmean(nansum(nanmean(userdata.psd(~userdata.art,rng{i},src{i}),3),2));
                        else
                            T(i)=str2double(stuff{i,4});
                        end
                    end
                    app.updatestatus(sprintf(['Thresholds: ',strjoin(stuff(:,1)',' %0.4f\t '),' %0.4f\t '],T));
                    
                    % compare clusters' features to thresholds and make a guess at which state each clust is
                    for i=1:nCo
                        ss=C==i;%subset
                        nE(i)=sum(ss);
                        for ii=1:nF
                            F(i,ii)=nanmean(nansum(nanmean(userdata.psd(ss,rng{ii},src{ii}),3),2));
                        end
                        if sum(ss)>=10%42 %length(ss)*.005
                            temp=flip(F(i,:)>T');
                            idx=sum(2.^(find(temp)-1))+1;
                            guess(i)=app.truthtable.Data(idx,1);
                            s(ss)=find(strcmp(guess(i),app.statelabels))-1;
                        end
%                         ff=userdata.feat(ss,:);
%                         ff=ff-mean(ff);
%                         ff=ff(:,1:3);
%                         [ff(:,1),ff(:,2),ff(:,3)]=cart2sph(ff(:,1),ff(:,2),ff(:,3));
%                         r=max(ff(:,3));
%                         dens(i)=sum(ss)/(4/3*pi*r^3);
                    end
                    [~,idx]=sort(nE,'descend');
%                     app.clusterdetails.Data=[num2cell(idx),num2cell(false(nCo,1)),guess(idx),num2cell(nE(idx)),num2cell(F(idx,:))];
                    
                    app.clusterdetails.ColumnFormat(4:4+nF)=repmat({'short'},1,nF+1);
                    app.clusterdetails.ColumnName(5:4+nF)=stuff(:,1)';
                    
                    userdata.clust = C;
                    userdata.score = s;
%                     userdata.guess = app.clusterdetails.Data;
                    userdata.guess = [num2cell(idx),num2cell(false(nCo,1)),guess(idx),num2cell(nE(idx)),num2cell(F(idx,:))];
                    if iii==app.ID.Value, app.clusterdetails.Data=userdata.guess; end
%                     userdata.clusterdeets=app.clusterdetails.Data;
%                     userdata.clusterthresh=T;
                    app.subjs(iii).UserData = userdata;
                    app.changeshowValueChanged;
                    app.displaystatedistribution(s,app.subjs(iii).Children(8).Value);
                else
                    app.updatestatus([app.subjs(iii).Children(8).Value,': analysis has not yet been run'])
                end
            end
        end

        % Button pushed function: ApplyFindandReplaceRulesButton
        function ApplyFindandReplaceRulesButtonPushed(app, event)
            if app.BatchModeCheckBox.Value, id=1:length(app.subjs);
            else, id=app.ID.Value;
            end
            for iii=id
                userdata=app.subjs(iii).UserData;
                if isfield(userdata,'score')
                    s=userdata.score;
                    s=s+1;
                    ne=size(s,1);%num epochs
                    ns=size(s,2);
                    for iiii=1:ns
                        rule = app.rules.Data;
                        for i=1:size(rule,1)
                            f=strsplit(rule{i,1},'>');
                            r=strsplit(rule{i,2},'>');
                            if length(f)~=length(r)
                                app.updatestatus('error, there is a find/replace length mismatch');
                                return;
                            end
                            nfr=length(f);%number of epochs to find and replace
                            for ii=1:nfr
                                f{ii}=find(strcmp(f(ii),app.statelabels));
                                r{ii}=find(strcmp(r(ii),app.statelabels));
                            end
                            f=cat(2,f{:});
                            r=cat(2,r{:});
                            if ~isempty(f)
                                for ii=1:ne-nfr
                                    if s(ii:ii+nfr-1,iiii)==f'
                                        s(ii:ii+nfr-1,iiii)=r;
                                    end
                                end
                            end
                        end
                    end
                    s=s-1;
                    userdata.score=s;
                    app.subjs(iii).UserData = userdata;
                    app.EpochWindowValueChanged;
                    app.displaystatedistribution(s,app.subjs(iii).Children(8).Value);
                else
                    app.updatestatus([app.subjs(iii).Children(8).Value,': analysis has not yet been run'])
                end
            end
                app.changeshowValueChanged;
        end

        % Value changed function: changeshow, 
        % onlyplotepochsinpreviewwindowCheckBox
        function changeshowValueChanged(app, event)
            app.updatefeatures;
            app.updatescoreplot;
            app.EpochWindowValueChanged;
        end

        % Value changed function: disable3dplotButton
        function disable3dplotButtonValueChanged(app, event)
                app.updatefeatures;
        end

        % Button pushed function: plaintextButton
        function plaintextButtonPushed(app, event)
            for i=1:length(app.subjs)
                
            end
        end

        % Button pushed function: ExportDone
        function ExportDoneButtonPushed(app, event)
            list = app.ExportTable.Data;
        if app.CompareCheckBox.Value
%             app.updatestatus('initializing actx server');
%             xl = actxserver('Excel.Application');
        end
        poop=0;
            for i=1:length(app.subjs)
                if ~isempty(app.subjs(i).Children(1).Data)
                    userdata = app.subjs(i).UserData;
%                     eL=str2double(userdata.eL);
                    eL=userdata.eL;
                    S=userdata.score;
                    h=app.subjs(i).Children(1).Data;
                    j=1;
        if app.CompareCheckBox.Value
%             xlWB = xl.Workbooks.Add;
%             xlWB.Activate;
%             xlSheets = xl.ActiveWorkbook.Sheets;
        end
err=0;
                for ii=1:size(h,1)
                    path=list{poop+ii,2};
                    file=list{poop+ii,3};
                    src=list{poop+ii,4};
                    ext=src(end-3:end);
                    dur=seconds(duration(h(ii,4)));
                    ne=floor(dur/eL);
                    s=S(j:j+ne-1)+1;
%                     ts=posixtime(datetime(app.findtimestamp(i,j),'inputformat','MM-dd-yy HH:mm:ss'));
                    ts=seconds(datetime(app.findtimestamp(i,j),'inputformat','MM-dd-yy HH:mm:ss')-datetime('01-01-0001 00:00:00','inputformat','MM-dd-yyyy HH:mm:ss'));
                    j=j+ne;
                    
                    newfile=app.checkfilename([path,file(1:end-4),app.outputfilesuffixEditField.Value,ext]);
                    copyfile(src,newfile,'f');
%                     app.updatestatus(['writing to ',newfile])
                    if strcmp(ext,'.raf')
                        s=cell2mat(app.rosettaStone.Data(s,2));
                        try
                            fid=fopen(newfile,'r+');
                            temp=fread(fid,Inf,'uint16=>uint16');
                            frewind(fid);
                            idx=[4577,4833,6633]; %possible locations for where the scoring in the file starts (this changes depending on user settings within sleepsign. these are the 3 that I have found. there may be more) 
                            idx2=idx(temp(idx)>0);
                            if isempty(idx2) || length(idx2)>1
                                disp(['error: not sure where the scoring starts in ',file,'... send it to daniel']); fclose(fid); break;
                            end
                            fseek(fid,(idx2+1)*2-187,-1);
                            fwrite(fid,s,'uint8',187);
                            fclose(fid);
                            app.updatestatus(['saved ',newfile]);
                        catch ME
                            app.updatestatus(['error writing ',newfile]);
                        end
                    elseif strcmp(ext,'.zdb')
  T=char(strjoin(strcat('(',join(string([num2cell(1:ne)',num2cell([ts:eL:ts+(ne-1)*eL].*1e7)',num2cell([ts+eL:eL:ts+ne*eL].*1e7)',strcat('"',app.rosettaStone.Data(s,3),'"'),num2cell(ones(ne,1))]),',',2),')'),',')+";");
                            conn=sqlite(newfile);
                            a=fetch(conn,'SELECT name FROM sqlite_master');
                            if sum(contains(a,'temporary_scoring_marker'))>0, t='temporary_scoring_marker';
                            elseif sum(contains(a,'scoring_marker'))>0, t='scoring_marker';
                            else
                                app.updatestatus('error: couldn''t find the field in the zdb file that contained scoring')
                                return
                            end
                            exec(conn,['DROP TABLE ',t]);
                            exec(conn,['CREATE TABLE ',t, ...
                                       '  ( id       	INTEGER PRIMARY KEY, ',...
                                       '    starts_at   INTEGER(8), ',...
                                       '    ends_at  	INTEGER(8), ',...
                                       '    notes       TEXT, ',...
                                       '    type       	TEXT, ',...
                                       '    location    TEXT, ',... 
                                       '    is_deleted  INTEGER(1), ',...
                                       '    key_id      INTEGER  ) ']);
                            exec(conn,['INSERT INTO ',t,' (id, starts_at, ends_at, type, key_id) ',...
                                      'VALUES ',T]);
                        close(conn)
                    else
                        app.updatestatus(['error: unrecognized file extension with ',file])
                        return
                    end
                    
        if app.CompareCheckBox.Value
%             if strcmp(ext,'.raf')
%                 so=app.myreadraf(src,ne);
%             elseif strcmp(ext,'.zdb')
%                 so=app.myreadzdb(src);
%             else
%                 app.updatestatus('https://xkcd.com/2200/')
%             end
%                 
%                 so(so>3)=0;
%                 so(so==3)=4; so(so==2)=3; so(so==4)=2;
%                 s(s==2)=4; s(s==3)=2; s(s==4)=3;
%                 if sum(so==0)==0 && sum(s==0)==0
%                     cm=zeros(4);
%                     cm(2:4,2:4)=confusionmat(s,so);
%                 else
%                     cm=confusionmat(s,so);
%                 end
%                 
%                 n=length(app.statelabels);
%                 output=cell(n+1,15);
%                 output(1,1)={'# epochs in'};
%                 output(2:1+n,1)=app.statelabels;
%                 output{1,2}=src;
%                 output{1,3}=newfile;
%                 for iii=0:n-1
%                     output{2+iii,2}=sum(so==iii);
%                     output{2+iii,3}=sum(s==iii);
%                 end
%                 output(1,11)={'Confusion Matrix'};
%                 output(1,12:15)=app.statelabels;
%                 output(2:1+n,11)=app.statelabels;
%                 output(2:1+n,12:15)=num2cell(cm);
%                 output(1,5)={'Overall Accuracy'};
%                 output(2,5)={'=sum(L2,M3,N4,O5)/sum(L2:O5)*100'};
%                 output(2:1+n,7)=app.statelabels;
%                 output(1,8:9)={'Specificity','Sensitivity'};
%                 for iii=1:4
%                     output(1+iii,8)={['=',xlLetters(11+iii),num2str(1+iii),'/sum(',xlLetters(11+iii),'2:',xlLetters(11+iii),'5)*100']};
%                     output(1+iii,9)={['=',xlLetters(11+iii),num2str(1+iii),'/sum(L',num2str(1+iii),':O',num2str(1+iii),')*100']};
%                 end
%                 
%             if ii==1, xlS1=xlSheets.get('Item',1); end
%             xlSheets.Add();
%             xlS=xlSheets.get('Item',1);
%             xlS.Activate;
%             xl.ActiveSheet.Name = num2str(ii);
%             xlR=xl.ActiveSheet.get('Range',['A1:',xlLetters(size(output,2)),num2str(size(output,1))]);
%             xlR.Value=output;
        end
                end
                poop=poop+ii;
        if app.CompareCheckBox.Value
%             if ~err
%             xlS1.Delete;
%             xlfile=app.checkfilename([path,app.subjs(i).Children(8).Value,'_compare',app.outputfilesuffixEditField.Value,'.xlsx']);
%             xlWB.SaveAs(xlfile);
%             xlWB.Saved=1;
%             Close(xlWB)
%             app.updatestatus(['saved ',xlfile])
%             else
%             Close(xlWB)
%             end
        end
                end
            end
        if app.CompareCheckBox.Value
%             Quit(xl)
%             delete(xl)
        end
            app.updatestatus('all done!')
            fclose all;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1280 960];
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.WindowKeyPressFcn = createCallbackFcn(app, @UIFigureWindowKeyPress, true);

            % Create Panel
            app.Panel = uipanel(app.UIFigure);
            app.Panel.Position = [0 0 1280 960];

            % Create GridLayout
            app.GridLayout = uigridlayout(app.Panel);
            app.GridLayout.ColumnWidth = {'1x'};
            app.GridLayout.RowHeight = {'1x', 200};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];

            % Create status
            app.status = uitextarea(app.GridLayout);
            app.status.Layout.Row = 2;
            app.status.Layout.Column = 1;
            app.status.Value = {''; 'WIP Instructions (also check the tooltips!):'; '1. Select files for each subject with the ''add'' button. More subjects can be added with the ''+'' button. '; '    For each subject specify : an ID,  which signals within the file are EEG, and a downsample decimation factor. EMG is optional. '; '    Lastly, click done or switch to the analysis tab.'; '    Specifying treatment times doesn''t do anything in this version, don''t bother with it. '; '2. select a subject and specify the duration of epoch length.'; '    run analysis and assign a state to each cluster that appears. The number of clusters can be manually editted.'; '    rules for the find and replace tool can be edited on the settings tab'; '    thresholds for clusters'' features can be set to mean, median, midrange, or a specific number'; '    the ZC feature stands for ''zero crossings'''; '3. preview the results. each plots can be zoomed/rotated with the controls found by hovering the cursor at the top-right corner of the plot'; '4. Export results to a results file that was created by another program (sleepsign/neuroscore). If a file name matching the corresponding edf/kcd in located in the same directory that will automatically be chosen. Otherwise manually specify a raf/zdb to copy results into. '; ''; 'Please let me know when you find any bugs and how to reproduce them.'};

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout);
            app.TabGroup.SelectionChangedFcn = createCallbackFcn(app, @TabGroupSelectionChanged, true);
            app.TabGroup.Layout.Row = 1;
            app.TabGroup.Layout.Column = 1;

            % Create importTab
            app.importTab = uitab(app.TabGroup);
            app.importTab.Title = 'import';

            % Create importgrid
            app.importgrid = uigridlayout(app.importTab);
            app.importgrid.ColumnWidth = {'1x'};
            app.importgrid.RowHeight = {'1x'};
            app.importgrid.ColumnSpacing = 0;
            app.importgrid.RowSpacing = 0;
            app.importgrid.Padding = [0 0 0 0];

            % Create importPan
            app.importPan = uipanel(app.importgrid);
            app.importPan.AutoResizeChildren = 'off';
            app.importPan.Layout.Row = 1;
            app.importPan.Layout.Column = 1;
            app.importPan.Scrollable = 'on';

            % Create addSubj
            app.addSubj = uibutton(app.importPan, 'push');
            app.addSubj.ButtonPushedFcn = createCallbackFcn(app, @addSubjButtonPushed, true);
            app.addSubj.FontSize = 20;
            app.addSubj.Tooltip = {'add subject'};
            app.addSubj.Position = [615 3 50 50];
            app.addSubj.Text = '+';

            % Create ImportDone
            app.ImportDone = uibutton(app.importPan, 'push');
            app.ImportDone.ButtonPushedFcn = createCallbackFcn(app, @ImportDonePushed, true);
            app.ImportDone.Position = [1144 3 105 50];
            app.ImportDone.Text = 'Done';

            % Create AnalysisTab
            app.AnalysisTab = uitab(app.TabGroup);
            app.AnalysisTab.Title = 'Analysis';

            % Create analysisgrid
            app.analysisgrid = uigridlayout(app.AnalysisTab);
            app.analysisgrid.ColumnWidth = {'1x'};
            app.analysisgrid.RowHeight = {'1x'};
            app.analysisgrid.Padding = [0 0 0 0];

            % Create AnalysisTabGroup
            app.AnalysisTabGroup = uitabgroup(app.analysisgrid);
            app.AnalysisTabGroup.Layout.Row = 1;
            app.AnalysisTabGroup.Layout.Column = 1;

            % Create SettingsTab
            app.SettingsTab = uitab(app.AnalysisTabGroup);
            app.SettingsTab.Title = 'Settings';

            % Create settingsgrid
            app.settingsgrid = uigridlayout(app.SettingsTab);
            app.settingsgrid.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.settingsgrid.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.settingsgrid.ColumnSpacing = 5;
            app.settingsgrid.RowSpacing = 0;
            app.settingsgrid.Padding = [0 0 0 0];

            % Create SaveButton
            app.SaveButton = uibutton(app.settingsgrid, 'push');
            app.SaveButton.ButtonPushedFcn = createCallbackFcn(app, @SaveButtonPushed, true);
            app.SaveButton.Interruptible = 'off';
            app.SaveButton.Tooltip = {'save all settings to text file'};
            app.SaveButton.Layout.Row = 11;
            app.SaveButton.Layout.Column = 8;
            app.SaveButton.Text = 'Save';

            % Create LoadButton
            app.LoadButton = uibutton(app.settingsgrid, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Interruptible = 'off';
            app.LoadButton.Tooltip = {'load settings from text file'};
            app.LoadButton.Layout.Row = 12;
            app.LoadButton.Layout.Column = 8;
            app.LoadButton.Text = 'Load';

            % Create epochfeatures
            app.epochfeatures = uipanel(app.settingsgrid);
            app.epochfeatures.Title = 'epochs'' features setup (input to pca)';
            app.epochfeatures.Layout.Row = [1 5];
            app.epochfeatures.Layout.Column = [1 3];

            % Create epochfeaturesgrid
            app.epochfeaturesgrid = uigridlayout(app.epochfeatures);
            app.epochfeaturesgrid.ColumnWidth = {'1x', '1x', '1x', '1x'};
            app.epochfeaturesgrid.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.epochfeaturesgrid.ColumnSpacing = 5;
            app.epochfeaturesgrid.RowSpacing = 0;
            app.epochfeaturesgrid.Padding = [0 0 0 0];

            % Create bandsperHzEditFieldLabel
            app.bandsperHzEditFieldLabel = uilabel(app.epochfeaturesgrid);
            app.bandsperHzEditFieldLabel.HorizontalAlignment = 'right';
            app.bandsperHzEditFieldLabel.Layout.Row = 2;
            app.bandsperHzEditFieldLabel.Layout.Column = 1;
            app.bandsperHzEditFieldLabel.Text = 'bands per Hz';

            % Create bandsperHz
            app.bandsperHz = uieditfield(app.epochfeaturesgrid, 'numeric');
            app.bandsperHz.Tooltip = {'between 1 and epoch length (s)'; 'specify number of bins/Hz to calculate for FFT'};
            app.bandsperHz.Layout.Row = 2;
            app.bandsperHz.Layout.Column = 2;
            app.bandsperHz.Value = 2;

            % Create includeZC
            app.includeZC = uicheckbox(app.epochfeaturesgrid);
            app.includeZC.Tooltip = {'include zero crossings as one of the features'; 'strongly recomended in the case of bad EMG'};
            app.includeZC.Text = 'include ZC?';
            app.includeZC.Layout.Row = 1;
            app.includeZC.Layout.Column = 4;
            app.includeZC.Value = true;

            % Create minimumexplainedLabel
            app.minimumexplainedLabel = uilabel(app.epochfeaturesgrid);
            app.minimumexplainedLabel.HorizontalAlignment = 'right';
            app.minimumexplainedLabel.Layout.Row = 7;
            app.minimumexplainedLabel.Layout.Column = 1;
            app.minimumexplainedLabel.Text = {'minimum '; '% explained'};

            % Create minimumexplained
            app.minimumexplained = uieditfield(app.epochfeaturesgrid, 'numeric');
            app.minimumexplained.Tooltip = {'use a number of principle components'; 'that are needed to explain n% variance'};
            app.minimumexplained.Layout.Row = 7;
            app.minimumexplained.Layout.Column = 2;
            app.minimumexplained.Value = 95;

            % Create EEGFFTrangeHzEditFieldLabel
            app.EEGFFTrangeHzEditFieldLabel = uilabel(app.epochfeaturesgrid);
            app.EEGFFTrangeHzEditFieldLabel.HorizontalAlignment = 'right';
            app.EEGFFTrangeHzEditFieldLabel.Layout.Row = 3;
            app.EEGFFTrangeHzEditFieldLabel.Layout.Column = 1;
            app.EEGFFTrangeHzEditFieldLabel.Text = {'EEG FFT range'; '(Hz)'};

            % Create eegpsdL
            app.eegpsdL = uieditfield(app.epochfeaturesgrid, 'numeric');
            app.eegpsdL.Layout.Row = 3;
            app.eegpsdL.Layout.Column = 2;
            app.eegpsdL.Value = 1;

            % Create EMGFFTrangeHzEditFieldLabel
            app.EMGFFTrangeHzEditFieldLabel = uilabel(app.epochfeaturesgrid);
            app.EMGFFTrangeHzEditFieldLabel.HorizontalAlignment = 'right';
            app.EMGFFTrangeHzEditFieldLabel.Layout.Row = 4;
            app.EMGFFTrangeHzEditFieldLabel.Layout.Column = 1;
            app.EMGFFTrangeHzEditFieldLabel.Text = {'EMG FFT range'; '(Hz)'};

            % Create emgpsdL
            app.emgpsdL = uieditfield(app.epochfeaturesgrid, 'numeric');
            app.emgpsdL.Layout.Row = 4;
            app.emgpsdL.Layout.Column = 2;
            app.emgpsdL.Value = 80;

            % Create toeegEditFieldLabel
            app.toeegEditFieldLabel = uilabel(app.epochfeaturesgrid);
            app.toeegEditFieldLabel.HorizontalAlignment = 'center';
            app.toeegEditFieldLabel.Layout.Row = 3;
            app.toeegEditFieldLabel.Layout.Column = 3;
            app.toeegEditFieldLabel.Text = 'to eeg';

            % Create eegpsdH
            app.eegpsdH = uieditfield(app.epochfeaturesgrid, 'numeric');
            app.eegpsdH.Layout.Row = 3;
            app.eegpsdH.Layout.Column = 4;
            app.eegpsdH.Value = 30;

            % Create toemgEditFieldLabel
            app.toemgEditFieldLabel = uilabel(app.epochfeaturesgrid);
            app.toemgEditFieldLabel.HorizontalAlignment = 'center';
            app.toemgEditFieldLabel.Layout.Row = 4;
            app.toemgEditFieldLabel.Layout.Column = 3;
            app.toemgEditFieldLabel.Text = 'to emg';

            % Create emgpsdH
            app.emgpsdH = uieditfield(app.epochfeaturesgrid, 'numeric');
            app.emgpsdH.Layout.Row = 4;
            app.emgpsdH.Layout.Column = 4;
            app.emgpsdH.Value = 100;

            % Create outlierremovalmethodDropDownLabel
            app.outlierremovalmethodDropDownLabel = uilabel(app.epochfeaturesgrid);
            app.outlierremovalmethodDropDownLabel.HorizontalAlignment = 'right';
            app.outlierremovalmethodDropDownLabel.Layout.Row = 7;
            app.outlierremovalmethodDropDownLabel.Layout.Column = 3;
            app.outlierremovalmethodDropDownLabel.Text = {'outlier removal '; 'method '};

            % Create outlierremovalmethodDropDown
            app.outlierremovalmethodDropDown = uidropdown(app.epochfeaturesgrid);
            app.outlierremovalmethodDropDown.Items = {'none', 'winsorize', 'replace w/ NaN'};
            app.outlierremovalmethodDropDown.ItemsData = {'0', '1', '2'};
            app.outlierremovalmethodDropDown.Tooltip = {'EXPERIMENTAL!'; 'only use this for exceptionally noisy datasets'};
            app.outlierremovalmethodDropDown.Layout.Row = 7;
            app.outlierremovalmethodDropDown.Layout.Column = 4;
            app.outlierremovalmethodDropDown.Value = '0';

            % Create PCArowsDropDownLabel
            app.PCArowsDropDownLabel = uilabel(app.epochfeaturesgrid);
            app.PCArowsDropDownLabel.HorizontalAlignment = 'right';
            app.PCArowsDropDownLabel.Layout.Row = 6;
            app.PCArowsDropDownLabel.Layout.Column = 1;
            app.PCArowsDropDownLabel.Text = 'PCA rows';

            % Create PCArowsDropDown
            app.PCArowsDropDown = uidropdown(app.epochfeaturesgrid);
            app.PCArowsDropDown.Items = {'complete', 'pairwise'};
            app.PCArowsDropDown.ItemsData = {'0', '1'};
            app.PCArowsDropDown.Tooltip = {'https://www.mathworks.com/help/stats/pca.html#bth9ibe-Rows'};
            app.PCArowsDropDown.Layout.Row = 6;
            app.PCArowsDropDown.Layout.Column = 2;
            app.PCArowsDropDown.Value = '1';

            % Create epochlengthsecEditFieldLabel
            app.epochlengthsecEditFieldLabel = uilabel(app.epochfeaturesgrid);
            app.epochlengthsecEditFieldLabel.HorizontalAlignment = 'right';
            app.epochlengthsecEditFieldLabel.Layout.Row = 1;
            app.epochlengthsecEditFieldLabel.Layout.Column = 1;
            app.epochlengthsecEditFieldLabel.Text = {'epoch length'; '(sec)'};

            % Create epochlength
            app.epochlength = uieditfield(app.epochfeaturesgrid, 'numeric');
            app.epochlength.Limits = [1 300];
            app.epochlength.RoundFractionalValues = 'on';
            app.epochlength.Layout.Row = 1;
            app.epochlength.Layout.Column = 2;
            app.epochlength.Value = 10;

            % Create findandreplace
            app.findandreplace = uipanel(app.settingsgrid);
            app.findandreplace.Title = 'rules for find & replace';
            app.findandreplace.Layout.Row = [2 9];
            app.findandreplace.Layout.Column = [7 8];

            % Create findandreplacegrid
            app.findandreplacegrid = uigridlayout(app.findandreplace);
            app.findandreplacegrid.ColumnWidth = {'1x'};
            app.findandreplacegrid.RowHeight = {'1x'};
            app.findandreplacegrid.ColumnSpacing = 0;
            app.findandreplacegrid.RowSpacing = 0;
            app.findandreplacegrid.Padding = [0 0 0 0];

            % Create rules
            app.rules = uitable(app.findandreplacegrid);
            app.rules.ColumnName = {'find'; 'replace'; '+'; '-'};
            app.rules.ColumnWidth = {'auto', 'auto', 25, 25};
            app.rules.RowName = {''};
            app.rules.ColumnEditable = true;
            app.rules.CellEditCallback = createCallbackFcn(app, @rulesCellEdit, true);
            app.rules.Interruptible = 'off';
            app.rules.Layout.Row = 1;
            app.rules.Layout.Column = 1;

            % Create clusters
            app.clusters = uipanel(app.settingsgrid);
            app.clusters.Title = 'hierarchical clustering setup';
            app.clusters.Layout.Row = [6 7];
            app.clusters.Layout.Column = [1 3];

            % Create clustersgrid
            app.clustersgrid = uigridlayout(app.clusters);
            app.clustersgrid.RowHeight = {'1x', '1x', '1x'};
            app.clustersgrid.ColumnSpacing = 5;
            app.clustersgrid.RowSpacing = 0;
            app.clustersgrid.Padding = [0 0 0 0];

            % Create pdistmethodDropDownLabel
            app.pdistmethodDropDownLabel = uilabel(app.clustersgrid);
            app.pdistmethodDropDownLabel.HorizontalAlignment = 'right';
            app.pdistmethodDropDownLabel.Layout.Row = 1;
            app.pdistmethodDropDownLabel.Layout.Column = 1;
            app.pdistmethodDropDownLabel.Text = 'pdist method';

            % Create pdistmethodDropDown
            app.pdistmethodDropDown = uidropdown(app.clustersgrid);
            app.pdistmethodDropDown.Items = {'euclidean', 'squaredeuclidean', 'seuclidean', 'mahalanobis', 'cityblock', 'minkowski', 'chebychev', 'cosine', 'correlation', 'hamming', 'jaccard', 'spearman'};
            app.pdistmethodDropDown.Tooltip = {'https://www.mathworks.com/help/stats/pdist.html#mw_39296772-30a1-45f3-a296-653c38875df7'};
            app.pdistmethodDropDown.Layout.Row = 1;
            app.pdistmethodDropDown.Layout.Column = 2;
            app.pdistmethodDropDown.Value = 'seuclidean';

            % Create linkagemethodDropDownLabel
            app.linkagemethodDropDownLabel = uilabel(app.clustersgrid);
            app.linkagemethodDropDownLabel.HorizontalAlignment = 'right';
            app.linkagemethodDropDownLabel.Layout.Row = 2;
            app.linkagemethodDropDownLabel.Layout.Column = 1;
            app.linkagemethodDropDownLabel.Text = 'linkage method';

            % Create linkagemethodDropDown
            app.linkagemethodDropDown = uidropdown(app.clustersgrid);
            app.linkagemethodDropDown.Items = {'average', 'centroid', 'complete', 'median', 'single', 'ward', 'weighted'};
            app.linkagemethodDropDown.Tooltip = {'https://www.mathworks.com/help/stats/linkage.html#mw_59e9693d-3784-4a0d-89dd-5dd020a605b2'};
            app.linkagemethodDropDown.Layout.Row = 2;
            app.linkagemethodDropDown.Layout.Column = 2;
            app.linkagemethodDropDown.Value = 'average';

            % Create clusterfeatures
            app.clusterfeatures = uipanel(app.settingsgrid);
            app.clusterfeatures.Title = 'clusters'' features setup';
            app.clusterfeatures.Layout.Row = [8 13];
            app.clusterfeatures.Layout.Column = [1 3];

            % Create clusterfeaturesgrid
            app.clusterfeaturesgrid = uigridlayout(app.clusterfeatures);
            app.clusterfeaturesgrid.ColumnWidth = {'1x'};
            app.clusterfeaturesgrid.RowHeight = {'1x'};
            app.clusterfeaturesgrid.ColumnSpacing = 5;
            app.clusterfeaturesgrid.RowSpacing = 0;
            app.clusterfeaturesgrid.Padding = [0 0 0 0];

            % Create clustersfeaturestable
            app.clustersfeaturestable = uitable(app.clusterfeaturesgrid);
            app.clustersfeaturestable.ColumnName = {'label'; 'source'; 'range'; 'threshold'; '+'; '-'};
            app.clustersfeaturestable.ColumnWidth = {'auto', 'auto', 'auto', 'auto', 25, 25};
            app.clustersfeaturestable.RowName = {};
            app.clustersfeaturestable.ColumnEditable = true;
            app.clustersfeaturestable.CellEditCallback = createCallbackFcn(app, @clustersfeaturestableCellEdit, true);
            app.clustersfeaturestable.Interruptible = 'off';
            app.clustersfeaturestable.Layout.Row = 1;
            app.clustersfeaturestable.Layout.Column = 1;

            % Create StateLabelsPanel
            app.StateLabelsPanel = uipanel(app.settingsgrid);
            app.StateLabelsPanel.Title = 'State Labels';
            app.StateLabelsPanel.Layout.Row = [10 12];
            app.StateLabelsPanel.Layout.Column = 7;

            % Create statelabelsgrid
            app.statelabelsgrid = uigridlayout(app.StateLabelsPanel);
            app.statelabelsgrid.ColumnWidth = {'1x'};
            app.statelabelsgrid.RowHeight = {'1x'};
            app.statelabelsgrid.ColumnSpacing = 0;
            app.statelabelsgrid.RowSpacing = 0;
            app.statelabelsgrid.Padding = [0 0 0 0];

            % Create statelabelstable
            app.statelabelstable = uitable(app.statelabelsgrid);
            app.statelabelstable.ColumnName = {'state'; '+'; '-'};
            app.statelabelstable.ColumnWidth = {'auto', 25, 25};
            app.statelabelstable.RowName = {};
            app.statelabelstable.ColumnEditable = true;
            app.statelabelstable.CellEditCallback = createCallbackFcn(app, @statelabelstableCellEdit, true);
            app.statelabelstable.Interruptible = 'off';
            app.statelabelstable.Layout.Row = 1;
            app.statelabelstable.Layout.Column = 1;

            % Create autoscoringtruthtablePanel
            app.autoscoringtruthtablePanel = uipanel(app.settingsgrid);
            app.autoscoringtruthtablePanel.Title = 'autoscoring truthtable';
            app.autoscoringtruthtablePanel.Layout.Row = [2 12];
            app.autoscoringtruthtablePanel.Layout.Column = [5 6];

            % Create truthtablegrid
            app.truthtablegrid = uigridlayout(app.autoscoringtruthtablePanel);
            app.truthtablegrid.ColumnWidth = {'1x'};
            app.truthtablegrid.RowHeight = {'1x'};
            app.truthtablegrid.ColumnSpacing = 0;
            app.truthtablegrid.RowSpacing = 0;
            app.truthtablegrid.Padding = [0 0 0 0];

            % Create truthtable
            app.truthtable = uitable(app.truthtablegrid);
            app.truthtable.ColumnName = {'state'};
            app.truthtable.RowName = {};
            app.truthtable.Interruptible = 'off';
            app.truthtable.Layout.Row = 1;
            app.truthtable.Layout.Column = 1;

            % Create ScoreTab
            app.ScoreTab = uitab(app.AnalysisTabGroup);
            app.ScoreTab.Title = 'Score';

            % Create scoregrid
            app.scoregrid = uigridlayout(app.ScoreTab);
            app.scoregrid.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.scoregrid.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.scoregrid.ColumnSpacing = 5;
            app.scoregrid.RowSpacing = 0;
            app.scoregrid.Padding = [0 0 0 0];

            % Create Features
            app.Features = uiaxes(app.scoregrid);
            title(app.Features, 'Features')
            xlabel(app.Features, 'PC1')
            ylabel(app.Features, 'PC2')
            app.Features.PlotBoxAspectRatio = [1.45252525252525 1 1];
            app.Features.FontSize = 10;
            app.Features.Projection = 'perspective';
            app.Features.TitleFontSizeMultiplier = 1.2;
            app.Features.TitleFontWeight = 'normal';
            app.Features.Layout.Row = [1 15];
            app.Features.Layout.Column = [6 10];

            % Create runanalysisButton
            app.runanalysisButton = uibutton(app.scoregrid, 'push');
            app.runanalysisButton.ButtonPushedFcn = createCallbackFcn(app, @runanalysisButtonPushed, true);
            app.runanalysisButton.Interruptible = 'off';
            app.runanalysisButton.Tooltip = {''};
            app.runanalysisButton.Layout.Row = [6 7];
            app.runanalysisButton.Layout.Column = 1;
            app.runanalysisButton.Text = '1. run analysis';

            % Create ApplyFindandReplaceRulesButton
            app.ApplyFindandReplaceRulesButton = uibutton(app.scoregrid, 'push');
            app.ApplyFindandReplaceRulesButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyFindandReplaceRulesButtonPushed, true);
            app.ApplyFindandReplaceRulesButton.Interruptible = 'off';
            app.ApplyFindandReplaceRulesButton.Tooltip = {''};
            app.ApplyFindandReplaceRulesButton.Layout.Row = [14 15];
            app.ApplyFindandReplaceRulesButton.Layout.Column = 1;
            app.ApplyFindandReplaceRulesButton.Text = {'3. Apply Find and'; 'Replace Rules'};

            % Create clusterdetails
            app.clusterdetails = uitable(app.scoregrid);
            app.clusterdetails.ColumnName = {'cluster'; 'show'; 'state'; 'epochs'};
            app.clusterdetails.ColumnWidth = {50, 35, 'auto', 50};
            app.clusterdetails.RowName = {};
            app.clusterdetails.ColumnEditable = [false true true false];
            app.clusterdetails.CellEditCallback = createCallbackFcn(app, @clusterdetailsCellEdit, true);
            app.clusterdetails.Layout.Row = [1 15];
            app.clusterdetails.Layout.Column = [2 4];

            % Create BatchModeCheckBox
            app.BatchModeCheckBox = uicheckbox(app.scoregrid);
            app.BatchModeCheckBox.Interruptible = 'off';
            app.BatchModeCheckBox.Tooltip = {'run analysis steps on all subjects'; 'don''t use this if any subjects have different epoch lengths'};
            app.BatchModeCheckBox.Text = 'Batch Mode';
            app.BatchModeCheckBox.Layout.Row = 4;
            app.BatchModeCheckBox.Layout.Column = 1;

            % Create redoclustersButton
            app.redoclustersButton = uibutton(app.scoregrid, 'push');
            app.redoclustersButton.ButtonPushedFcn = createCallbackFcn(app, @redoclustersButtonPushed, true);
            app.redoclustersButton.Interruptible = 'off';
            app.redoclustersButton.Layout.Row = [11 12];
            app.redoclustersButton.Layout.Column = 1;
            app.redoclustersButton.Text = '2. redo clusters';

            % Create previewpanel
            app.previewpanel = uipanel(app.scoregrid);
            app.previewpanel.Title = 'preview';
            app.previewpanel.Layout.Row = [16 35];
            app.previewpanel.Layout.Column = [1 10];

            % Create previewgrid
            app.previewgrid = uigridlayout(app.previewpanel);
            app.previewgrid.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.previewgrid.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.previewgrid.ColumnSpacing = 5;
            app.previewgrid.RowSpacing = 0;
            app.previewgrid.Padding = [0 0 0 0];

            % Create rawdatapan
            app.rawdatapan = uipanel(app.previewgrid);
            app.rawdatapan.Layout.Row = [4 18];
            app.rawdatapan.Layout.Column = [1 11];

            % Create rawdatagrid
            app.rawdatagrid = uigridlayout(app.rawdatapan);
            app.rawdatagrid.ColumnWidth = {'1x'};
            app.rawdatagrid.RowHeight = {'2x', '2x', '2x', '1x'};
            app.rawdatagrid.ColumnSpacing = 0;
            app.rawdatagrid.RowSpacing = 5;
            app.rawdatagrid.Padding = [0 0 0 0];

            % Create WindowepochsEditFieldLabel
            app.WindowepochsEditFieldLabel = uilabel(app.previewgrid);
            app.WindowepochsEditFieldLabel.HorizontalAlignment = 'right';
            app.WindowepochsEditFieldLabel.Layout.Row = 1;
            app.WindowepochsEditFieldLabel.Layout.Column = 3;
            app.WindowepochsEditFieldLabel.Text = 'Window (epochs)';

            % Create EpochWindow
            app.EpochWindow = uieditfield(app.previewgrid, 'numeric');
            app.EpochWindow.Limits = [0 Inf];
            app.EpochWindow.ValueChangedFcn = createCallbackFcn(app, @EpochWindowValueChanged, true);
            app.EpochWindow.Interruptible = 'off';
            app.EpochWindow.Layout.Row = 1;
            app.EpochWindow.Layout.Column = 4;
            app.EpochWindow.Value = 30;

            % Create EpochNoSliderLabel
            app.EpochNoSliderLabel = uilabel(app.previewgrid);
            app.EpochNoSliderLabel.HorizontalAlignment = 'right';
            app.EpochNoSliderLabel.Layout.Row = 2;
            app.EpochNoSliderLabel.Layout.Column = 3;
            app.EpochNoSliderLabel.Text = 'Epoch No.';

            % Create EpochNoSlider
            app.EpochNoSlider = uislider(app.previewgrid);
            app.EpochNoSlider.Limits = [1 1000];
            app.EpochNoSlider.MajorTicks = [];
            app.EpochNoSlider.MajorTickLabels = {};
            app.EpochNoSlider.ValueChangedFcn = createCallbackFcn(app, @EpochNoSliderValueChanged, true);
            app.EpochNoSlider.MinorTicks = [];
            app.EpochNoSlider.Interruptible = 'off';
            app.EpochNoSlider.Layout.Row = 1;
            app.EpochNoSlider.Layout.Column = [5 11];
            app.EpochNoSlider.Value = 1;

            % Create scoreplot
            app.scoreplot = uiaxes(app.previewgrid);
            title(app.scoreplot, '')
            xlabel(app.scoreplot, '')
            ylabel(app.scoreplot, '')
            app.scoreplot.FontSize = 1;
            app.scoreplot.XTick = [];
            app.scoreplot.YTick = [];
            app.scoreplot.LabelFontSizeMultiplier = 0.1;
            app.scoreplot.TitleFontSizeMultiplier = 0.1;
            app.scoreplot.Layout.Row = [2 3];
            app.scoreplot.Layout.Column = [5 11];

            % Create EpochNo
            app.EpochNo = uieditfield(app.previewgrid, 'numeric');
            app.EpochNo.Limits = [1 Inf];
            app.EpochNo.ValueDisplayFormat = '%d';
            app.EpochNo.ValueChangedFcn = createCallbackFcn(app, @EpochNoValueChanged, true);
            app.EpochNo.Interruptible = 'off';
            app.EpochNo.Layout.Row = 2;
            app.EpochNo.Layout.Column = 4;
            app.EpochNo.Value = 1;

            % Create EpochNoTimestamp
            app.EpochNoTimestamp = uieditfield(app.previewgrid, 'text');
            app.EpochNoTimestamp.ValueChangedFcn = createCallbackFcn(app, @EpochNoTimestampValueChanged, true);
            app.EpochNoTimestamp.Interruptible = 'off';
            app.EpochNoTimestamp.Layout.Row = 3;
            app.EpochNoTimestamp.Layout.Column = [3 4];

            % Create windowL
            app.windowL = uibutton(app.previewgrid, 'push');
            app.windowL.ButtonPushedFcn = createCallbackFcn(app, @windowLPushed, true);
            app.windowL.Interruptible = 'off';
            app.windowL.Tooltip = {'previous window'; 'ctrl+left arrow'};
            app.windowL.Layout.Row = 3;
            app.windowL.Layout.Column = 1;
            app.windowL.Text = '🠘';

            % Create windowR
            app.windowR = uibutton(app.previewgrid, 'push');
            app.windowR.ButtonPushedFcn = createCallbackFcn(app, @windowRPushed, true);
            app.windowR.Interruptible = 'off';
            app.windowR.Tooltip = {'next window'; 'ctrl+right arrow'};
            app.windowR.Layout.Row = 3;
            app.windowR.Layout.Column = 2;
            app.windowR.Text = '🠚';

            % Create manualeditDropDownLabel
            app.manualeditDropDownLabel = uilabel(app.previewgrid);
            app.manualeditDropDownLabel.HorizontalAlignment = 'right';
            app.manualeditDropDownLabel.Layout.Row = 1;
            app.manualeditDropDownLabel.Layout.Column = 1;
            app.manualeditDropDownLabel.Text = 'manual edit:';

            % Create manualeditDropDown
            app.manualeditDropDown = uidropdown(app.previewgrid);
            app.manualeditDropDown.Items = {'?', 'W', 'NR', 'R'};
            app.manualeditDropDown.Interruptible = 'off';
            app.manualeditDropDown.Tooltip = {'will rescore to this state'; 'when spacebar is pressed'; 'edit with up&down arrow'};
            app.manualeditDropDown.Layout.Row = 1;
            app.manualeditDropDown.Layout.Column = 2;
            app.manualeditDropDown.Value = '?';

            % Create manualeditwindowEditFieldLabel
            app.manualeditwindowEditFieldLabel = uilabel(app.previewgrid);
            app.manualeditwindowEditFieldLabel.HorizontalAlignment = 'right';
            app.manualeditwindowEditFieldLabel.Layout.Row = 2;
            app.manualeditwindowEditFieldLabel.Layout.Column = 1;
            app.manualeditwindowEditFieldLabel.Text = 'manual edit window';

            % Create manualeditwindowEditField
            app.manualeditwindowEditField = uieditfield(app.previewgrid, 'numeric');
            app.manualeditwindowEditField.Limits = [1 Inf];
            app.manualeditwindowEditField.ValueChangedFcn = createCallbackFcn(app, @manualeditwindowEditFieldValueChanged, true);
            app.manualeditwindowEditField.Interruptible = 'off';
            app.manualeditwindowEditField.Tooltip = {'this many epochs will be'; 'edited when spacebar is pressed'; 'edit with ctrl+up|down'};
            app.manualeditwindowEditField.Layout.Row = 2;
            app.manualeditwindowEditField.Layout.Column = 2;
            app.manualeditwindowEditField.Value = 1;

            % Create IDDropDownLabel
            app.IDDropDownLabel = uilabel(app.scoregrid);
            app.IDDropDownLabel.Layout.Row = 1;
            app.IDDropDownLabel.Layout.Column = 1;
            app.IDDropDownLabel.Text = 'Subj ID';

            % Create ID
            app.ID = uidropdown(app.scoregrid);
            app.ID.Items = {};
            app.ID.ValueChangedFcn = createCallbackFcn(app, @IDValueChanged, true);
            app.ID.Interruptible = 'off';
            app.ID.Tooltip = {'Which subject to preview/run analysis on'};
            app.ID.Layout.Row = [2 3];
            app.ID.Layout.Column = 1;
            app.ID.Value = {};

            % Create numberofclustersLabel
            app.numberofclustersLabel = uilabel(app.scoregrid);
            app.numberofclustersLabel.HorizontalAlignment = 'center';
            app.numberofclustersLabel.Layout.Row = 9;
            app.numberofclustersLabel.Layout.Column = 1;
            app.numberofclustersLabel.Text = 'number of clusters:';

            % Create numclusters
            app.numclusters = uieditfield(app.scoregrid, 'numeric');
            app.numclusters.Limits = [0 Inf];
            app.numclusters.Interruptible = 'off';
            app.numclusters.Tooltip = {'if input is 0 or 1'; 'variance ratio criterion'; 'will be used to pick an'; 'optimal number'; 'https://www.mathworks.com/help/stats/clustering.evaluation.calinskiharabaszevaluation-class.html'};
            app.numclusters.Layout.Row = 10;
            app.numclusters.Layout.Column = 1;

            % Create highlightepochsinmanualeditwindowCheckBox
            app.highlightepochsinmanualeditwindowCheckBox = uicheckbox(app.scoregrid);
            app.highlightepochsinmanualeditwindowCheckBox.ValueChangedFcn = createCallbackFcn(app, @highlightepochsinmanualeditwindowCheckBoxValueChanged, true);
            app.highlightepochsinmanualeditwindowCheckBox.Interruptible = 'off';
            app.highlightepochsinmanualeditwindowCheckBox.Text = {'highlight epochs'; 'in manual edit '; 'window'};
            app.highlightepochsinmanualeditwindowCheckBox.Layout.Row = [13 14];
            app.highlightepochsinmanualeditwindowCheckBox.Layout.Column = 5;

            % Create changeshow
            app.changeshow = uidropdown(app.scoregrid);
            app.changeshow.Items = {'score', 'clusters'};
            app.changeshow.ValueChangedFcn = createCallbackFcn(app, @changeshowValueChanged, true);
            app.changeshow.Interruptible = 'off';
            app.changeshow.Layout.Row = [6 7];
            app.changeshow.Layout.Column = 5;
            app.changeshow.Value = 'score';

            % Create showLabel
            app.showLabel = uilabel(app.scoregrid);
            app.showLabel.HorizontalAlignment = 'center';
            app.showLabel.Layout.Row = 5;
            app.showLabel.Layout.Column = 5;
            app.showLabel.Text = 'show';

            % Create disable3dplotButton
            app.disable3dplotButton = uibutton(app.scoregrid, 'state');
            app.disable3dplotButton.ValueChangedFcn = createCallbackFcn(app, @disable3dplotButtonValueChanged, true);
            app.disable3dplotButton.Interruptible = 'off';
            app.disable3dplotButton.Tooltip = {'disabling the 3d plot'; 'may improve the apps'''; 'responsiveness'};
            app.disable3dplotButton.Text = {'disable'; '3d plot'};
            app.disable3dplotButton.Layout.Row = [2 3];
            app.disable3dplotButton.Layout.Column = 5;

            % Create onlyplotepochsinpreviewwindowCheckBox
            app.onlyplotepochsinpreviewwindowCheckBox = uicheckbox(app.scoregrid);
            app.onlyplotepochsinpreviewwindowCheckBox.ValueChangedFcn = createCallbackFcn(app, @changeshowValueChanged, true);
            app.onlyplotepochsinpreviewwindowCheckBox.Interruptible = 'off';
            app.onlyplotepochsinpreviewwindowCheckBox.Text = {'only plot epochs'; 'in preview window'};
            app.onlyplotepochsinpreviewwindowCheckBox.Layout.Row = [10 11];
            app.onlyplotepochsinpreviewwindowCheckBox.Layout.Column = 5;
            app.onlyplotepochsinpreviewwindowCheckBox.Value = true;

            % Create ExportTab
            app.ExportTab = uitab(app.TabGroup);
            app.ExportTab.Title = 'Export';

            % Create exportgrid
            app.exportgrid = uigridlayout(app.ExportTab);
            app.exportgrid.ColumnWidth = {'1x'};
            app.exportgrid.RowHeight = {'1x'};
            app.exportgrid.ColumnSpacing = 0;
            app.exportgrid.RowSpacing = 0;
            app.exportgrid.Padding = [0 0 0 0];

            % Create ExportTabGroup
            app.ExportTabGroup = uitabgroup(app.exportgrid);
            app.ExportTabGroup.Layout.Row = 1;
            app.ExportTabGroup.Layout.Column = 1;

            % Create resultsfilesTab
            app.resultsfilesTab = uitab(app.ExportTabGroup);
            app.resultsfilesTab.Title = 'results file(s)';

            % Create resultsfilegrid
            app.resultsfilegrid = uigridlayout(app.resultsfilesTab);
            app.resultsfilegrid.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x'};
            app.resultsfilegrid.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.resultsfilegrid.ColumnSpacing = 5;
            app.resultsfilegrid.RowSpacing = 0;
            app.resultsfilegrid.Padding = [0 0 0 0];

            % Create ExportTable
            app.ExportTable = uitable(app.resultsfilegrid);
            app.ExportTable.ColumnName = {'export'; 'Data Path'; 'Data File'; 'Results File'};
            app.ExportTable.ColumnWidth = {40, 100, 300, 'auto'};
            app.ExportTable.RowName = {};
            app.ExportTable.ColumnEditable = [true false false true];
            app.ExportTable.CellSelectionCallback = createCallbackFcn(app, @ExportTableCellSelection, true);
            app.ExportTable.Layout.Row = [1 12];
            app.ExportTable.Layout.Column = [1 4];

            % Create ExportDone
            app.ExportDone = uibutton(app.resultsfilegrid, 'push');
            app.ExportDone.ButtonPushedFcn = createCallbackFcn(app, @ExportDoneButtonPushed, true);
            app.ExportDone.Interruptible = 'off';
            app.ExportDone.Layout.Row = 11;
            app.ExportDone.Layout.Column = 6;
            app.ExportDone.Text = 'Done';

            % Create CompareCheckBox
            app.CompareCheckBox = uicheckbox(app.resultsfilegrid);
            app.CompareCheckBox.Interruptible = 'off';
            app.CompareCheckBox.Enable = 'off';
            app.CompareCheckBox.Tooltip = {'Create excel file that compares results with scoring in the original file'};
            app.CompareCheckBox.Text = 'Compare?';
            app.CompareCheckBox.Layout.Row = 10;
            app.CompareCheckBox.Layout.Column = 6;

            % Create outputfilesuffixEditField
            app.outputfilesuffixEditField = uieditfield(app.resultsfilegrid, 'text');
            app.outputfilesuffixEditField.Tooltip = {'this string will be appended to each data file''s name to create the names of new files'};
            app.outputfilesuffixEditField.Layout.Row = 9;
            app.outputfilesuffixEditField.Layout.Column = 6;
            app.outputfilesuffixEditField.Value = '_beta';

            % Create outputfilesuffixLabel
            app.outputfilesuffixLabel = uilabel(app.resultsfilegrid);
            app.outputfilesuffixLabel.HorizontalAlignment = 'right';
            app.outputfilesuffixLabel.Layout.Row = 9;
            app.outputfilesuffixLabel.Layout.Column = 5;
            app.outputfilesuffixLabel.Text = {'output'; 'file suffix'};

            % Create rosettaStone
            app.rosettaStone = uitable(app.resultsfilegrid);
            app.rosettaStone.ColumnName = {'default'; '.raf'; '.zdb'};
            app.rosettaStone.RowName = {};
            app.rosettaStone.ColumnEditable = [false true true];
            app.rosettaStone.Layout.Row = [2 6];
            app.rosettaStone.Layout.Column = [5 6];

            % Create WhattowritetotheresultsfileLabel
            app.WhattowritetotheresultsfileLabel = uilabel(app.resultsfilegrid);
            app.WhattowritetotheresultsfileLabel.Layout.Row = 1;
            app.WhattowritetotheresultsfileLabel.Layout.Column = 5;
            app.WhattowritetotheresultsfileLabel.Text = 'What to write to the results file:';

            % Create FFTavgstateTab
            app.FFTavgstateTab = uitab(app.ExportTabGroup);
            app.FFTavgstateTab.Title = 'FFT avg/state';

            % Create FFTavgstateGrid
            app.FFTavgstateGrid = uigridlayout(app.FFTavgstateTab);
            app.FFTavgstateGrid.ColumnWidth = {'1x', '1x', '1x'};
            app.FFTavgstateGrid.RowHeight = {'1x', '1x', '1x'};

            % Create FFTavgstateTabGroup
            app.FFTavgstateTabGroup = uitabgroup(app.FFTavgstateGrid);
            app.FFTavgstateTabGroup.Layout.Row = [1 3];
            app.FFTavgstateTabGroup.Layout.Column = [1 3];

            % Create Tab
            app.Tab = uitab(app.FFTavgstateTabGroup);
            app.Tab.Title = 'Tab';

            % Create Tab2
            app.Tab2 = uitab(app.FFTavgstateTabGroup);
            app.Tab2.Title = 'Tab2';

            % Create WIPTab
            app.WIPTab = uitab(app.ExportTabGroup);
            app.WIPTab.Title = 'WIP';

            % Create plaintextButton
            app.plaintextButton = uibutton(app.WIPTab, 'push');
            app.plaintextButton.ButtonPushedFcn = createCallbackFcn(app, @plaintextButtonPushed, true);
            app.plaintextButton.Enable = 'off';
            app.plaintextButton.Tooltip = {'save scoring results'; 'to txt file'};
            app.plaintextButton.Position = [233 401 100 68];
            app.plaintextButton.Text = 'plain text';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = sleepscoringassist_beta6

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end