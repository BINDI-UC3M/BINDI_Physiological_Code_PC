% extract_DEAP_TableData() - import data (GSR, BVP, TEMP) from .bdf DEAP 
%                            files into matrix and adding Labels
%
% Usage:
%   >> [OUTDATA] = extract_DEAP_data(); % pop up window
%   >> [OUTDATA] = extract_DEAP_data( filename );
%
% Inputs:
%   filename - [string] file name. If 'all', OUTDATA will contain the info
%              for all the files within the folder. If none, a pop-up 
%              window will be opened to choose the right file.
%
% Optional inputs: ...
%                
%        
% Outputs:
%   [OUTDATA]   - [patient x variable x data]
%                 >> patient: 1-22. 
%                             DEAP patients number under Twente experiment.
%                 >> variable:1-3.
%                             DEAP GSR(1), BVP(2), TEMP(3).
%                 >> data:    1-1980928.
%                             DEAP patients data.
%
% Author: Jose Angel Miranda Calero
%
% Note: BIOSIG toolbox must be installed. Download BIOSIG at 
%       http://biosig.sourceforge.net
%       Contact a.schloegl@ieee.org for troubleshooting using BIOSIG.
% 
% DEAP web: http://www.eecs.qmul.ac.uk/mmv/datasets/deap/readme.html
% There are 32 .bdf files (BioSemi's data format generated by the Actiview 
% recording software), each with 48 recorded channels at 512Hz. 
% (32 EEG channels, 12 peripheral channels, 3 unused channels and 1 status 
% channel). The .bdf files can be read by a variety of software toolkits, 
% including EEGLAB for Matlab and the BIOSIG toolkit.
% 
% Copyright (C) 2017 Jose Angel Miranda Calero, jmiranda@ing.uc3m.es
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
%---
clc;clear;
for i=25:32
  pStart = i;
  pStop = i;
  extract_DEAP_TableData;
  clc;clear;
end
loading_DEAP();