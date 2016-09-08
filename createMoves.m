function [hMoves, cellControls] = createMoves()
vecPosn = [100 100 800 800];
vecPosn = vecPosn + [vecPosn(3) + 100, 0, -500, 0];
hMoves = figure('Units', 'Pixels', 'Position', vecPosn, 'menubar', 'none', 'toolbar', 'none', ...
    'Name', 'Moves', 'NumberTitle', 'off', 'Tag', 'uiChessMoves', 'CloseRequestFcn', @uiClose);
hP1 = uicontrol(hMoves, 'Style', 'text', 'String', 'Player 1 (White):', 'Units', 'Normalized', 'Position', ...
    [0 .92 0.5 0.05], 'FontSize', 10.0, 'HorizontalAlignment', 'center');
hP2 = uicontrol(hMoves, 'Style', 'text', 'String', 'Player 2 (Black):', 'Units', 'Normalized', 'Position', ...
    [0.5 .92 0.5 0.05], 'FontSize', 10.0, 'HorizontalAlignment', 'center');
cellControls{1} = uicontrol(hMoves, 'Style', 'edit', 'Units', 'Normalized', 'Position', [0 0.05 0.5 0.90], ...
    'FontSize', 10.0, 'Min', 1, 'Max', 100, 'HorizontalAlignment', 'left', ...
    'String', {}, 'Enable', 'inactive');
cellControls{2} = uicontrol(hMoves, 'Style', 'edit', 'Units', 'Normalized', 'Position', [0.5 0.05 0.5 0.90], ...
    'FontSize', 10.0, 'Min', 1, 'Max', 100, 'HorizontalAlignment', 'left', ...
    'String', {}, 'Enable', 'Inactive');
hDock = uicontrol(hMoves, 'Style', 'pushbutton', 'String', 'Dock', 'Callback', @uiDock, ...
    'Units', 'Normalized', 'Position', [0 0 1 0.05], 'FontSize', 10.0);

    function uiDock(~, ~)
        hChess = findobj('Tag', 'uiChessBoard');
        if ~isequal(hChess, cellControls{1}.Parent)
            cellC = num2cell(hChess.Children)';
            cellC(~cellfun(@(obj)(isa(obj, 'matlab.ui.control.UIControl')), cellC)) = [];
            cellfun(@(uic)(uiResize(uic, .2, 'h')), cellC, 'uni', false);
            hP1.Parent = hChess;
            hP2.Parent = hChess;
            hP1.Position = [0.80 0.92 0.1 0.05];
            hP2.Position = [0.90 0.92 0.1 0.05];
            cellControls{1}.Parent = hChess;
            cellControls{2}.Parent = hChess;
            cellControls{1}.Position = [0.80 0.05 0.1 0.90];
            cellControls{2}.Position = [0.90 0.05 0.1 0.90];
            hDock.Parent = hChess;
            hDock.Position = [0.80 0.00 0.2 0.05];
            delete(hMoves);
            hDock.String = 'Undock';
        else
            hMoves = figure('Units', 'Pixels', 'Position', vecPosn, 'menubar', 'none', 'toolbar', 'none', ...
                'Name', 'Moves', 'NumberTitle', 'off', 'Tag', 'uiChessMoves', 'CloseRequestFcn', @uiClose);
            cellC = num2cell(hChess.Children)';
            cellC(~cellfun(@(obj)(isa(obj, 'matlab.ui.control.UIControl')), cellC)) = [];
            cellfun(@(uic)(uiResize(uic, -.25, 'h')), cellC, 'uni', false);
            hDock.Parent = hMoves;
            hP1.Parent = hMoves;
            hP2.Parent = hMoves;
            hP1.Position = [0 0.92 0.5 0.05];
            hP2.Position = [0.5 0.92 0.5 0.05];
            cellControls{1}.Parent = hMoves;
            cellControls{2}.Parent = hMoves;
            cellControls{1}.Position = [0 0.05 0.5 0.9];
            cellControls{2}.Position = [0.5 0.05 0.5 0.9];
            hDock.Position = [0 0 1 0.05];
            hDock.String = 'Dock';
        end
    end
end

function uiClose(hObject, ~)
hChess = findobj('Tag', 'uiChessBoard');
if ~isempty(hChess)
    delete(hChess);
end
delete(hObject);
end

function uiResize(uic, fracRemove, strDir)
    if ~isempty(strfind(strDir, 'h'))
        r1 = 1 - fracRemove;
    else
        r1 = 1;
    end
    if ~isempty(strfind(strDir, 'v'))
        r2 = 1 - fracRemove;
    else
        r2 = 1;
    end
    vec = uic.Position;
    uic.Position = [vec(1).*r1 vec(2).*r2 vec(3).*r1 vec(4).*r2];
end