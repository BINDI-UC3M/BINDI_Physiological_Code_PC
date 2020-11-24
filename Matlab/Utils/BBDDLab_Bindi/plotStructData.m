% <function name>(<arg1>,<agr2>,...) - <Brief Description>
%
% Usage:
%   >> <Out> = <function name>(<arg1>) 
%   >> <Out> = <function name>(<arg1>,<arg2>)
%   >>
%
% Inputs:
%   <DATA_IN> - <description>
%   <RESPONSE_IN> - <description>
%
% Optional inputs: ...
%                
%        
% Outputs:
%   <RESULTS>   - description
%
% Author: DTE UC3M
%
% Note: <description>.
% 
% <Aditional information>
% 
% Copyright (C) 2020 UC3M
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
function plotStructData(out_s)

%Check if out_s if a struct data type
if isa(out_s,'struct') == 0
  error("plotStructData: A valid data type input (struct) must be specified");
end

%Get size of out_s
[rows, columns] = size(out_s);

rawBVP_EH = [];
rawGSR_EH = [];

rawBVP_Bindi = [];
rawGSR_GSensor = [];

for j=1:rows %Volunteers loop
  for k=1:columns %Trials loop
    rawBVP_EH = [rawBVP_EH ];
    rawBVP_Bindi = [rawBVP_Bindi ];
    
  end
end

end