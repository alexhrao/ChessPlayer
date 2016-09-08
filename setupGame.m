function setupGame(cellControls, cellMoveControls, cellTags, cellStrs)
    newGame(cellControls);
    cellMoveControls{1}.String = cellStrs{1};
    cellMoveControls{2}.String = cellStrs{2};
    cellfun(@uiRep, cellControls, cellTags, 'uni', false);
    if numel(cellStrs{1}) == numel(cellStrs{2})
        cellBlack = cellControls(cellfun(@findBlack, cellControls));
        cellfun(@d, cellBlack, 'uni', false);
    else
        cellWhite = cellControls(cellfun(@findWhite, cellControls));
        cellfun(@d, cellWhite, 'uni', false);
    end
end

function uiRep(uicOr, strNew)
    uicOr.Tag = strNew;
    if strcmp(strNew, '')
        uicOr.String = '';
        uicOr.Enable = 'off';
    elseif strncmp(strNew, 'pawn', 4)
        uicOr.String = 'Pawn';
        uicOr.Enable = 'on';
    elseif strncmp(strNew, 'knit', 4)
        uicOr.String = 'Knight';
        uicOr.Enable = 'on';
    elseif strncmp(strNew, 'bish', 4)
        uicOr.String = 'Bishop';
        uicOr.Enable = 'on';
    elseif strncmp(strNew, 'rook', 4)
        uicOr.String = 'Rook';
        uicOr.Enable = 'on';
    elseif strncmp(strNew, 'qenn', 4)
        uicOr.String = 'Queen';
        uicOr.Enable = 'on';
    elseif strncmp(strNew, 'king', 4)
        uicOr.String = 'King';
        uicOr.Enable = 'on';
    end
    if ~isempty(strNew)
        if strNew(end) == 'w'
            uicOr.ForegroundColor = [1 1 1];
        else
            uicOr.ForegroundColor = [0 0 0];
        end
    end
end

    function logWhite = findWhite(uic)
        strTest = uic.Tag;
        if numel(uic.Tag) == 5
            logWhite = strTest(end) == 'w';
        else
            logWhite = false;
        end
    end

    function logWhite = findBlack(uic)
        strTest = uic.Tag;
        if numel(uic.Tag) == 5
            logWhite = strTest(end) == 'b';
        else
            logWhite = false;
        end
    end
    
    function d(uic)
        uic.Enable = 'off';
    end