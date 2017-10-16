/// @title Gambler
/// @author Tripp Lyons

// solidity version
pragma solidity 0.4.15;

// generalized game gambling manager
contract Gambler {
    // the creator of the contract
    address public creator;
    // the player that plays against the creator
    address public opponent;
    // is it the creators turn?
    bool public isCreatorsTurn;

    bool public gameStarted;

    uint public timeOfLastTurn;
    // the amount of ether that each player bet
    uint public creatorBet;
    uint public opponentBet;
    // accepted the bet?
    bool public creatorAccepted;
    bool public opponentAccepted;
    // if a player takes longer to move, then they are disqualified
    uint public timePerTurn;

    event GameStart();
    event GameEnd(WinState winState);

    function Gambler(_creator, _opponent, _timePerTurn) {
        creator = _creator;
        opponent = _opponent;

        // creator goes first
        isCreatorsTurn = true;

        // don't start now, players haven't betted yet
        timeOfLastTurn = 0;
        gameStarted = false;

        timePerTurn = _timePerTurn;

        // default bets to 0
        creatorBet = 0;
        opponentBet = 0;

        // neither player has accpeted the bet yet
        creatorAccepted = false;
        opponentAccepted = false;
    }

    // anyone can put ether in to go to the winner
    function bet() public payable {
        require(msg.value > 0);
        if(msg.sender == creator) {
            creatorBet += msg.value;
        }
        if(msg.sender == opponent) {
            opponentBet += msg.value;
        }
    }

    function acceptBet() public {
        if(msg.sender == creator) {
            creatorAccepted = true;
        }
        if(msg.sender == opponent) {
            opponentAccepted = true;
        }
        // start when both players have accepted the bet
        if(creatorAccepted && opponentAccepted) {
            GameStart();
            gameStarted = true;
        }
    }

    function cancelBet() public {
        // either player can cancel the bet if they do not like the deal
        require(msg.sender == creator || msg.sender == opponent);
        // send back the bets
        creator.transfer(creatorBet);
        opponent.transfer(opponentBet);
    }

    // make sure to call this if your opponent takes too long
    function checkDisqualification() public {
        if((now - timeOfLastTurn) > timePerTurn) {
            if(isCreatorsTurn) {
                opponentWin();
            } else {
                creatorWin();
            }
        }
    }

    function creatorWin() internal {
        selfdestruct(creator);
    }

    function opponentWin() internal {
        selfdestruct(opponent);
    }

    function tie() internal {
        // make sure that the extra money paid to the contract by ...
        // ... non-players is split like the bet
        var betFromPlayers = creatorBet + opponentBet;
        creator.transfer(creatorBet / betFromPlayers * this.balance);
        opponent.transfer(opponentBet / betFromPlayers * this.balance);
        // there should only be a few wei left from flooring
        selfdestruct(creator);
    }

    // toggle whose turn it is and restart the timer for them
    function nextTurn() internal {
        isCreatorsTurn = !isCreatorsTurn;
        timeOfLastTurn = now;
    }
}
