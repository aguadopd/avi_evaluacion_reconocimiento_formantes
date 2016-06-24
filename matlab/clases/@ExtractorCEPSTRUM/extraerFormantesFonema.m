function formantes_estimados = extraerFormantesFonema( obj, fonema )
%EXTRAERFORMANTESFONEMA Summary of this function goes here
%   Detailed explanation goes here

validateattributes(fonema,{'Fonema'},{'numel',1},'','fonema',1);
audio = fonema.sonido;
Fs = fonema.fs;

cepstrum_segundos = 0.001;

    NFFT = 2^nextpow2(length(audio));

x = audio.*hamming(length(audio));

[f1,ff] = avi_fft(x,Fs,NFFT);
ff = abs(ff);%%

Lf = length(f1);
y2 = log(ff);
y3 = ifft(y2,length(audio));


N = round(cepstrum_segundos / (1/Fs));

L = zeros(1,length(y3));%For defining liftering window

L(1:N)=1;%Liftering window

y5=real(y1*L');%Low-time lifted cepstrum

[f,val] = avi_fft(y5,Fs,NFFT);
val = abs(val); %%

f = f(1:Lf/2);
val = val(1:Lf/2);


y7 = (val);

% Buscamos picos
% k=1;
% for i=2:((Lf/2)-1)
% if (y7(i-1)<y7(i)) && (y7(i+1)<y7(i))
%     formants(k)=y7(i);
%     formants_pos(k)=f(i);
%     k=k+1;
% else
% continue;
% end
% end

% Buscamos picos, 2016 Pablo
%[formants,formants_pos] = findpeaks(y7(2:(Lf/2)-1),'MinPeakWidth',Lf*(50/Fs),'MaxPeakWidth',Lf*(400/Fs)); 
[formants,formants_pos] = findpeaks(y7(2:(Lf/2)-1)); 
formants_pos = f(formants_pos);
formants = formants';

formants_pos = round(formants_pos);

if(exist('formants','var')==1 && numel(formants)>1)
    F1_cepstrum = formants_pos(1);
    F2_cepstrum = formants_pos(2);
else
    F1_cepstrum = 0;
    F2_cepstrum = 0;
end

%   figure();
%   plot(f,val);hold on;
%   plot(formants_pos,formants,'r*');

formantes_estimados = [F1_cepstrum, F2_cepstrum];
fonema.formantes_estimados = formantes_estimados;

end

