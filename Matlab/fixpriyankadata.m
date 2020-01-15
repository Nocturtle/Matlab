
%% 
[files,path] = uigetfile('*.csv','multiselect','on');
if ~iscell(files), files={files}; end
day={};
trial=[];
for i=1:length(files)
    temp=strsplit(files{i},{'_','-'});
    day(i)=temp(2);
%     trial(i)=str2num(temp{2});
end

[days,~,indx]=unique(day);

%%
xl = actxserver('Excel.Application');
%
fig=figure;
set(fig,'position',[100 100 800 600]);
figpath=[pwd,'\temp.svg'];
figpath2=[pwd,'\temp2.svg'];
%%
for i=1:length(days)
xlWB=xl.Workbooks.Add;
xlSS=xlWB.Sheets;
    %
    %get all trials for 1 day
    ff=files(indx==i);
    data={};
    EE={};
    head={};
    ratio=[];
    subjs=cell(length(ff),1);
    trials=cell(length(ff),1);
    pointsreplaced=cell(length(ff),1);
    for ii=1:length(ff)
        file=[path,ff{ii}];

        fid=fopen(file);
        head{ii}=textscan(fid, '%[^\n\r]', 6, 'WhiteSpace', '', 'ReturnOnError', false);
        formatSpec = '%*s%f%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';
        r = textscan(fid, formatSpec, 1, 'Delimiter', ',', 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
        formatSpec = '%f%f%f%f%f%*s%*s%*s%*s%[^\n\r]';
        textscan(fid, '%[^\n\r]', 1, 'WhiteSpace', '', 'ReturnOnError', false);
        temp = textscan(fid, formatSpec, inf, 'Delimiter', ',', 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
        fclose(fid);
        ratio(ii)=r{1};
        ee=strsplit(head{ii}{end}{end},',');
        EE{ii}=ee{end};
        
        data{ii}=cat(2,temp{1:end-1});
    end
    
    head=cat(1,head{:});
    %
    temp=cat(1,data{:});
    Xd=(max(temp(:,2))-min(temp(:,2)))/2+min(temp(:,2)); %midrange of all x-coord for that day
    Yd=(max(temp(:,3))-min(temp(:,3)))/2+min(temp(:,3)); %midrange of all y-coord for that day

    entrylabel='ABCD';
    entryscale=[0,1;1,0;0,-1;-1,0];
    exitscale = cat(3,[-.5,-1.25; 0,-1.5; .5,-1.25],...
                    [-1.25,.5; -1.5,0; -1.25,-.5],...
                    [.5,1.25; 0,1.5; -.5,1.25],...
                    [1.25,-.5; 1.5,0; 1.25,.5]);
    %
    huh=zeros(length(ff),1);%5);
    for ii=1:length(ff)
        XX=[];YY=[];
        dat=data{ii}(:,1:3);
        erad=5*ratio(ii);
        prad=45.72*ratio(ii);          %plat radius 45.72
        c2ed=40.72*ratio(ii);%center to entry distance
        Cc=[Xd,Yd];%center coordinates?
        Ci=Cc+c2ed.*entryscale(entrylabel==EE{ii}(1),:);%entry coordinates
        Co=Ci+c2ed.*exitscale(str2double(EE{ii}(2)),:,entrylabel==EE{ii}(1));%exit coordinates

        idx=false(size(dat,1));
        bak=true(size(dat,1));
        while sum(bak==idx)~=size(dat,1)
            bak=idx;
            test=sqrt(sum((dat(:,2:3)-Cc).^2,2));
            delta=sqrt(sum((dat(2:end,2:3)-dat(1:end-1,2:3)).^2,2))/ratio(ii)/100;

%             idx1=test>prad;%try to find coords outside platform radius
            idx2=[false;delta==0]|[delta==0;false];%find coords that do not move
            idx3=[false;delta>0.22]|[delta>0.22;false]; % coords that move too fast 5mph=.22 7mph=.31 8mph=.35

            idx=idx2|idx3;%idx1|

%             tol=5;
%             [u,~,c]=unique(fix(dat(:,2:3))-mod(fix(dat(:,2:3)),tol),'rows');
%             [~,ix]=max(accumarray(c,1));
%             Xx=u(ix,1); Yy=u(ix,2);
%             idxn=dat(:,2)>Xx-tol & dat(:,2)<Xx+tol & dat(:,3)>Yy-tol & dat(:,3)<Yy+tol;
%             XX=[XX;Xx]; YY=[YY;Yy];
% 
%             idx=idx|idxn;
            k=2;
            for j=1:length(idx)-1
                if idx(j) && j==1
                    dat(1,2:3)=Ci;
                elseif idx(j)
                    if idx(j+1) && j+1==length(idx)
                         dat(end,2:3)=Co;
                        n=j-k+1;
                        new=(dat(j+1,2:3)-dat(k-1,2:3))./(n+1).*(1:n)';
                        dat(k:j,2:3)=dat(k-1,2:3)+new;
                    elseif idx(j+1)
                    else
                        n=j-k+1;
                        new=(dat(j+1,2:3)-dat(k-1,2:3))./(n+1).*(1:n)';
                        dat(k:j,2:3)=dat(k-1,2:3)+new;
                    end
                else
                    k=j+1;
                end
            end
        end

        th=0:pi/30:2*pi;
        xx=prad*cos(th)+Cc(1);
        yy=prad*sin(th)+Cc(2);
        u=[diff(dat(:,2));0];
        us=max(abs(u));
        v=[diff(dat(:,3));0];
        vs=max(abs(v));
%         figure
        subplot(1,2,1)
        scatter(Cc(1),Cc(2),40,'k','filled','displayname','center?')
        hold on
        scatter(Ci(1),Ci(2),40,'k','linewidth',2,'displayname','entry?')
        scatter(Co(1),Co(2),80,'k','x','linewidth',2,'displayname','exit?')
        quiver(data{ii}(:,2),data{ii}(:,3),[diff(data{ii}(:,2));0]./us,[diff(data{ii}(:,3));0]./vs,2)
        scatter(XX,YY,10,'r','*','linewidth',1,'displayname','???')
        plot(xx,yy,'displayname','platform')
        pbaspect([1 1 1])
        axis([200 1400 0 1200])
        title(['original (entry/exit: ',EE{ii},')'])
        legend
        hold off
    
        subplot(1,2,2)
        scatter(Cc(1),Cc(2),40,'k','filled','displayname','center?')
        hold on
        scatter(Ci(1),Ci(2),40,'k','linewidth',2,'displayname','entry?')
        scatter(Co(1),Co(2),80,'k','x','linewidth',2,'displayname','exit?')
        quiver(dat(:,2),dat(:,3),u./us,v./vs,2)
        plot(xx,yy,'displayname','platform')
        pbaspect([1 1 1])
        axis([200 1400 0 1200])
        n=sum(data{ii}(:,2)~=dat(:,2));
        huh(ii)=n/length(idx)*100;
        title(['after ',num2str(n),' points replaced (',num2str(huh(ii)),'%)'])
        legend
        hold off
        saveas(fig,figpath);
        
        subplot(1,1,1)
colormap([autumn(256);flipud(summer(256))]);
        rectangle('position',[Cc(1)-prad,Cc(2)-prad,prad*2,prad*2],'curvature',[1 1],'facecolor',[0 0 0]);
        colorbar('ticks',0:.01:.05)
        caxis([0 .05])
        hold on
%         plot(erad*cos(th)+Ci(1),erad*sin(th)+Ci(2),'g','linewidth',1.42);
%         plot(erad*cos(th)+Co(1),erad*sin(th)+Co(2),'r','linewidth',1.42);
        plot(dat(:,2),dat(:,3),'w','linewidth',1);
        scatter(dat(:,2),dat(:,3),30,[0;delta],'filled');
        axis off
        pbaspect([1 1 1])
        axis([200 1400 0 1200])
        hold off
        saveas(fig,figpath2);
        
trial=strsplit(head{ii}{5},',');
subj=strsplit(head{ii}{3},',');
while sum(strcmp(trials,trial(2)))>0,trial{2}=[trial{2},' again']; end
trials(ii)=trial(2);
subjs(ii)=subj(2);
pointsreplaced{ii}=n;
        
xlS=xlSS.Add([],xlSS.Item(xlSS.Count));
xlS.Name=cat(2,trial{:});
xls=xlS.Shapes;
l=200;t=50;w=800;h=400;
xls.AddPicture(figpath,0,1,l,t,-1,-1);
xls.AddPicture(figpath2,0,1,l,t+h+t,-1,-1);
TS=strsplit(head{ii}{1},',');
output=[TS;[subj,{''}];[trial,{''}];{'ratio',ratio(ii),''};{'center?',Cc(1),Cc(2)};{'entry?',Ci(1),Ci(2)};{'exit?',Co(1),Co(2)};{'','',''};{'time','X','Y'};num2cell(dat)];

xlr=xlS.get('Range',['A1:',xlLetters(size(output,2)),num2str(size(output,1))]);
xlr.Value=output;
        
    end
    xlS=xlSS.get('Item',1);%xlSS.Count
    xlS.Name='Summary';
    summary=[{'trial','subj','points replaced','percent replaced'};[trials,subjs,pointsreplaced,num2cell(huh)]];
xlr=xlS.get('Range',['A1:',xlLetters(size(summary,2)),num2str(size(summary,1))]);
xlr.Value=summary;
    
    newfile=strsplit(head{ii}{2},',');
    newfile=newfile{2};
    newfile=[pwd,'\',newfile,'.xlsx'];
    xlWB.SaveAs(newfile);
    xlWB.Saved=1;
    Close(xlWB)
%
end
delete(figpath)
delete(figpath2)
close(fig)
%%
Quit(xl)
delete(xl)

%%


%%

