function data=CKC_reader_8x8_IED10mm_flatcables_MONO(filepath,filename,epoch_length)
Data = load(string(filepath)+filesep+string(filename));
Data=Data.Data;

rawEMG=Data{1,2};
rawEMG=rawEMG(1:192,:);
Ind_basis = flipud(reshape(64:-1:1,[8,8]));
switch size(rawEMG,1)/64
case 1
Ind = Ind_basis;
case 2
Ind = [Ind_basis+64, Ind_basis];
case 3
Ind = [Ind_basis+64*2, Ind_basis+64, Ind_basis];
end

load('recinfo.mat')
chusing=acqConfig.emg{1,1}.otherProp.ch2use;

% Reorganize the data
discardChannelsVec = zeros(size(Ind,1),size(Ind,2));
for r=1:size(Ind,1)
for c=1:size(Ind,2)
if Ind(r,c) == 0
data.SIG{r,c} = [];
elseif chusing(Ind(r,c))==0
discardChannelsVec(r,c) = 1;
data.SIG{r,c} = rawEMG(Ind(r,c),:);
else
data.SIG{r,c} = rawEMG(Ind(r,c),:);
end
end
end

data.fsamp=Data{2,2};
data.signal_length=length(rawEMG);

montage_temp=Data{4,2};
if length(montage_temp) <9
   montage_temp=strcat(montage_temp,'123456789');
end
if montage_temp(1:9)=='Monopolar'
   data.montage='MONO';
else
    data.montage='SD';
end
data.IED=10;
data.ref_signal=[];
data.description="Forearm data";
%data=struct('SIG',SIG,'fsamp',fsamp,'signal_length',signal_length,'montage',montage,'IED',IED,'ref_signal',ref_signal,'description',description,'discardChannelsVec',discardChannelsVec);
end