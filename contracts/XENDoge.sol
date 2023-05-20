// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/interfaces/IERC165.sol";
import "@faircrypto/xen-crypto/contracts/interfaces/IBurnableToken.sol";
import "@faircrypto/xen-crypto/contracts/interfaces/IBurnRedeemable.sol";

contract XENDoge is ERC20Capped, IERC165, IBurnRedeemable { 
    address public constant XEN_ADDRESS = 0x06450dEe7FD2Fb8E39061434BAbCFC05599a6Fb8;
    address payable public constant DONATION_ADDRESS = payable(0xDd1353ABC10433e0Df7217404B7908163Ad76930);
    uint256 public constant XEN_BURN_RATIO = 1000;
    uint256 public totalXenBurned = 0;
    uint256 public totalDonated = 0;

    constructor() ERC20("XENDoge", "XDOGE") ERC20Capped(50000000000000000000000000000) {}

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IBurnRedeemable).interfaceId || interfaceId == this.supportsInterface.selector;
    }

    function burnXEN(uint256 xen) public payable {
        (bool sent,) = DONATION_ADDRESS.call{value: msg.value}("");
        require(sent, "XENDoge: Failed to send Ether to the donation address.");
        totalDonated += msg.value;
        IBurnableToken(XEN_ADDRESS).burn(_msgSender(), xen);
    }

    function onTokenBurned(address user, uint256 amount) external {
        require(_msgSender() == XEN_ADDRESS, "XENDoge: Caller must be XEN Crypto.");
        require(user != address(0), "XENDoge: Address cannot be the 0 address.");
        require(amount >= 100000, "XENDoge: Burn amount too small.");

        totalXenBurned += amount;

        uint256 xenDoge = calculateMintReward(this.totalSupply(), amount);
        _mint(user, xenDoge);

        emit Redeemed(user, XEN_ADDRESS, address(this), amount, xenDoge);
    }

    function calculateMintReward(uint256 currentSupply, uint256 amountBurned) internal pure returns (uint256) {
        uint256 baseReward = amountBurned / XEN_BURN_RATIO;
        uint32 percentBonus = getPercentBonus(currentSupply);
        uint256 earlyAdopterBonus = percentageOf(baseReward, percentBonus);

        return baseReward + earlyAdopterBonus;
    }

    function getPercentBonus(uint256 currentSupply) internal pure returns (uint32) {
        if (currentSupply >= 0 && currentSupply <= 7500000000000000000000000000) return 150000; 

        if (currentSupply > 7500000000000000000000000000 && currentSupply <= 12500000000000000000000000000) return 100000;

        if (currentSupply > 12500000000000000000000000000 && currentSupply <= 17500000000000000000000000000) return 66600; 

        if (currentSupply > 17500000000000000000000000000 && currentSupply <= 22500000000000000000000000000) return 44400; 

        if (currentSupply > 22500000000000000000000000000 && currentSupply <= 27500000000000000000000000000) return 29600; 

        if (currentSupply > 27500000000000000000000000000 && currentSupply <= 32500000000000000000000000000) return 19700; 

        if (currentSupply > 32500000000000000000000000000 && currentSupply <= 35000000000000000000000000000) return 13100; 

        if (currentSupply > 35000000000000000000000000000 && currentSupply <= 37500000000000000000000000000) return 8700; 

        if (currentSupply > 37500000000000000000000000000 && currentSupply <= 40000000000000000000000000000) return 5800; 

        if (currentSupply > 40000000000000000000000000000 && currentSupply <= 42500000000000000000000000000) return 3800; 

        if (currentSupply > 42500000000000000000000000000 && currentSupply <= 45000000000000000000000000000) return 2500; 

        if (currentSupply > 45000000000000000000000000000 && currentSupply <= 47500000000000000000000000000) return 1700; 

        return 0;
    }

    function percentageOf(uint256 number, uint32 percent) internal pure returns (uint256) {
        return number * percent / 10000;
    }
}