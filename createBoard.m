function [hBoard, cellControls] = createBoard(cellMoveControls)
vecPosn = [100 100 800 800];
hBoard = figure('Units', 'Pixels', 'Position', vecPosn, 'menubar', 'none', 'toolbar', 'none', ...
    'Name', 'Chess', 'NumberTitle', 'off', 'Tag', 'uiChessBoard', 'CloseRequestFcn', @uiClose);
hGame = uimenu(hBoard, 'Label', 'Game');
uimenu(hGame, 'Label', 'New Game', 'Callback', @uiNew);
uimenu(hGame, 'Label', 'Save Game...', 'Callback', @uiSave);
uimenu(hGame, 'Label', 'Load Game...', 'Callback', @uiLoad);
uimenu(hGame, 'Label', 'Quit', 'Accelerator', 'Q', 'Callback', @uiClose);
intLength = floor(vecPosn(3)/8);
fCombine = @(int1, int2)([int1, int2]);
fSquare = @(vecInts)(uicontrol(hBoard, 'Style', 'pushbutton', 'String', '', ...
    'Position', [vecInts(1), vecInts(2), intLength, intLength], 'Units', 'Normalized'));
[xx, yy] = meshgrid(0:intLength:7*intLength, 0:intLength:7*intLength);
cellControls = arrayfun(fCombine, xx, yy, 'uni', false);
cellControls = cellfun(fSquare, cellControls, 'uni', false);
cellfun(@fWhite, cellControls(1:2:end, 2:2:end), 'uni', false);
cellfun(@fWhite, cellControls(2:2:end, 1:2:end), 'uni', false);
cellfun(@fBlack, cellControls(1:2:end, 1:2:end), 'uni', false);
cellfun(@fBlack, cellControls(2:2:end, 2:2:end), 'uni', false);
cellfun(@uiNorm, cellControls, 'uni', false);
    function uiCB(uic)
        uic.Callback = {@uiPlayer_Callback, cellControls};
    end

cellfun(@uiCB, cellControls, 'uni', false);
hBoard.Units = 'normalized';

    function fBlack(uic)
        uic.BackgroundColor = [.3 .3 .3];
        uic.Enable = 'on';
    end

    function fWhite(uic)
        uic.BackgroundColor = [.7 .7 .7];
        uic.Enable = 'on';
    end

    function uiPlayer_Callback(hObject, ~, cellControls)
        cellMoves = possMoves(cellControls, hObject.UserData)';
        cellfun(@fWhiteCB, cellControls(1:2:end, 2:2:end), 'uni', false);
        cellfun(@fWhiteCB, cellControls(2:2:end, 1:2:end), 'uni', false);
        cellfun(@fBlackCB, cellControls(1:2:end, 1:2:end), 'uni', false);
        cellfun(@fBlackCB, cellControls(2:2:end, 2:2:end), 'uni', false);
        cellfun(@(uic)(fHighlightCB(uic, hObject)), cellfun(@(c)(coord(cellControls, c)), cellMoves, 'uni', false), 'uni', false);
        hObject.Enable = 'on';
        hObject.Callback = @uiPlayer_Reset;
    end

    function uiPlayer_Reset(hObject, ~)
        cellfun(@fWhite, cellControls(1:2:end, 2:2:end), 'uni', false);
        cellfun(@fWhite, cellControls(2:2:end, 1:2:end), 'uni', false);
        cellfun(@fBlack, cellControls(1:2:end, 1:2:end), 'uni', false);
        cellfun(@fBlack, cellControls(2:2:end, 2:2:end), 'uni', false);
        cellfun(@uiCB, cellControls, 'uni', false);
        cellfun(@d, cellControls(cellfun(@isempty, cellfun(@(uic)(uic.Tag), cellControls, 'uni', false))), 'uni', false);
        hObject.Callback = {@uiPlayer_Callback, cellControls};
        strPiece = hObject.Tag;
        cellWhite = cellControls(cellfun(@findWhite, cellControls));
        cellBlack = cellControls(cellfun(@findBlack, cellControls));
        if strPiece(end) == 'w'
            cellfun(@e, cellWhite);
            cellfun(@d, cellBlack);
        else
            cellfun(@e, cellBlack);
            cellfun(@d, cellWhite);
        end
        
    end

    function fBlackCB(uic)
        uic.BackgroundColor = [.3 .3 .3];
        uic.Enable = 'off';
        uiCB(uic);
    end

    function fWhiteCB(uic)
        uic.BackgroundColor = [.7 .7 .7];
        uic.Enable = 'off';
        uiCB(uic);
    end

    function fHighlightCB(uic, hSelected)
        uic.BackgroundColor = [.9, .9, 0];
        uic.Enable = 'on';
        uic.Callback = {@uiPlayer_Selected, hSelected};
    end

    function uiPlayer_Selected(hObject, ~, hMoved)
        if ~isempty(hObject.Tag)
            strC = 'x';
        else
            strC = '';
        end
        strPiece = hMoved.Tag;
        if strncmp(strPiece, 'king', 4);
            strP = 'K';
        elseif strncmp(strPiece, 'qenn', 4);
            strP = 'Q';
        elseif strncmp(strPiece, 'rook', 4);
            strP = 'R';
        elseif strncmp(strPiece, 'bish', 4);
            strP = 'B';
        elseif strncmp(strPiece, 'knit', 4);
            strP = 'N';
        elseif ~isempty(strC)
            strP = mat2chess(hMoved.UserData);
            strP = strP(1);
        else
            strP = '';
        end
        vecPPosn = hObject.UserData;
        strPosn = mat2chess(vecPPosn);
        strPlay = [strP, strC, strPosn];
        if strcmp(strPiece, 'pawnw') && vecPPosn(1) == 8
            hTrans = figure('Name', 'Choose your Piece:', 'Position', [100 100 150 130], ...
                'NumberTitle', 'off', 'toolbar', 'none', 'menu', 'none');
            uicontrol(hTrans, 'style', 'text', 'String', 'Choose your Piece:', 'Position', ...
                [10 110 130 20], 'FontSize', 10.0);
            uicontrol(hTrans, 'style', 'pushbutton', 'String', 'Queen', ...
                'Position', [10 90 130 20], 'Callback', {@pbCallback, vecPPosn});
            uicontrol(hTrans, 'style', 'pushbutton', 'String', 'Rook', ...
                'Position', [10 60 130 20], 'Callback', {@pbCallback, vecPPosn});
            uicontrol(hTrans, 'style', 'pushbutton', 'String', 'Bishop', ...
                'Position', [10 30 130 20], 'Callback', {@pbCallback, vecPPosn});
            uicontrol(hTrans, 'Style', 'pushbutton', 'String', 'Knight', ...
                'Position', [10 00 130 20], 'Callback', {@pbCallback, vecPPosn});
        elseif strcmp(strPiece, 'pawnb') && vecPPosn(1) == 1
            hTrans = figure('Name', 'Choose your Piece:', 'Position', [100 100 150 130], ...
                'NumberTitle', 'off', 'toolbar', 'none', 'menu', 'none');
            uicontrol(hTrans, 'style', 'text', 'String', 'Choose your Piece:', 'Position', ...
                [10 110 130 20], 'FontSize', 10.0);
            uicontrol(hTrans, 'style', 'pushbutton', 'String', 'Queen', ...
                'Position', [10 90 130 20], 'Callback', {@pbCallback, vecPPosn});
            uicontrol(hTrans, 'style', 'pushbutton', 'String', 'Rook', ...
                'Position', [10 60 130 20], 'Callback', {@pbCallback, vecPPosn});
            uicontrol(hTrans, 'style', 'pushbutton', 'String', 'Bishop', ...
                'Position', [10 30 130 20], 'Callback', {@pbCallback, vecPPosn});
            uicontrol(hTrans, 'Style', 'pushbutton', 'String', 'Knight', ...
                'Position', [10 00 130 20], 'Callback', {@pbCallback, vecPPosn});
        end
        hObject.Tag = hMoved.Tag;
        hObject.String = hMoved.String;
        hObject.ForegroundColor = hMoved.ForegroundColor;
        hMoved.Tag = '';
        hMoved.String = '';
        uiPlayer_Reset(hObject);
        if ~isequal(hObject.UserData, hMoved.UserData)
            cellWhite = cellControls(cellfun(@findWhite, cellControls));
            cellBlack = cellControls(cellfun(@findBlack, cellControls));
            if strPiece(end) == 'w'
                cellfun(@d, cellWhite);
                cellfun(@e, cellBlack);
            else
                cellfun(@d, cellBlack);
                cellfun(@e, cellWhite);
            end
        end
        hMoved.Callback = {@uiPlayer_Callback, cellControls};
        if strPiece(end) == 'w'
            cellWhite = cellControls(cellfun(@findWhite, cellControls));
            cellfun(@dWhite, cellWhite, 'uni', false);
            strPlayed = cellMoveControls{1}.String;
            if isempty(strPlayed)
                intPlay = 0;
            else
                intPlay = str2double(strtok(strPlayed{end}, '.'));
            end
            strPlay = {[num2str(intPlay+1) '. ' strPlay]};
            strPlayed = [strPlayed; strPlay];
            cellMoveControls{1}.String = strPlayed;
            cellBlack = cellControls(cellfun(@findBlack, cellControls));
            cellBlack = cellfun(@(uic)(uic.UserData), cellBlack, 'uni', false);
            cellMoves = cellfun(@(vec)(possMoves(cellControls, vec)), cellBlack, 'uni', false);
            cellMoves(cellfun(@isempty, cellMoves)) = [];
            if isempty(cellMoves)
                cellWhite = cellControls(cellfun(@findWhite, cellControls));
                cellWhite = cellfun(@(uic)(uic.UserData), cellWhite, 'uni', false);
                cellMoves = cellfun(@(vec)(possMoves(cellControls, vec)), cellWhite, 'uni', false);
                vecKing = cellControls{strcmp('kingb', cellfun(@(uic)(uic.Tag), cellControls, 'uni', false))}.UserData;
                cellMoves(cellfun(@isempty, cellMoves)) = [];
                if any(cellfun(@(vec)(isequal(vecKing, vec)), cellMoves))
                    msgbox('Draw! Neither Wins!');
                else
                    msgbox('Checkmate! White Wins!');
                end
                cellfun(@d, cellControls, 'uni', false);
                hNew = figure('Name', 'Game Complete', 'NumberTitle', 'off', 'menu', 'none', ...
                    'toolbar', 'none', 'Units', 'Normalized', 'Position', [.500 .500 .1 .05]);
                uicontrol(hNew, 'Style', 'pushbutton', 'String', 'New Game?', 'Units', 'Normalized', ...
                    'Position', [0 0 1 1], 'Callback', @pbNew, 'FontSize', 10.0, 'HorizontalAlignment', ...
                    'center');
            end
        else
            cellBlack = cellControls(cellfun(@findBlack, cellControls));
            cellfun(@dBlack, cellBlack, 'uni', false);
            strPlayed = cellMoveControls{2}.String;
            if isempty(strPlayed)
                intPlay = 0;
            else
                intPlay = str2double(strtok(strPlayed{end}, '.'));
            end
            strPlay = {[num2str(intPlay+1) '. ' strPlay]};
            strPlayed = [strPlayed; strPlay];
            cellMoveControls{2}.String = strPlayed;
            cellWhite = cellControls(cellfun(@findWhite, cellControls));
            cellWhite = cellfun(@(uic)(uic.UserData), cellWhite, 'uni', false);
            cellMoves = cellfun(@(vec)(possMoves(cellControls, vec)), cellWhite, 'uni', false);
            cellMoves(cellfun(@isempty, cellMoves)) = [];
            if isempty(cellMoves)
                cellBlack = cellControls(cellfun(@findBlack, cellControls));
                cellBlack = cellfun(@(uic)(uic.UserData), cellBlack, 'uni', false);
                cellMoves = cellfun(@(vec)(possMoves(cellControls, vec)), cellBlack, 'uni', false);
                vecKing = cellControls{strcmp('kingb', cellfun(@(uic)(uic.Tag), cellControls, 'uni', false))}.UserData;
                cellMoves(cellfun(@isempty, cellMoves)) = [];
                if any(cellfun(@(vec)(isequal(vecKing, vec)), cellMoves))
                    msgbox('Draw! Neither Wins!');
                else
                    msgbox('Checkmate! Black Wins!');
                end
                cellfun(@d, cellControls, 'uni', false);
                hNew = figure('Name', 'Game Complete', 'NumberTitle', 'off', 'menu', 'none', ...
                    'toolbar', 'none', 'Units', 'Normalized', 'Position', [.500 .500 .1 .05]);
                uicontrol(hNew, 'Style', 'pushbutton', 'String', 'New Game?', 'Units', 'Normalized', ...
                    'Position', [0 0 1 1], 'Callback', @pbNew, 'FontSize', 10.0, 'HorizontalAlignment', ...
                    'center');
            end
        end
        drawnow();
    end

    function dBlack(uic)
        uic.Enable = 'off';
    end

    function dWhite(uic)
        uic.Enable = 'off';
    end

    function d(uic)
        uic.Enable = 'off';
    end

    function e(uic)
        uic.Enable = 'on';
    end

    function logWhite = findWhite(uic)
        strTest = uic.Tag;
        if numel(uic.Tag) == 5
            logWhite = strTest(end) == 'w';
        else
            logWhite = false;
        end
    end

    function logBlack = findBlack(uic)
        strTest = uic.Tag;
        if numel(uic.Tag) == 5
            logBlack = strTest(end) == 'b';
        else
            logBlack = false;
        end
    end
    function cellOut = coord(cellC, vecPts)
        cellOut = cellC{vecPts(1), vecPts(2)};
    end

    function pbCallback(hObject, ~, vecPPosn)
        hPiece = cellControls{vecPPosn(1), vecPPosn(2)};
        strTag = hPiece.Tag;
        if strcmp(hObject.String, 'Queen')
            hPiece.String = 'Queen';
            hPiece.Tag = ['qenn' strTag(end)];
        elseif strcmp(hObject.String, 'Rook')
            hPiece.String = 'Rook';
            hPiece.Tag = ['rook' strTag(end)];
        elseif strcmp(hObject.String, 'Bishop')
            hPiece.String = 'Bishop';
            hPiece.Tag = ['bish' strTag(end)];
        elseif strcmp(hObject.String, 'Knight')
            hPiece.String = 'Knight';
            hPiece.Tag = ['knit' strTag(end)];
        end
        delete(hObject.Parent);
    end

    function pbNew(hObject, ~)
        cellMoveControls{1}.String = {};
        cellMoveControls{2}.String = {};
        delete(hObject.Parent);
        newGame(cellControls);
    end

    function uiNew(~, ~)
        cellMoveControls{1}.String = {};
        cellMoveControls{2}.String = {};
        newGame(cellControls);
    end

    function uiSave(~, ~)
        cellTags = cellfun(@(uic)(uic.Tag), cellControls, 'uni', false); %#ok<NASGU>
        cellStrs = {cellMoveControls{1}.String, cellMoveControls{2}.String}; %#ok<NASGU>
        save('saveGame.mat', 'cellTags', 'cellStrs');
        msgbox('Game Saved!', 'Chess');
    end

    function uiLoad(~, ~)
        try
            stcData = load('saveGame.mat');
            cellTags = stcData.cellTags;
            cellStrs = stcData.cellStrs;
            setupGame(cellControls, cellMoveControls, cellTags, cellStrs);
            msgbox('Load Successful!', 'Chess');
        catch
            msgbox('No valid save file found!', 'Chess')
        end
    end
end

function uiClose(~, ~)
    hMoves = findobj('Tag', 'uiChessMoves');
    if ~isempty(hMoves)
        delete(hMoves);
    end
    hChess = findobj('Tag', 'uiChessBoard');
    delete(hChess);
end

function uiNorm(uic)
    uic.Units = 'Normalized';
end