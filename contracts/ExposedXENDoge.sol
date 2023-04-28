// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "../contracts/XENDoge.sol";

contract ExposedXENDoge is XENDoge {
    function _calculateMintReward(uint256 currentSupply, uint256 amountBurned) public pure  returns (uint256) {
        return calculateMintReward(currentSupply, amountBurned);
    }
}