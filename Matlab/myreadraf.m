%description:
%this function will prompt for the selection of raf files
%the output structure will have 3 fields
%1: score, where (usually)  0=unscored,1=wake,2=rem,3=sleep,7=M,21=wake artifact,22=rem artifact, 23=sleep artifact
%   The correlation of number to state depends on sleepsign settings, so this may need to be double checked
%2: el, epoch length in seconds
%3: ts, timestamp (if one is found, sometimes it's missing. in these case I use the edf/raf file)

function data = myreadraf()

% select raf files
[f,p]=uigetfile('*.raf','multiselect','on');
if ~iscell(f), f={f}; end

data=struct;

% read raf files
    for i=1:length(f)
        
        file=[p,f{i}];
        data(i).file=file;
        fid=fopen(file,'r+');
        temp=fread(fid,2^16,'uint16');
        frewind(fid);
        idx=[4577,4833,6633]; %possible locations for where the scoring in the file starts (this changes depending on user settings within sleepsign. these are the 3 that I have found. there may be more) 
        idx2=idx(temp(idx)>0);
        if isempty(idx2) || length(idx2)>1
            disp(['error: not sure where the scoring starts in ',file,'... send it to daniel']); fclose(fid); break;
        end
        ne=temp(idx2)+temp(idx2+1)*2^16;%number of epochs in file
        fseek(fid,(idx2+1)*2,-1);%seek to where the scoring starts
        data(i).score=fread(fid,ne,'uint8',187); %sleep score: 0=unscored,1=wake,2=rem,3=sleep,
        data(i).el=temp(747); %epoch length
        frewind(fid);
        temp=fread(fid,2^16,'uint8=>char');
        fclose(fid);
        test=strfind(temp','Start time');
        if ~isempty(test)
            data(i).ts=strsplit(temp(test:test+48)',char(0));%timestamp
            data(i).ts=data(i).ts{2};
        else
            data(i).ts='not found';
        end

    end

end

%% 