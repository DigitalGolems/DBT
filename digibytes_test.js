const Digibytes = artifacts.require("Digibytes");
const PresaleDIG = artifacts.require("PresaleDIG")
const Game = artifacts.require("Game");

// const { assert } = require('chai')
// const chai = require('chai')

contract('Digibytes', async (accounts)=>{
  
   it("should return 400 mln", async () => {
       //when we deployed we minted to owner 500mln
       //but after deploy we sended 100mln to presale
       //so 400mln left
       const instance = await Digibytes.deployed();
       let num = await instance.balanceOf(accounts[0], {from: accounts[0]});
       assert.equal(num.toString(), "400000000000000000000000000", "True")// 500000000 * 10**18
   })

   it("Send to notPausedAccounts", async () => {
    //we've not blocked only Game and Presale addresses
    //so we are checking if we can transfer them
    let coinsToSend = "1";
    const digi = await Digibytes.deployed();
    let gameAddr = Game.address
    let presaleAddr = PresaleDIG.address
    await digi.transfer(accounts[9], 5, {from: accounts[0]})
    await digi.transfer(gameAddr, coinsToSend, {from: accounts[9]});
    await digi.transfer(presaleAddr, coinsToSend, {from: accounts[9]});
    let account9BalanceAfter = await digi.balanceOf(accounts[9])
    let GameBalanceAfter = await digi.balanceOf(gameAddr)
    let PresaleBalanceAfter = await digi.balanceOf(presaleAddr)
    assert.equal(account9BalanceAfter.toString(), "3", "True")
    assert.equal(GameBalanceAfter.toString(), coinsToSend, "True")
    assert.equal(PresaleBalanceAfter.toString(), coinsToSend, "True")
    })
})