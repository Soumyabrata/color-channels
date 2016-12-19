function [arx,ary,arx_2D,ary_2D] = biplot_modified(coefs,varargin)
% This is a modification of the in-built biplot command. 
% -----------------------------------------------------

%BIPLOT Biplot of variable/factor coefficients and scores.
%   BIPLOT(COEFS) creates a biplot of the coefficients in the matrix
%   COEFS.  The biplot is 2D if COEFS has two columns, or 3D if it has
%   three columns.  COEFS usually contains principal component coefficients
%   created with PCA or PCACOV, or factor loadings estimated with
%   FACTORAN or NNMF.  The axes in the biplot represent the principal
%   components or latent factors (columns of COEFS), and the observed
%   variables (rows of COEFS) are represented as vectors.
%
%   BIPLOT(COEFS, ..., 'Scores', SCORES) plots both COEFS and the scores in
%   the matrix SCORES in the biplot.  SCORES usually contains principal
%   component scores created with PCA or factor scores estimated with
%   FACTORAN.  Each observation (row of SCORES) is represented as a point
%   in the biplot.
%
%   A biplot allows you to visualize the magnitude and sign of each
%   variable's contribution to the first two or three principal components,
%   and how each observation is represented in terms of those components.
%   Use the data cursor to read precise values from the plot.
%
%   BIPLOT imposes a sign convention, forcing the element with largest
%   magnitude in each column of COEFS to be positive.  This flips some of the
%   vectors in COEFS to the opposite direction, but often makes the plot
%   easier to read.  Interpretation of the plot is unaffected, because
%   changing the sign of a coefficient vector does not change its meaning.
%
%   BIPLOT(COEFS, ..., 'VarLabels',VARLABS) labels each vector (variable)
%   with the text in the character array or cell array VARLABS.
%
%   BIPLOT(COEFS, ..., 'Scores', SCORES, 'ObsLabels', OBSLABS) uses the
%   text in the character array or cell array OBSLABS as observation names
%   when displaying data cursors.
%
%   BIPLOT(COEFS, ..., 'Positive', true) restricts the biplot to the positive
%   quadrant (in 2D) or octant (in 3D). BIPLOT(COEFS, ..., 'Positive', false)
%   (the default) makes the biplot over the range +/- MAX(COEFS(:)) for all
%   coordinates.
%
%   BIPLOT(COEFFS, ..., 'PropertyName',PropertyValue, ...) sets properties
%   to the specified property values for all line graphics objects created
%   by BIPLOT.
%
%   H = BIPLOT(COEFS, ...) returns a column vector of handles to the
%   graphics objects created by BIPLOT.  H contains, in order, handles
%   corresponding to variables (line handles, followed by marker handles,
%   followed by text handles), to observations (if present, marker
%   handles), and to the axis lines.
%
%   Example:
%
%      load carsmall
%      X = [Acceleration Displacement Horsepower MPG Weight];
%      X = X(all(~isnan(X),2),:);
%      [coefs,score] = pca(zscore(X));
%      vlabs = {'Accel','Disp','HP','MPG','Wgt'};
%      biplot(coefs(:,1:3), 'scores',score(:,1:3), 'varlabels',vlabs);
%
%   See also FACTORAN, NNMF, PCA, PCACOV, ROTATEFACTORS.

%   References:
%     [1] Seber, G.A.F. (1984) Multivariate Observations, Wiley.

%   Copyright 1993-2010 The MathWorks, Inc. 


% Choose whether the datatip can attach to Axes or Variable lines.
cursorOnAxes = false;
cursorOnVars = true;

if nargin < 1
    error(message('stats:biplot:TooFewInputs'));
end
[p,d] = size(coefs);
if (d < 2) || (d > 3)
    error(message('stats:biplot:CoefsSizeMismatch'));
elseif isempty(coefs)
    error(message('stats:biplot:EmptyInput'));
end
in3D = (d == 3);

% Process input parameter name/value pairs, assume unrecognized ones are
% graphics properties for PLOT.
pnames = {'scores' 'varlabels' 'obslabels' 'positive'};
dflts =  {     []          []          []         [] };
[scores,varlabs,obslabs,positive,~,plotArgs] = ...
                    internal.stats.parseArgs(pnames, dflts, varargin{:});

if ~isempty(scores)
    [n,d2] = size(scores);
    if d2 ~= d
        error(message('stats:biplot:ScoresSizeMismatch'));
    end
end

if ~isempty(positive)
    if ~isscalar(positive) || ~islogical(positive)
        error(message('stats:biplot:InvalidPositive'));
    end
else
    positive = false;
end

cax = newplot;
dataCursorBehaviorObj = hgbehaviorfactory('DataCursor');
set(dataCursorBehaviorObj,'UpdateFcn',@biplotDatatipCallback);
disabledDataCursorBehaviorObj = hgbehaviorfactory('DataCursor');
set(disabledDataCursorBehaviorObj,'Enable',false);

if nargout > 0
    varTxtHndl = [];
    obsHndl = [];
    axisHndl = [];
end

% Force each column of the coefficients to have a positive largest element.
% This tends to put the large var vectors in the top and right halves of
% the plot.
[~,maxind] = max(abs(coefs),[],1);
colsign = sign(coefs(maxind + (0:p:(d-1)*p)));
coefs = bsxfun(@times,coefs,colsign);

% Plot a line with a head for each variable, and label them.  Pass along any
% extra input args as graphics properties for plot.
%
% Create separate objects for the lines and markers for each row of COEFS.
zeroes = zeros(p,1); nans = NaN(p,1);
arx = [zeroes coefs(:,1) nans]';
ary = [zeroes coefs(:,2) nans]';

arx_2D=arx(1:2,:);  ary_2D=ary(1:2,:);

if in3D
    arz = [zeroes coefs(:,3) nans]';
    varHndl = [line(arx(1:2,:),ary(1:2,:),arz(1:2,:), 'Color','b', 'LineStyle','-', plotArgs{:}, 'Marker','none'); ...
               line(arx(2:3,:),ary(2:3,:),arz(2:3,:), 'Color','b', 'Marker','.', plotArgs{:}, 'LineStyle','none')];
else
    varHndl = [line(arx(1:2,:),ary(1:2,:), 'Color','b', 'LineStyle','-', plotArgs{:}, 'Marker','none'); ...
               line(arx(2:3,:),ary(2:3,:), 'Color','b', 'Marker','.', plotArgs{:}, 'LineStyle','none')];
end
set(varHndl(1:p),'Tag','varline');
set(varHndl((p+1):(2*p)),'Tag','varmarker');
set(varHndl,{'UserData'},num2cell(([1:p 1:p])'));
if cursorOnVars
    hgaddbehavior(varHndl,dataCursorBehaviorObj);
else
    hgaddbehavior(varHndl,disabledDataCursorBehaviorObj);
end


if ~isempty(varlabs)
    if ~(ischar(varlabs) && (size(varlabs,1) == p)) && ...
                           ~(iscellstr(varlabs) && (numel(varlabs) == p))
        error(message('stats:biplot:InvalidVarLabels'));
    end

    % Take a stab at keeping the labels off the markers.
    delx = .01*diff(get(cax,'XLim'));
    dely = .01*diff(get(cax,'YLim'));
    if in3D
        delz = .01*diff(get(cax,'ZLim'));
    end

    if in3D
        varTxtHndl = text(coefs(:,1)+delx,coefs(:,2)+dely,coefs(:,3)+delz,varlabs);
    else
        varTxtHndl = text(coefs(:,1)+delx,coefs(:,2)+dely,varlabs);
    end
    set(varTxtHndl,'Tag','varlabel');
end

% Plot axes and label the figure.
if ~ishold
    view(d), grid on;
    axlimHi = 1.1*max(abs(coefs(:)));
    axlimLo = -axlimHi * ~positive;
    if in3D
        axisHndl = line([axlimLo axlimHi NaN 0 0 NaN 0 0],[0 0 NaN axlimLo axlimHi NaN 0 0],[0 0 NaN 0 0 NaN axlimLo axlimHi], 'Color','black');
    else
        axisHndl = line([axlimLo axlimHi NaN 0 0],[0 0 NaN axlimLo axlimHi], 'Color','black');
    end
    set(axisHndl,'Tag','axisline');
    if cursorOnAxes
        hgaddbehavior(axisHndl,dataCursorBehaviorObj);
    else
        hgaddbehavior(axisHndl,disabledDataCursorBehaviorObj);
    end

    xlabel(getString(message('stats:biplot:LabelComponent1')));
    ylabel(getString(message('stats:biplot:LabelComponent2')));
    if in3D
        zlabel(getString(message('stats:biplot:LabelComponent3')));
    end
    axis tight
end

% Plot data.
if ~isempty(scores)
    % Scale the scores so they fit on the plot, and change the sign of
    % their coordinates according to the sign convention for the coefs.
    maxCoefLen = sqrt(max(sum(coefs.^2,2)));
    scores = bsxfun(@times, maxCoefLen.*(scores ./ max(abs(scores(:)))), colsign);
    
    % Create separate objects for each row of SCORES.
    nans = NaN(n,1);
    ptx = [scores(:,1) nans]';
    pty = [scores(:,2) nans]';
    % Plot a point for each observation, and label them.
    if in3D
        ptz = [scores(:,3) nans]';
        obsHndl = line(ptx,pty,ptz, 'Color','r', 'Marker','.', plotArgs{:}, 'LineStyle','none');
    else
        obsHndl = line(ptx,pty, 'Color','r', 'Marker','.', plotArgs{:}, 'LineStyle','none');
    end
    if ~isempty(obslabs)
        if ~(ischar(obslabs) && (size(obslabs,1) == n)) && ...
                           ~(iscellstr(obslabs) && (numel(obslabs) == n))
            error(message('stats:biplot:InvalidObsLabels'));
        end
    end
    set(obsHndl,'Tag','obsmarker');
    set(obsHndl,{'UserData'},num2cell((1:n)'));
    hgaddbehavior(obsHndl,dataCursorBehaviorObj);
end

if ~ishold && positive
    axlims = axis;
    axlims(1:2:end) = 0;
    axis(axlims);
end

if nargout > 0
    h = [varHndl; varTxtHndl; obsHndl; axisHndl];
end

    % -----------------------------------------
    % Generate text for custom datatip.
    function dataCursorText = biplotDatatipCallback(~,eventObj)
    clickPos = get(eventObj,'Position');
    clickTgt = get(eventObj,'Target');
    clickNum = get(clickTgt,'UserData');
    ind = get(eventObj,'DataIndex');
    switch get(clickTgt,'Tag')
    case 'obsmarker'
        dataCursorText = {getString(message('stats:biplot:CursorScores')) ...
            getString(message('stats:biplot:CursorComponent1',num2str(clickPos(1)))) ...
            getString(message('stats:biplot:CursorComponent2',num2str(clickPos(2)))) };
        if in3D
            dataCursorText{end+1} = getString(message('stats:biplot:CursorComponent3',num2str(clickPos(3))));
        end
        if isempty(obslabs)
            clickLabel =  num2str(clickNum);
        elseif ischar(obslabs)
            clickLabel = obslabs(clickNum,:);
        elseif iscellstr(obslabs)
            clickLabel = obslabs{clickNum};
        end
        dataCursorText{end+1} = '';
        dataCursorText{end+1} = getString(message('stats:biplot:CursorObservation',clickLabel));
    case {'varmarker' 'varline'}
        dataCursorText = {getString(message('stats:biplot:CursorLoadings')) ...
            getString(message('stats:biplot:CursorComponent1',num2str(clickPos(1)))) ...
            getString(message('stats:biplot:CursorComponent2',num2str(clickPos(2)))) };
        if in3D
            dataCursorText{end+1} = getString(message('stats:biplot:CursorComponent3',num2str(clickPos(3))));
        end
        if isempty(varlabs)
            clickLabel = num2str(clickNum);
        elseif ischar(varlabs)
            clickLabel = varlabs(clickNum,:);
        elseif iscellstr(varlabs)
            clickLabel = varlabs{clickNum};
        end
        dataCursorText{end+1} = '';
        dataCursorText{end+1} = getString(message('stats:biplot:CursorVariable',clickLabel));
    case 'axisline'
        comp = ceil(ind/3);
        dataCursorText = getString(message('stats:biplot:CursorComponent',num2str(comp)));
    otherwise
        dataCursorText = {...
            getString(message('stats:biplot:CursorComponent1',num2str(clickPos(1)))) ...
            getString(message('stats:biplot:CursorComponent2',num2str(clickPos(2))))};
        if in3D
            dataCursorText{end+1} = getString(message('stats:biplot:CursorComponent3',num2str(clickPos(3))));
        end
    end

    end % biplotDatatipCallback

end % biplot
