/// @title TicTacToe Gambler
/// @author Tripp Lyons

// solidity version
pragma solidity 0.4.15;

import "./gambler.sol";

// creator is X, opponent is O
contract TicTacToeGambler is Gambler {
    enum BoardSpace { Empty, X, O }
    enum WinState { Neither, X, O, Tie }
    // board:
    // 0 1 2
    // 3 4 5
    // 6 7 8
    BoardSpace[9] public board;

    function TicTacToeGambler(
        address _opponent,
        uint _timePerTurn
    ) public {
        creator = msg.sender;
        opponent = _opponent;

        // creator goes first
        isCreatorsTurn = true;

        // don't start now, players haven't betted yet
        timeOfLastTurn = 0;
        gameStarted = false;

        // default bets to 0
        creatorBet = 0;
        opponentBet = 0;

        // neither player has accpeted the bet yet
        creatorAccepted = false;
        opponentAccepted = false;

        // default to 120 seconds (2 minutes)
        timePerTurn = _timePerTurn;
        if(timePerTurn == 0) {
            timePerTurn = 120;
        }

        // initialize the board
        board = [
            BoardSpace.Empty, BoardSpace.Empty, BoardSpace.Empty,
            BoardSpace.Empty, BoardSpace.Empty, BoardSpace.Empty,
            BoardSpace.Empty, BoardSpace.Empty, BoardSpace.Empty
        ];
    }

    // do your turn, place X or O at `position`
    function turn(uint position) public {
        // make sure the sender is a player
        require(msg.sender == creator || msg.sender == opponent);
        // validate position
        require(position >= 0 && position < 9);
        // creator's turn
        if(msg.sender == creator) {
            require(isCreatorsTurn);
            require(board[position] == BoardSpace.Empty);
            board[position] = BoardSpace.X;
        }
        // opponent's turn
        if(msg.sender == opponent) {
            require(!isCreatorsTurn);
            require(board[position] == BoardSpace.Empty);
            board[position] = BoardSpace.O;
        }
        // see the outcome of the game
        var gameState = checkForEnd();
        // handle end conditions if they exist
        if(gameState == WinState.Tie) {
            tie();
        }
        if(gameState == WinState.X) {
            creatorWin();
        }
        if(gameState == WinState.O) {
            opponentWin();
        }
    }

    // row win
    function checkForRowWin(
        BoardSpace symbol
    ) internal constant returns (bool win) {
        for(uint row = 0; row < 3; row++) {
            // no other symbols
            bool noOthers = true;
            for(uint col = 0; col < 3; col++) {
                if(board[row * 3 + col] != symbol) {
                    noOthers = false;
                }
            }
            if(noOthers) {
                return true;
            }
        }
        return false;
    }

    // column win
    function checkForColumnWin(
        BoardSpace symbol
    ) internal constant returns (bool win) {
        for(uint col = 0; col < 3; col++) {
            // no other symbols
            bool noOthers = true;
            for(uint row = 0; row < 3; row++) {
                if(board[row * 3 + col] != symbol) {
                    noOthers = false;
                }
            }
            if(noOthers) {
                return true;
            }
        }
        return false;
    }

    // diagonal wins
    function checkForDiagonalWins(
        BoardSpace symbol
    ) internal constant returns (bool win) {
        // diagonal down-right win
        bool downRightWin = true;
        for(uint i = 0; i < 3; i++) {
            if(board[i * 3 + i] != symbol) {
                downRightWin = false;
            }
        }
        if(downRightWin) {
            return true;
        }

        // diagonal down-left win
        bool downLeftWin = true;
        for(i = 0; i < 3; i++) {
            if(board[i * 3 + (2 - i)] != symbol) {
                downLeftWin = false;
            }
        }

        return downLeftWin;
    }

    function checkForWin(BoardSpace symbol) internal constant returns (bool win) {
        if(checkForRowWin(symbol)) {
            return true;
        }

        if(checkForColumnWin(symbol)) {
            return true;
        }


        return checkForDiagonalWins(symbol);
    }

    function checkForEnd() internal constant returns (WinState) {
        if(checkForWin(BoardSpace.X)) {
            return WinState.X;
        }
        if(checkForWin(BoardSpace.O)) {
            return WinState.O;
        }

        // then check if it is full (a tie)
        bool hasEncounteredEmpty = false;
        for(uint i = 0; i < 9; i++) {
            if(board[i] == BoardSpace.Empty) {
                hasEncounteredEmpty = true;
            }
        }
        // if it is, then tie
        if(!hasEncounteredEmpty) {
            return WinState.Tie;
        }

        return WinState.Neither;
    }
}
