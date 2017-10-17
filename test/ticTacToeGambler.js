var TTTGambler =
    artifacts.require("./TicTacToeGambler.sol")

const getBalance = (account) =>
    web3.eth.getBalance(account)

const error = () =>
    assert(false, "An error has occurred")

const betAmount = web3.toWei(1, "ether")

contract("TicTacToeGambler", function(accounts) {
    it("should work well and let X win correctly", function() {
        // X O
        // X O
        // X
        TTTGambler.deployed().then(function(instance) {
            instance.bet({
                from: accounts[0],
                value: betAmount
            }).then(function() {
                var XStartBalance = getBalance(accounts[0])
                instance.bet({
                    from: accounts[1],
                    value: betAmount
                }).then(function() {
                    instance.acceptBet({
                        from: accounts[0]
                    }).then(function() {
                        instance.acceptBet({
                            from: accounts[1]
                        }).then(function() {
                            instance.turn(0, {
                                from: accounts[0]
                            }).then(function() {
                                instance.turn(1, {
                                    from: accounts[1]
                                }).then(function() {
                                    instance.turn(3, {
                                        from: accounts[0]
                                    }).then(function() {
                                        instance.turn(4, {
                                            from: accounts[1]
                                        }).then(function() {
                                            instance.turn(6, {
                                                from: accounts[0]
                                            }).then(function() {
                                                // X should win
                                                assert(getBalance(accounts[0]) > XStartBalance, "X didn't win")
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        })
    })
})
