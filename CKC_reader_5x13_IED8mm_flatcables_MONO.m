function data=CKC_reader_5x13_IED8mm_flatcables_MONO(filepath,filename)
load([filepath filesep filename]);
rawEMG=Data{1,2};
rawEMG=rawEMG(end-127:end,:);

Ind_basis = flipud(reshape(0:64, 13, 5)');
Ind_basis([2,4],:) = fliplr(Ind_basis([2,4],:));
switch size(rawEMG,1)/64
case 1
Ind = Ind_basis;
case 2
Ind = [Ind_basis, Ind_basis+64];
case 3
Ind = [Ind_basis+64*2, Ind_basis+64, Ind_basis];
end
Ind(5,14)=0;

load([filepath filesep 'recinfo.mat'])
chusing=acqConfig.emg{1,1}.otherProp.ch2use;
chusing=chusing(end-127:end);
% Reorganize the data
data.discardChannelsVec = zeros(size(Ind,1),size(Ind,2));
for r=1:size(Ind,1)
    for c=1:size(Ind,2)
        if Ind(r,c) == 0
            data.SIG{r,c} = [];
        elseif chusing(Ind(r,c))==0
            data.discardChannelsVec(r,c) = 1;
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
data.IED=8;
data.ref_signal=[];
data.description="Wrist data";
%data=struct('SIG',SIG,'fsamp',fsamp,'signal_length',signal_length,'montage',montage,'IED',IED,'ref_signal',ref_signal,'description',description,'discardChannelsVec',discardChannelsVec);
end