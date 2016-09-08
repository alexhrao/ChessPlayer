function main()
    if isempty(findobj('Tag', 'uiChessBoard'))
        [~, cellMoves] = createMoves();
        [~, cellBoard] = createBoard(cellMoves);
        newGame(cellBoard);
    else
        figure(findobj('Tag', 'uiChessBoard'));
        figure(findobj('Tag', 'uiChessMoves'));
    end
end