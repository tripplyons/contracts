/// @title Ether Doubler Ponzi Scheme
/// @author Tripp Lyons

// solidity version
pragma solidity 0.4.15;

// pay 0.05 ether to the address, and it will pay you 1.9x the ether ...
// ... with ether from users that pay after you
contract Doubler {
    address public owner;
    // how the ether is distributed
    uint inAmount = 100 finney;
    uint outAmount = 190 finney;
    uint ownerAmount = 10 finney;

    // a log of all senders ever
    address[] public senders;
    // which sender is next
    uint public indexOfReceiver;
    address public currentReceiver;
    // the amout of ether raised for them
    uint etherTowardsNext;

    function Doubler() {
        owner = msg.sender;
        senders.push(owner);
        indexOfReceiver = 0;
        etherTowardsNext = 0;
        currentReceiver = owner;
    }

    // exact amount of ether amount to execute function
    modifier costs(uint _amount) {
        require(msg.value >= _amount);
        _;
        if (msg.value > _amount)
            msg.sender.transfer(msg.value - _amount);
    }

    // need to be owner to do functions with this
    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }

    // add anyone who pays the amount to the contract
    function () payable costs(inAmount) {
        senders.push(msg.sender);
        // they are half-way more funded, keep track of that
        etherTowardsNext += outAmount / 2;
        if(etherTowardsNext >= outAmount) {
            etherTowardsNext -= outAmount;
            // remember the receiver
            address receiver = currentReceiver;
            // make the next person in line the receiver
            indexOfReceiver += 1;
            currentReceiver = senders[indexOfReceiver];
            // pay out the old receiver
            receiver.transfer(outAmount);
        }
    }

    function withdraw() ownerOnly {
        owner.transfer(this.balance - etherTowardsNext);
    }
}
