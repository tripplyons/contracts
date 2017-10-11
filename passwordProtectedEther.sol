/// @title Password-Protected Ether
/// @author Tripp Lyons

// solidity version
pragma solidity ^0.4.17;

// send ether to the contract with the hash of your withdraw password
// to withdraw ether, send the password, and it will check if the ...
// ... hashes match
// WARNING: use a non-existent password because your password is sent ...
// ... publicly during withdrawl
contract PasswordProtectedEther {
    // store the balance of all 2^256 possible hashes (hard to crack)
    mapping (bytes32 => uint) public balanceOfHash;

    // pay ether to this function with the hash of your withdraw password
    function deposit(
        bytes32 passwordHash
    ) public payable {
        // make sure there is ether being sent in
        require(msg.value > 0);
        // make sure it doesn't overflow
        require(
            balanceOfHash[passwordHash] + msg.value
            > balanceOfHash[passwordHash]
        );
        // add the ether
        balanceOfHash[passwordHash] += msg.value;
    }

    // take all ether out by sending the password
    function withdraw(
        string password
    ) public {
        require(bytes(password).length > 0);
        bytes32 hashToCheck = keccak256(password);
        // make sure that there is ether in the hash's balance
        require(balanceOfHash[hashToCheck] > 0);
        // send over the ether
        msg.sender.transfer(balanceOfHash[hashToCheck]);
        // make sure that ether can't be sent again
        balanceOfHash[hashToCheck] = 0;
    }
}
