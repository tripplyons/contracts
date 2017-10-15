var Doubler = artifacts.require("./Doubler.sol")

const getBalance = (account) =>
    web3.eth.getBalance(account)


contract('Doubler', function(accounts) {
    var owner = accounts[0]
    it("should set the owner correctly", function() {
        Doubler.deployed().then(function(instance) {
            assert.equal(instance.owner.call(), owner,
                "The owner was set incorrectly")
        })
    })
    it("should add the owner to the queue", function() {
        Doubler.deployed().then(function(instance) {
            assert.equal(
                instance.senders.call(instance.indexOfReciever.call()),
                owner,
                "The owner is not in the queue"
            );
        })
    })
    it("should make the owner the current reciever", function() {
        Doubler.deployed().then(function(instance) {
            assert.equal(instance.currentReceiver.call(), owner,
                "The current receiver is not the owner");
        })
    })
    it("should error when withdrawing to a non-owner", function() {
        Doubler.deployed().then(function(instance) {
            return instance.withdraw.call(accounts[1])
        }).then(function() {
            assert(false, "The withdraw occurred")
        }).catch(function() {
            assert(true)
        })
    })
    it("should not error when to withdrawing to the owner", function() {
        Doubler.deployed().then(function(instance) {
            return instance.withdraw.call(accounts[1])
        }).then(function() {
            assert(true)
        }).catch(function() {
            assert(false, "An error occurred when withdrawing")
        })
    })
    it("should accept 100 finney from accounts[1]", function() {
        // use deployed instance for later
        Doubler.deployed().then(function(instance) {
            instance.sendTransaction({
                from: accounts[1],
                value: web3.toWei(100, "finney")
            })
            .then(function() {
                assert(true)
            }).catch(function() {
                assert(false, "The finney was not accepted")
            })
        })
    })
    it("should not accept < 100 finney from accounts[1]", function() {
        Doubler.deployed().then(function(instance) {
            instance.sendTransaction({
                from: accounts[1],
                value: web3.toWei(99, "finney")
            })
            .then(function() {
                assert(false, "The finney was accepted")
            }).catch(function() {
                assert(true)
            })
        })
    })
    it("should give back the extra finney to accounts[2]", function() {
        // use new instance so paybacks can be tested later
        Doubler.new().then(function(instance) {
            var startBalance = getBalance(accounts[2])
            var amount = web3.toWei(200, "finney")
            instance.sendTransaction({
                from: accounts[2],
                value: amount
            })
            .then(function() {
                assert(getBalance(accounts[2]) > startBalance - amount,
                    "The extra finney was not sent back")
            })
        })
    })
    it("should pay back the owner after two accounts join", function() {
        Doubler.deployed().then(function(instance) {
            // check the owner's balance and see if it goes up after ...
            // ... accounts[2] joins
            var startBalance = getBalance(owner)
            instance.sendTransaction({
                from: accounts[2],
                value: web3.toWei(100, "finney")
            }).then(function() {
                setTimeout(function() {
                    var endBalance = getBalance(owner)
                    assert(endBalance > startBalance,
                        "The owner was not paid back")
                }, 5000)
            })
        })
    })
    it("should pay back accounts[1] after two more", function() {
        Doubler.deployed().then(function(instance) {
            var startBalance = getBalance(accounts[1])
            instance.sendTransaction({
                from: accounts[4],
                value: web3.toWei(100, "finney")
            }).then(function() {
                var endBalance = getBalance(accounts[1])
                assert(endBalance <= startBalance,
                    "accounts[1] was not paid back")
            })
        })
    })
})
