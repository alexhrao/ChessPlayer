function logCheck = isCheck(cellBoard, vecPosn, strColor)
% Given a board and a position, see if the position is checked, according
% to the given color.

if strColor == 'w';
    cellEnemy = cellBoard(cellfun(@findBlack, cellBoard));
else
    cellEnemy = cellBoard(cellfun(@findWhite, cellBoard));
end

cellMoves = cellfun(@(vec)(possMoves(cellBoard, vec)), cellEnemy, 'uni', false);
cellMoves(cellfun(@isempty, cellMoves)) = [];
cellMoves = cellfun(@(c)(c'), cellMoves', 'uni', false);
cellMoves = [cellMoves{:}];
logCheck = any(cellfun(@(vec)(isequal(vec, vecPosn)), cellMoves));

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