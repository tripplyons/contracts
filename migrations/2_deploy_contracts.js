var PasswordProtectedEther = artifacts.require("./PasswordProtectedEther")
var TicTacToeGambler = artifacts.require("./TicTacToeGambler")

module.exports = function(deployer, network, accounts) {
  deployer.deploy(PasswordProtectedEther)
  deployer.deploy(TicTacToeGambler, accounts[1], 0)
};
