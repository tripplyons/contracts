/// @title Penny Auction
/// @author Tripp Lyons

// solidity version
pragma solidity 0.4.17;

// in a penny auction, you have to pay the amount to bid, and ...
// ... the auction ends when no one bids for some amount of time
contract PennyAuction {
    address public seller;
    uint public startTime;
    uint public maxTimeBetweenBids;
    bool public acceptingBids;

    // last bid variables
    uint public lastBid;
    address public lastBidder;
    uint public timeOfLastBid;
    uint public incrument;

    event AuctionEnd(address highestBidder, uint bid);

    function PennyAuction(
        uint _maxTimeBetweenBids,
        uint _startTime,
        uint _incrument
    ) public payable {
        acceptingBids = false;
        seller = msg.sender;
        maxTimeBetweenBids = _maxTimeBetweenBids;

        // default 0 to starting immediately
        if(_startTime == 0) {
            startTime = now;
            acceptingBids = true;
        } else {
            startTime = _startTime;
        }

        // default incrument to 1 finney (1/1000 of an ether)
        if(_incrument == 0) {
            incrument = 1 finney;
        } else {
            incrument = _incrument;
        }
    }

    function isAcceptingBids() public constant returns (bool) {
        return acceptingBids;
    }

    // keeps all ether including amount over the required amount
    function bid() public payable {
        require(now >= startTime);

        // update the status of the auction
        if(timeOfLastBid != 0 && now - timeOfLastBid > maxTimeBetweenBids) {
            // auction ended, update everything and send ether back to ...
            // ... anyone who bidded after
            if(acceptingBids) {
                acceptingBids = false;
                AuctionEnd(lastBidder, lastBid);
            }
            msg.sender.transfer(msg.value);
            return;
        } else {
            // the auction might not have started, start it
            acceptingBids = true;
        }

        require(acceptingBids);

        // make sure that enough is being recieved
        require(msg.value >= lastBid + incrument);

        // update the highest bid
        lastBid += incrument;
        lastBidder = msg.sender;
        timeOfLastBid = now;
    }
}
