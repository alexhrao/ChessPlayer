function [cellMoves, cellCastle, cellEP] = possMoves(cellBoard, strPosn)
% arrBoard - a 8x8 cell array, with these specifications:
%   Top of board is player 2; bottom is player 1.
%   'pawnw', 'pawnb' --> A pawn, for player 1 or 2, respectively
%   'rookw', 'rookb' --> A rook, for player 1 or 2, respectively
%   'knitw', 'knitb' --> A knight, for player 1 or 2, respectively
%   'bish1', 'bishb' --> A bishop, for player 1 or 2, respectively
%   'king1', 'kingb' --> A king, for player 1 or 2, respectively
%   'qenn1', 'qennb' --> A queen, for player 1 or 2, respectively
% vecPosn - a 1x2 char of the position, given in standard chess notation,
% OR a vector representing the position in terms of row-and-file notation
% (ie, [3, 2] --> 'c2').
%
%   arrMoves - an nx1 cell array of moves in whatever the input notation
%   was.
if ischar(strPosn)
    logChar = true;
    vecPosn = chess2mat(strPosn);
else
    vecPosn = strPosn;
    logChar = false;
end
strPiece = cellBoard{vecPosn(1), vecPosn(2)}.Tag;
[cellMoves, cellCastle, cellEP] = deal({});
if isempty(strPiece)
    cellMoves = cell(1, 0);
    
elseif strcmp(strPiece, 'pawnw')
    if vecPosn(1) == 9; % --> NOT 8 so that we don't constantly open figure!
        % This should go somewhere else!

    elseif vecPosn(1) < 8 && isempty(cellBoard{vecPosn(1) + 1, vecPosn(2)}.Tag)
        cellMoves{end+1} = vecPosn + [1 0];
        if vecPosn(1) == 2 && isempty(cellBoard{vecPosn(1) + 2, vecPosn(2)}.Tag)
            cellMoves{end+1} = vecPosn + [2 0];
        end
    end
    if vecPosn(1) < 8
        ind1 = vecPosn + [1 1];
        ind2 = vecPosn + [1 -1];
        cellInds = {ind1, ind2};
        cellInds(~cellfun(@inBounds, cellInds)) = [];
        logEnemy = cellfun(@(vec)(~isempty(cellBoard{vec(1), vec(2)}.Tag)), cellInds);
        cellInds(~logEnemy) = [];
        logEnemy(~logEnemy) = [];
        strTaken = cellfun(@(vec)(cellBoard{vec(1), vec(2)}.Tag), cellInds(logEnemy), 'uni', false);
        logTrans = logEnemy(logEnemy);
        logTrans(cellfun(@(str)(str(end) ~= strPiece(end)), strTaken)) = false;
        logEnemy(logEnemy) = logTrans;
        cellInds(logEnemy) = [];
        if numel(cellInds) == 1;
            cellMoves(end+1) = cellInds;
        elseif numel(cellInds) == 2
            cellMoves((end+1):(end+2)) = cellInds;
        end
    end
    
elseif strcmp(strPiece, 'pawnb')
    if vecPosn(1) > 1 && isempty(cellBoard{vecPosn(1) - 1, vecPosn(2)}.Tag)
        cellMoves{end+1} = vecPosn + [-1 0];
        if vecPosn(1) == 7 && isempty(cellBoard{vecPosn(1) - 2, vecPosn(2)}.Tag)
            cellMoves{end+1} = vecPosn + [-2 0];
        end
    end
    if vecPosn(1) > 1
        ind1 = vecPosn + [-1 1];
        ind2 = vecPosn + [- 1 -1];
        cellInds = {ind1, ind2};
        cellInds(~cellfun(@inBounds, cellInds)) = [];
        logEnemy = cellfun(@(vec)(~isempty(cellBoard{vec(1), vec(2)}.Tag)), cellInds);
        cellInds(~logEnemy) = [];
        logEnemy(~logEnemy) = [];
        strTaken = cellfun(@(vec)(cellBoard{vec(1), vec(2)}.Tag), cellInds(logEnemy), 'uni', false);
        cellInds(~logEnemy) = [];
        logTrans = logEnemy(logEnemy);
        logTrans(cellfun(@(str)(str(end) ~= strPiece(end)), strTaken)) = false;
        logEnemy(logEnemy) = logTrans;
        cellInds(logEnemy) = [];
        if numel(cellInds) == 1;
            cellMoves(end+1) = cellInds;
        elseif numel(cellInds) == 2
            cellMoves((end+1):(end+2)) = cellInds;
        end
    end
    
elseif strncmp(strPiece, 'rook', 4)
    nN = 9 - vecPosn(1);
    vecPoss = zeros(2, nN);
    vecPoss(1, :) = vecPosn(1):8;
    vecPoss(2, :) = vecPosn(2);
    indN = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indN(1) = nN;
    if numel(indN) > 1
        vecTest = vecPoss(:, indN(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indN(end) = indN(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indN(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);
    
    nS = vecPosn(1);
    vecPoss = zeros(2, nS);
    vecPoss(1, :) = vecPosn(1):-1:1;
    vecPoss(2, :) = vecPosn(2);
    indS = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indS(1) = nS;
    if numel(indS) > 1
        vecTest = vecPoss(:, indS(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indS(end) = indS(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indS(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);  
    
    nE = 9 - vecPosn(2);
    vecPoss = zeros(2, nE);
    vecPoss(1, :) = vecPosn(1);
    vecPoss(2, :) = vecPosn(2):8;
    indE = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indE(1) = nE;
    if numel(indE) > 1
        vecTest = vecPoss(:, indE(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indE(end) = indE(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indE(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);
    
    nW = vecPosn(2);
    vecPoss = zeros(2, nW);
    vecPoss(1, :) = vecPosn(1);
    vecPoss(2, :) = vecPosn(2):-1:1;
    indW = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indW(1) = nW;
    if numel(indW) > 1
        vecTest = vecPoss(:, indW(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indW(end) = indW(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indW(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);
    
elseif strncmp(strPiece, 'knit', 4)
    ind1 = vecPosn + [2 1];
    ind2 = vecPosn + [1 2];
    ind3 = vecPosn + [-1 2];
    ind4 = vecPosn + [-2 1];
    ind5 = vecPosn + [-2 -1];
    ind6 = vecPosn + [-1 -2];
    ind7 = vecPosn + [1 -2];
    ind8 = vecPosn + [2 -1];
    cellInds = {ind1, ind2, ind3, ind4, ind5, ind6, ind7, ind8};
    cellInds(~cellfun(@inBounds, cellInds)) = [];
    logTaken = cellfun(@(vec)(~isempty(cellBoard{vec(1), vec(2)}.Tag)), cellInds);
    strTaken = cellfun(@(vec)(cellBoard{vec(1), vec(2)}.Tag), cellInds(logTaken), 'uni', false);
    logTrans = logTaken(logTaken);
    logTrans(cellfun(@(str)(str(end) ~= strPiece(end)), strTaken)) = false;
    logTaken(logTaken) = logTrans;
    cellInds(logTaken) = [];
    [cellMoves{(end+1):(end+numel(cellInds))}] = deal(cellInds{:});
    
elseif strncmp(strPiece, 'bish', 4)
    nNE = 9 - max(vecPosn);
    vecPoss = zeros(2, nNE);
    vecPoss(1, :) = vecPosn(1):(vecPosn(1) + nNE - 1);
    vecPoss(2, :) = vecPosn(2):(vecPosn(2) + nNE - 1);
    indNE = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indNE(1) = nNE;
    if numel(indNE) > 1
        vecTest = vecPoss(:, indNE(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indNE(end) = indNE(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indNE(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);
    
    nSW = min(vecPosn);
    vecPoss = zeros(2, nSW);
    vecPoss(1, :) = vecPosn(1):-1:(vecPosn(1) - nSW + 1);
    vecPoss(2, :) = vecPosn(2):-1:(vecPosn(2) - nSW + 1);
    indSW = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indSW(1) = nSW;
    if numel(indSW) > 1
        vecTest = vecPoss(:, indSW(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indSW(end) = indSW(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indSW(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);
    
    nNW = min([9 - vecPosn(1), vecPosn(2)]);
    vecPoss = zeros(2, nNW);
    vecPoss(1, :) = vecPosn(1):(vecPosn(1) + nNW - 1);
    vecPoss(2, :) = vecPosn(2):-1:(vecPosn(2) - nNW + 1);
    indNW = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indNW(1) = nNW;
    if numel(indNW) > 1
        vecTest = vecPoss(:, indNW(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indNW(end) = indNW(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indNW(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);
    
    nSE = min([vecPosn(1), 9 - vecPosn(2)]);
    vecPoss = zeros(2, nSE);
    vecPoss(1, :) = vecPosn(1):-1:(vecPosn(1) - nSE + 1);
    vecPoss(2, :) = vecPosn(2):(vecPosn(2) + nSE - 1);
    indSE = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indSE(1) = nSE;
    if numel(indSE) > 1
        vecTest = vecPoss(:, indSE(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indSE(end) = indSE(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indSE(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);

elseif strncmp(strPiece, 'qenn', 4)
    nNE = 9 - max(vecPosn);
    vecPoss = zeros(2, nNE);
    vecPoss(1, :) = vecPosn(1):(vecPosn(1) + nNE - 1);
    vecPoss(2, :) = vecPosn(2):(vecPosn(2) + nNE - 1);
    indNE = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indNE(1) = nNE;
    if numel(indNE) > 1
        vecTest = vecPoss(:, indNE(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indNE(end) = indNE(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indNE(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);
    
    nSW = min(vecPosn);
    vecPoss = zeros(2, nSW);
    vecPoss(1, :) = vecPosn(1):-1:(vecPosn(1) - nSW + 1);
    vecPoss(2, :) = vecPosn(2):-1:(vecPosn(2) - nSW + 1);
    indSW = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indSW(1) = nSW;
    if numel(indSW) > 1
        vecTest = vecPoss(:, indSW(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indSW(end) = indSW(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indSW(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);
    
    nNW = min([9 - vecPosn(1), vecPosn(2)]);
    vecPoss = zeros(2, nNW);
    vecPoss(1, :) = vecPosn(1):(vecPosn(1) + nNW - 1);
    vecPoss(2, :) = vecPosn(2):-1:(vecPosn(2) - nNW + 1);
    indNW = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indNW(1) = nNW;
    if numel(indNW) > 1
        vecTest = vecPoss(:, indNW(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indNW(end) = indNW(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indNW(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);
    
    nSE = min([vecPosn(1), 9 - vecPosn(2)]);
    vecPoss = zeros(2, nSE);
    vecPoss(1, :) = vecPosn(1):-1:(vecPosn(1) - nSE + 1);
    vecPoss(2, :) = vecPosn(2):(vecPosn(2) + nSE - 1);
    indSE = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indSE(1) = nSE;
    if numel(indSE) > 1
        vecTest = vecPoss(:, indSE(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indSE(end) = indSE(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indSE(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);
    
    nN = 9 - vecPosn(1);
    vecPoss = zeros(2, nN);
    vecPoss(1, :) = vecPosn(1):8;
    vecPoss(2, :) = vecPosn(2);
    indN = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indN(1) = nN;
    if numel(indN) > 1
        vecTest = vecPoss(:, indN(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indN(end) = indN(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indN(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);
    
    nS = vecPosn(1);
    vecPoss = zeros(2, nS);
    vecPoss(1, :) = vecPosn(1):-1:1;
    vecPoss(2, :) = vecPosn(2);
    indS = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indS(1) = nS;
    if numel(indS) > 1
        vecTest = vecPoss(:, indS(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indS(end) = indS(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indS(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);  
    
    nE = 9 - vecPosn(2);
    vecPoss = zeros(2, nE);
    vecPoss(1, :) = vecPosn(1);
    vecPoss(2, :) = vecPosn(2):8;
    indE = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indE(1) = nE;
    if numel(indE) > 1
        vecTest = vecPoss(:, indE(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indE(end) = indE(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indE(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);
    
    nW = vecPosn(2);
    vecPoss = zeros(2, nW);
    vecPoss(1, :) = vecPosn(1);
    vecPoss(2, :) = vecPosn(2):-1:1;
    indW = find(fliplr(cellfun(@(uic)(~isempty(uic.Tag)), fliplr(cellCoord(cellBoard, vecPoss)))), 2);
    indW(1) = nW;
    if numel(indW) > 1
        vecTest = vecPoss(:, indW(end));
        strTest = cellBoard{vecTest(1), vecTest(2)}.Tag;
        if strTest(end) == strPiece(end)
            indW(end) = indW(end) - 1;
        end
    end
    vecPoss = vecPoss(:, 1:indW(end));
    cellMoves((end+1):(end+size(vecPoss, 2))) = arrayfun(@(int1, int2)([int1, int2]), vecPoss(1, :), vecPoss(2, :), 'uni', false);
    
elseif strncmp(strPiece, 'king', 4)
    ind1 = vecPosn + [1 0];
    ind2 = vecPosn + [1 1];
    ind3 = vecPosn + [0 1];
    ind4 = vecPosn + [-1 1];
    ind5 = vecPosn + [-1 0];
    ind6 = vecPosn + [-1 -1];
    ind7 = vecPosn + [0 -1];
    ind8 = vecPosn + [1 -1];
    cellInds = {ind1, ind2, ind3, ind4, ind5, ind6, ind7, ind8};
    cellInds(~cellfun(@inBounds, cellInds)) = [];
    logTaken = cellfun(@(vec)(~isempty(cellBoard{vec(1), vec(2)}.Tag)), cellInds);
    strTaken = cellfun(@(vec)(cellBoard{vec(1), vec(2)}.Tag), cellInds(logTaken), 'uni', false);
    logTrans = logTaken(logTaken);
    logTrans(cellfun(@(str)(str(end) ~= strPiece(end)), strTaken)) = false;
    logTaken(logTaken) = logTrans;
    cellInds(logTaken) = [];
    [cellMoves{(end+1):(end+numel(cellInds))}] = deal(cellInds{:});
    
    % the inds here assume that the ROOKS AND KING HAVE NOT BEEN MOVED. To
    % make this distinction, each entry will actually be a cell array in
    % and of itself, with the first entry saying 'ca<lr>', where l and r is
    % either a left castle or right castle, and the second and third entries 
    % signify the new positions of the king and castle, respectively.
    if nargout > 1
        if vecPosn(2) == 5
            cellTags = cellfun(@(uic)(uic.Tag), cellBoard(vecPosn(1), [2 3 4 6 7]), 'uni', false);
            if all(cellfun(@isempty, cellTags(1:3)))
                if ~any([isCheck(cellBoard, vecPosn - [0 2], strPiece(end)), ...
                        isCheck(cellBoard, vecPosn - [0 1], strPiece(end)), ...
                        isCheck(cellBoard, vecPosn, strPiece(end))])
                    cellCastle{end+1} = {'cal', vecPosn - [0 2], [vecPosn(1), 4]};
                end
            end
            if all(cellfun(@isempty, cellTags(4:end)))
                if ~any([isCheck(cellBoard, vecPosn + [0 2], strPiece(end)), ...
                        isCheck(cellBoard, vecPosn + [0 1], strPiece(end)), ...
                        isCheck(cellBoard, vecPosn, strPiece(end))])
                    cellCastle{end+1} = {'car', vecPosn + [0 2], [vecPosn(1), 6]};
                end
            end
        end
    end
else
    cellMoves = {};
end
cellMoves(cellfun(@(vec)(isequal(vec, vecPosn)), cellMoves)) = [];
cellMoves(~cellfun(@(vec)(cellTest(cellBoard, vecPosn, vec)), cellMoves)) = [];
if isempty(cellMoves)
    cellMoves = {};
end
if logChar
    cellMoves = cellfun(@mat2chess, cellMoves, 'uni', false)';
else
    cellMoves = cellMoves';
end
end

function logBound = inBounds(vecPosn)
    logBound = all(vecPosn <= 8) && all(vecPosn >= 1);
end

function cellOut = cellCoord(cellIn, vecPts)
    f = @(int1, int2)(cellIn{int1, int2});
    cellOut = arrayfun(f, vecPts(1, :), vecPts(2, :), 'uni', false);
end

function logCheck = cellTest(cellBoard, vecOrig, vecMove)
    stcStack = dbstack;
    strStack = {stcStack(2:end).name};
    if any(strcmp(strStack, 'cellTest'))
        logCheck = true;
        return;
    end
    btnOrig = cellBoard{vecOrig(1), vecOrig(2)};
    strPiece = btnOrig.Tag;
    btnOrig.Tag = '';
    btnNew = cellBoard{vecMove(1), vecMove(2)};
    newPiece = btnNew.Tag;
    btnNew.Tag = strPiece;
    cellOpPieces = cellfun(@(uic)(uic.UserData), cellBoard(cellfun(@(uic)(~isempty(uic.Tag)), cellBoard)), 'uni', false);
    cellMoves = cellfun(@(vecP)(possMoves(cellBoard, vecP)), cellOpPieces, 'uni', false);
    cellMoves(cellfun(@isempty, cellMoves)) = [];
    cellMoves = cellfun(@(c)(c'), cellMoves', 'uni', false);
    cellMoves = [cellMoves{:}];
    vecKing = cellBoard{strcmp(cellfun(@(uic)(uic.Tag), cellBoard, 'uni', false), ['king' strPiece(end)])}.UserData;
    logCheck = all(cellfun(@(vec)(~isequal(vec, vecKing)), cellMoves));
    btnOrig.Tag = strPiece;
    btnNew.Tag = newPiece;
end