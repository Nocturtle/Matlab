function colLetter = xlLetters(colNumber)

%setup excel letter column progression to export to excel later : found this somewhere in matlab file exchange
atoz        = char(65:90)'; %Start with A-Z letters
singleChar  = cellstr(atoz); %Single character columns are first
n           = (1:26)'; %Calculate double character columns
indx        = allcomb(n,n); %http://www.mathworks.com/matlabcentral/fileexchange/10064-allcomb
doubleChar  = cellstr(atoz(indx));
indx2       = allcomb(n,n,n); % triple char
tripleChar  = cellstr(atoz(indx2));
xlLetters   = [singleChar;doubleChar;tripleChar];% Concatenate

colLetter   = xlLetters{colNumber}; %Return requested column

end