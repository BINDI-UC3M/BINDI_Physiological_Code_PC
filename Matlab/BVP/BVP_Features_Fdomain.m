%> @file BVP_Features_Fdomain.m
%> @brief Extract Fdomain BVP features
%> @param  HRV: IBI - Heart rate variability as Inter Beat Interval
%> @param  vector_pos: peaks position in samples (not time)
%> @param  fs: Sampling frequency of the original BVP signal
%> @retval Feats: Feature vector of BVP Fdomain features
%
%> @author DTE UC3M
% 
% Copyright (C) 2019 UC3M
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
%%
function Feats = BVP_Features_Fdomain(HRV, vector_pos, fs)

%% Extract PSD
[fft_HRV, vector_frecuencia] = fft_signal_wrist_BVP(HRV, vector_pos, fs);

%%Normalized w.r.t the total PSD - units are dB/Hz
fft_HRV = fft_HRV/sum(fft_HRV);

%% Extract exact frequency band information
[LF_signal, HF_signal, UHF_signal] = bandas_frec(fft_HRV, vector_frecuencia);

sum_LF = f_sum_frec(LF_signal)*100;
Feats(1) = sum_LF;

sum_HF = f_sum_frec(HF_signal)*100;
Feats(2) = sum_HF;

sum_UHF = f_sum_frec(UHF_signal)*100;
Feats(3) = sum_UHF;

%% Energy for the different bands
LF_energia = abs(log(sum_LF));
Feats(4) = LF_energia;

HF_energia = abs(log(sum_HF));
Feats(5) = HF_energia;

UHF_energia = abs(log(sum_UHF));
Feats(6) = UHF_energia;

%% Ratios between LF and HF bands (SNS(7) / PNS(9))
Ratio_LFHF = abs(LF_energia/HF_energia);
Feats(7) = Ratio_LFHF;

%% Normalized energy
LFnorm = abs(LF_energia/(LF_energia+HF_energia));
Feats(8) = LFnorm;

HFnorm = abs(HF_energia/(LF_energia+HF_energia));
Feats(9) = HFnorm;

%% Realtive energy of the freq bands
Rel_power_LF = abs(relative_power(LF_energia, HF_energia, UHF_energia));
Feats(10) = Rel_power_LF;

Rel_power_HF = abs(relative_power(HF_energia, LF_energia, UHF_energia));
Feats(11) = Rel_power_HF;

Rel_power_UHF = abs(relative_power(UHF_energia, HF_energia, LF_energia));
Feats(12) = Rel_power_UHF;

end