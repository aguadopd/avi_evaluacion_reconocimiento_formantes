function [f,val] = avi_fft(x,Fs,NFFT)
%Realiza la transformada de Fourier de una secuencia x con frecuencia de
%muestreo Fs. Devuelve un vector de frecuencias f y el valor absoluto de la
%transformada, ff.

L = length(x);
t = (0:1/Fs:(L-1)*(1/Fs));

%plot(t,x);
if(nargin == 2)
    NFFT = 2^nextpow2(L);
end
    
Y = fft(x,NFFT)/L;
%f = Fs/2*linspace(0,1,NFFT/2+1); 
f = Fs*linspace(0,1,NFFT); %necesitamos todos los puntos para la ifft

% Plot single-sided amplitude spectrum.
%plot(f,2*abs(Y(1:NFFT/2+1))) 
%p1 = abs(Y(1:NFFT/2+1));
%p1 = abs(Y(1:NFFT));
%p2 = Y.*conj(Y)/NFFT;
%figure;
%%plot(f,log10(p1)) ;
%title('Single-Sided Amplitude Spectrum of y(t)')
%xlabel('Frequency (Hz)')
%ylabel('|Y(f)|')
val = abs(Y);
%val = (Y);


