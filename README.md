# Ethereum Smart Contracts (Untested)

**Notice:** These contracts are currently not tested because I am having trouble
figuring out how to test them.

## What is ethereum?

[Ethereum](https://ethereum.org/) is a blockchain application platform. Ethereum
takes Bitcoin's blockchain to the next level with smart contracts, programmable
transactions. This repository contains a few that I made. Ethereum has a
built-in currency called Ether.

## Contract Descriptions

- [gambler.sol](gambler.sol) - A generalized gambling contract
- [TicTacToeGambler.sol](TicTacToeGambler.sol) - Gamble on Tic-Tac-Toe, don't use this because
Tic-Tac-Toe is a solved game and will always tie when played optimally.
- [passwordProtectedEther.sol](passwordProtectedEther.sol) - Send Ether to this contract with the hash of your
withdraw password, and send the password to withdraw your Ether. This
demonstrates how you can use hashes as secure proof even on a public network
like Ethereum.
- [pennyAuction.sol](pennyAuction.sol) - A penny auction built on Ethereum. In a penny auction,
you have to pay to bid even if you do not win, you can only up the bid in a
certain incrument, and the auction only ends when no one has bidded for some
amount of time.
