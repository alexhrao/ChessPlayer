function newGame(cellControls)
cellWhite = cellControls(1:2, :);
cellBlack = cellControls(8:-1:7, :);
fCombine = @(int1, int2)([int1, int2]);
[cc, rr] = meshgrid(1:8, 3:6);
cellInts = arrayfun(fCombine, rr, cc, 'uni', false);
cellfun(@disableTile, cellControls(3:6, :), cellInts, 'uni', false);
cellfun(@pawnW, cellWhite(2, :), num2cell(1:8), 'uni', false);
cellfun(@pawnB, cellBlack(2, :), num2cell(1:8), 'uni', false);
cellfun(@rookW, cellWhite(1, [1 end]), num2cell([1, 8]), 'uni', false);
cellfun(@rookB, cellBlack(1, [1 end]), num2cell([1, 8]), 'uni', false);
cellfun(@knightW, cellWhite(1, [2 end-1]), num2cell([2, 7]), 'uni', false);
cellfun(@knightB, cellBlack(1, [2 end-1]), num2cell([2, 7]), 'uni', false);
cellfun(@bishopW, cellWhite(1, [3 end-2]), num2cell([3, 6]), 'uni', false);
cellfun(@bishopB, cellBlack(1, [3 end-2]), num2cell([3, 6]), 'uni', false);
queenW(cellWhite{1, 4});
queenB(cellBlack{1, 4});
kingW(cellWhite{1, 5});
kingB(cellBlack{1, 5});
end

function pawnW(uic, int1)
uic.Tag = 'pawnw';
uic.String = 'Pawn';
uic.ForegroundColor = [1 1 1];
uic.FontSize = 10.0;
uic.FontWeight = 'bold';
uic.UserData = [2, int1];
uic.Enable = 'on';
end

function pawnB(uic, int1)
uic.Tag = 'pawnb';
uic.String = 'Pawn';
uic.ForegroundColor = [0 0 0];
uic.FontSize = 10.0;
uic.FontWeight = 'bold';
uic.UserData = [7, int1];
uic.Enable = 'off';
end

function rookW(uic, int1)
uic.Tag = 'rookw';
uic.String = 'Rook';
uic.ForegroundColor = [1 1 1];
uic.FontSize = 10.0;
uic.FontWeight = 'bold';
uic.UserData = [1, int1];
uic.Enable = 'on';
end

function rookB(uic, int1)
uic.Tag = 'rookb';
uic.String = 'Rook';
uic.ForegroundColor = [0 0 0];
uic.FontSize = 10.0;
uic.FontWeight = 'bold';
uic.UserData = [8, int1];
uic.Enable = 'off';
end

function knightW(uic, int1)
uic.Tag = 'knitw';
uic.String = 'Knight';
uic.ForegroundColor = [1 1 1];
uic.FontSize = 10.0;
uic.FontWeight = 'bold';
uic.UserData = [1, int1];
uic.Enable = 'on';
end

function knightB(uic, int1)
uic.Tag = 'knitb';
uic.String = 'Knight';
uic.ForegroundColor = [0 0 0];
uic.FontSize = 10.0;
uic.FontWeight = 'bold';
uic.UserData = [8, int1];
uic.Enable = 'off';
end

function bishopW(uic, int1)
uic.Tag = 'bishw';
uic.String = 'Bishop';
uic.ForegroundColor = [1 1 1];
uic.FontSize = 10.0;
uic.FontWeight = 'bold';
uic.UserData = [1, int1];
uic.Enable = 'on';
end

function bishopB(uic, int1)
uic.Tag = 'bishb';
uic.String = 'Bishop';
uic.ForegroundColor = [0 0 0];
uic.FontSize = 10.0;
uic.FontWeight = 'bold';
uic.UserData = [8, int1];
uic.Enable = 'off';
end

function queenW(uic)
uic.Tag = 'qennw';
uic.String = 'Queen';
uic.ForegroundColor = [1 1 1];
uic.FontSize = 10.0;
uic.FontWeight = 'bold';
uic.UserData = [1, 4];
uic.Enable = 'on';
end

function queenB(uic)
uic.Tag = 'qennb';
uic.String = 'Queen';
uic.ForegroundColor = [0 0 0];
uic.FontSize = 10.0;
uic.FontWeight = 'bold';
uic.UserData = [8, 4];
uic.Enable = 'off';
end

function kingW(uic)
uic.Tag = 'kingw';
uic.String = 'King';
uic.ForegroundColor = [1 1 1];
uic.FontSize = 10.0;
uic.FontWeight = 'bold';
uic.UserData = [1, 5];
uic.Enable = 'on';
end

function kingB(uic)
uic.Tag = 'kingb';
uic.String = 'King';
uic.ForegroundColor = [0 0 0];
uic.FontSize = 10.0;
uic.FontWeight = 'bold';
uic.UserData = [8, 5];
uic.Enable = 'off';
end

function disableTile(uic, ind)
uic.Enable = 'off';
uic.String = '';
uic.Tag = '';
uic.FontSize = 10.0;
uic.FontWeight = 'bold';
uic.UserData = ind;
end