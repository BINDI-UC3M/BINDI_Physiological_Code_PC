%> @file featuresSelector.m
%> @brief This function select a subset of features from 'featuresNames' based on
%> 'include' / 'exclude' satements.
%> Features are always returned in the same order than 'features name'
%
%> If no Include/exclude statement is specifed all features are returned.
%
%> So far only one include/options option can be specified. If several are
%> specified only the last will be taken into account.
%
%> Proposed features which are not included in 'featuresNames' are rejected
%> (no error output).
%
%> Examples:
%>   featuresSelector({'A','B',C'},'Include',{'A','C'})
%>       returns {'A','C'}
%>   featuresSelector({'A','B',C'},'Exclude',{'A'})
%>       returns {'B','C'}
%> @author Guillaume Chanel
% 
%> @param featuresNames cell array containing the complete list of features
%>                  names
%> @param varargin pair of arguments in the matlab style. The second argument
%>             represent a subset of features as a cell array. The first
%>             argument tells if the subset should be removed from the full
%>             set of features ('exclude') or included in an empty set ('include')
% 
%> @retval selFeatures a cell array of selected features
% 
function [selfeatures] = featuresSelector(featuresNames,varargin)

%If varargin is not specified than all features are computed (default)
if(isempty(varargin))
    selfeatures = featuresNames;
else
    %Process varargin inputs
    for(i=1:2:length(varargin))
        switch(lower(varargin{i}))
            case 'include'
                selfeatures = intersect(featuresNames,varargin{i+1});
            case 'exclude'
                 [~, selfeaturesIndices] = setdiff(featuresNames,varargin{i+1});
                 selfeatures = featuresNames(sort(selfeaturesIndices));
            otherwise
                error('TEAP:badarg',['Unkown option: ' varargin{1}])
        end
    end
end
