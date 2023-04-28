// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
import "remix_accounts.sol";
import "../contracts/ExposedXENDoge.sol";

contract testSuite {
    ExposedXENDoge public xenDoge;

    function beforeAll() public {
        xenDoge = new ExposedXENDoge();
    }

    function checkCalculateMintReward() public {
        Assert.equal(1600, xenDoge._calculateMintReward(0, 100000), "Incorrect mint reward calculation");
        Assert.equal(1600, xenDoge._calculateMintReward(5000000000000000000000000000, 100000), "Incorrect mint reward calculation");
        Assert.equal(1600, xenDoge._calculateMintReward(7500000000000000000000000000, 100000), "Incorrect mint reward calculation");

        Assert.equal(1100, xenDoge._calculateMintReward(7500000000000000000000000001, 100000), "Incorrect mint reward calculation");
        Assert.equal(1100, xenDoge._calculateMintReward(8000000000000000000000000000, 100000), "Incorrect mint reward calculation");
        Assert.equal(1100, xenDoge._calculateMintReward(12500000000000000000000000000, 100000), "Incorrect mint reward calculation");

        Assert.equal(1100, xenDoge._calculateMintReward(7500000000000000000000000001, 100000), "Incorrect mint reward calculation");
        Assert.equal(1100, xenDoge._calculateMintReward(8000000000000000000000000000, 100000), "Incorrect mint reward calculation");
        Assert.equal(1100, xenDoge._calculateMintReward(12500000000000000000000000000, 100000), "Incorrect mint reward calculation");

        Assert.equal(766, xenDoge._calculateMintReward(12500000000000000000000000001, 100000), "Incorrect mint reward calculation");
        Assert.equal(766, xenDoge._calculateMintReward(15500000000000000000000000000, 100000), "Incorrect mint reward calculation");
        Assert.equal(766, xenDoge._calculateMintReward(17500000000000000000000000000, 100000), "Incorrect mint reward calculation");

        Assert.equal(544, xenDoge._calculateMintReward(17500000000000000000000000001, 100000), "Incorrect mint reward calculation");
        Assert.equal(544, xenDoge._calculateMintReward(20500000000000000000000000000, 100000), "Incorrect mint reward calculation");
        Assert.equal(544, xenDoge._calculateMintReward(22500000000000000000000000000, 100000), "Incorrect mint reward calculation");

        Assert.equal(396, xenDoge._calculateMintReward(22500000000000000000000000001, 100000), "Incorrect mint reward calculation");
        Assert.equal(396, xenDoge._calculateMintReward(25500000000000000000000000000, 100000), "Incorrect mint reward calculation");
        Assert.equal(396, xenDoge._calculateMintReward(27500000000000000000000000000, 100000), "Incorrect mint reward calculation");

        Assert.equal(396, xenDoge._calculateMintReward(22500000000000000000000000001, 100000), "Incorrect mint reward calculation");
        Assert.equal(396, xenDoge._calculateMintReward(25500000000000000000000000000, 100000), "Incorrect mint reward calculation");
        Assert.equal(396, xenDoge._calculateMintReward(27500000000000000000000000000, 100000), "Incorrect mint reward calculation");

        Assert.equal(297, xenDoge._calculateMintReward(27500000000000000000000000001, 100000), "Incorrect mint reward calculation");
        Assert.equal(297, xenDoge._calculateMintReward(30500000000000000000000000000, 100000), "Incorrect mint reward calculation");
        Assert.equal(297, xenDoge._calculateMintReward(32500000000000000000000000000, 100000), "Incorrect mint reward calculation");

        Assert.equal(231, xenDoge._calculateMintReward(32500000000000000000000000001, 100000), "Incorrect mint reward calculation");
        Assert.equal(231, xenDoge._calculateMintReward(34500000000000000000000000000, 100000), "Incorrect mint reward calculation");
        Assert.equal(231, xenDoge._calculateMintReward(35000000000000000000000000000, 100000), "Incorrect mint reward calculation");

        Assert.equal(187, xenDoge._calculateMintReward(35000000000000000000000000001, 100000), "Incorrect mint reward calculation");
        Assert.equal(187, xenDoge._calculateMintReward(36000000000000000000000000000, 100000), "Incorrect mint reward calculation");
        Assert.equal(187, xenDoge._calculateMintReward(37500000000000000000000000000, 100000), "Incorrect mint reward calculation");

        Assert.equal(158, xenDoge._calculateMintReward(37500000000000000000000000001, 100000), "Incorrect mint reward calculation");
        Assert.equal(158, xenDoge._calculateMintReward(38500000000000000000000000000, 100000), "Incorrect mint reward calculation");
        Assert.equal(158, xenDoge._calculateMintReward(40000000000000000000000000000, 100000), "Incorrect mint reward calculation");

        Assert.equal(138, xenDoge._calculateMintReward(40000000000000000000000000001, 100000), "Incorrect mint reward calculation");
        Assert.equal(138, xenDoge._calculateMintReward(41000000000000000000000000000, 100000), "Incorrect mint reward calculation");
        Assert.equal(138, xenDoge._calculateMintReward(42500000000000000000000000000, 100000), "Incorrect mint reward calculation");

        Assert.equal(125, xenDoge._calculateMintReward(42500000000000000000000000001, 100000), "Incorrect mint reward calculation");
        Assert.equal(125, xenDoge._calculateMintReward(43500000000000000000000000000, 100000), "Incorrect mint reward calculation");
        Assert.equal(125, xenDoge._calculateMintReward(45000000000000000000000000000, 100000), "Incorrect mint reward calculation");

        Assert.equal(117, xenDoge._calculateMintReward(45000000000000000000000000001, 100000), "Incorrect mint reward calculation");
        Assert.equal(117, xenDoge._calculateMintReward(46000000000000000000000000000, 100000), "Incorrect mint reward calculation");
        Assert.equal(117, xenDoge._calculateMintReward(47500000000000000000000000000, 100000), "Incorrect mint reward calculation");

        Assert.equal(100, xenDoge._calculateMintReward(47500000000000000000000000001, 100000), "Incorrect mint reward calculation");
        Assert.equal(100, xenDoge._calculateMintReward(48500000000000000000000000000, 100000), "Incorrect mint reward calculation");
        Assert.equal(100, xenDoge._calculateMintReward(50000000000000000000000000000, 100000), "Incorrect mint reward calculation");
    }
}
    