

function data = myreadkcd()

[f,p]=uigetfile('*.kcd','multiselect','on');

%%
kcdSize=[10     ,           14,     22,       1,       1,       1,     10,     6];
kcdForm={'uint8','uint8=>char','uint8','uint16','uint32','double','uint8','uint16'};

data=struct;

    for i=1:length(f)

        head=cell(1,8);
        fid=fopen([p,f{i}]);
        for ii=1:8
            head{ii}=fread(fid,kcdSize(ii),kcdForm{ii});
        end
        n=floor(head{5}*head{4}*2);
        fseek(fid,-n,'eof');
        [temp,count]=fread(fid,n,'uint16=>single');
        fclose(fid);

        temp=(reshape(temp,3,[])'+32767)/(2^16-1).*10-10;
        
        data(i).header=head;
        data(i).signal=temp;

    end

end