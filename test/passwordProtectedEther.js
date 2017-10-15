var PasswordProtectedEther =
    artifacts.require("./PasswordProtectedEther.sol")

const getBalance = (account) =>
    web3.eth.getBalance(account)

const password = "password"
const hash = web3.sha3(password)
const wrongPassword = ""
const wrongHash = web3.sha3(wrongPassword)
const amountOfEther = web3.toWei(1, "ether")

contract("PasswordProtectedEther", function(accounts) {
    var depositedInstance;
    it("should change the balance", function() {
        depositedInstance = PasswordProtectedEther.new()
        .then(function(instance) {
            return instance.deposit(
                hash, {
                    from: accounts[0],
                    value: amountOfEther
                }
            ).then(function() {
                return instance.balanceOfHash.call(hash)
                .then(function(balance) {
                    assert(
                        balance.equals(amountOfEther),
                        "The balance was different"
                    )
                    return instance
                })
            })
        })
    })
    it("should fail to withdraw with the wrong password",
    function() {
        depositedInstance.then(function(instance) {
            instance.withdraw.call(wrongPassword).then(function() {
                assert(false, "The ether was wrongly withdrawn")
            }).catch(function() {
                assert(true)
            })
        })
    })
    it("should withdraw with the right password", function() {
        depositedInstance.then(function(instance) {
            instance.withdraw(password, {
                from: accounts[0]
            }).then(function() {
                assert(true)
            }).catch(function() {
                assert(false, "The ether was not withdrawn")
            })
        })
    })
})
