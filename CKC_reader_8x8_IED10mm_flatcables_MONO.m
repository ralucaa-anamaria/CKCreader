function data=CKC_reader_8x8_IED10mm_flatcables_MONO(filepath,filename,epoch_length)
Data = load(string(filepath)+filesep+string(filename));
Data=Data.Data;
fsamp=Data{2,2};
SIG=Data{1,2};
signal_length=length(SIG);
montage_temp=Data{4,2};
if length(montage_temp) <9
   montage_temp=strcat(montage_temp,'123456789');
end
if montage_temp(1:9)=='Monopolar'
   montage='MONO';
else
    montage='SD';
end
IED=10;
ref_signal=[];
description="Forearm data";
data=struct('SIG',SIG,'fsamp',fsamp,'signal_length',signal_length,'montage',montage,'IED',IED,'ref_signal',ref_signal,'description',description);
end