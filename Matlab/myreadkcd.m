%description:
%this function will prompt for the selection of kcd files
%the output structure will have 2 fields
%1: signal, matrix containing a signal in each column
%2: header, an 1x8 cell array containing:
%   [version?, filetype?, ???, number of signals, duration in seconds, sampling frequency, ???, start time]

function data = myreadkcd()

% select edf files
[f,p]=uigetfile('*.kcd','multiselect','on');
if ~iscell(f), f={f}; end

%       [version?, filetype?,   ???,   num sigs, seconds,   fs,    ???,  start time]
kcdSize=[10     ,           14,     22,       1,       1,       1,     10,     6];
kcdForm={'uint8','uint8=>char','uint8','uint16','uint32','double','uint8','uint16'};

data=struct;

%read the files
    for i=1:length(f)

        head=cell(1,8);
        fid=fopen([p,f{i}]);
        for ii=1:8
            head{ii}=fread(fid,kcdSize(ii),kcdForm{ii});
        end
        n=floor(head{5}*head{4}*2); %bytes of data to read
        fseek(fid,-n,'eof');
        [temp,count]=fread(fid,n,'uint16=>single');
        fclose(fid);

        temp=(reshape(temp,head{4},[])'+32767)/(2^16-1).*10-10; %
        
        data(i).header=head;
        data(i).signal=temp;

    end

end
