var PasswordProtectedEther = artifacts.require("./PasswordProtectedEther")

module.exports = function(deployer) {
  deployer.deploy(PasswordProtectedEther)
};
