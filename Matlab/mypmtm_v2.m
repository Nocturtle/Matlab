%% The following is a function that will evaluate a power spectral density using a thomson multitaper method on a 2D input matrix with signal in each column. It uses the czt method to compute the DFT, and the eigen method for estimating the average of dpss windows. 
function psd = mypmtm_v2(xin,fs,bins_per_hz)
    [m, n] = size(xin);%m=length of signal, n=num signals
    k=fs*bins_per_hz;
    nfft = 2^nextpow2(m+k-1);%- Length for power-of-two fft.
    [E,V] = dpss(m,4);
    g=gpuDevice;
    s=nfft*length(V)*2^6;%how many bytes will be needed for ea. signal
    ne=floor(g.AvailableMemory/s);%number of signals that can be processed at once with the available gpu memory
    indx=[0:ne:n,n];%number of iterations that will be necessary
    
    psd=zeros(k/2,n);%initialize output
    
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

        psd(:,1+indx(i):indx(i+1))=gather(x);
    end
end