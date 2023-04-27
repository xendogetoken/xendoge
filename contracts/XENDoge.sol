// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/interfaces/IERC165.sol";
import "@faircrypto/xen-crypto/contracts/interfaces/IBurnableToken.sol";
import "@faircrypto/xen-crypto/contracts/interfaces/IBurnRedeemable.sol";

contract XENDoge is ERC20Capped, IERC165, IBurnRedeemable { 
    address public constant XEN_ADDRESS = 0xD342D63466B520d8D331CaFF863900d402Aa5b00;
    address payable public constant DONATION_ADDRESS = payable(0xc475b02C2e2D6D2Dd20c1D8c6fB9Cf9a4D23165e);
    uint256 public constant XEN_BURN_RATIO = 1000;
    uint256 public totalXenBurned = 0;

    constructor() ERC20("XENDoge", "XDOGE") ERC20Capped(50000000000000000000000000000) {}

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IBurnRedeemable).interfaceId || interfaceId == this.supportsInterface.selector;
    }

    function burnXEN(uint256 xen) public payable {
        DONATION_ADDRESS.transfer(msg.value);
        IBurnableToken(XEN_ADDRESS).burn(_msgSender(), xen);
    }

    function onTokenBurned(address user, uint256 amount) external {
        require(_msgSender() == XEN_ADDRESS, "XENDoge: Caller must be XEN Crypto.");
        require(user != address(0), "XENDoge: Address cannot be the 0 address.");
        require(amount >= 100000, "XENDoge: Burn amount too small.");

        totalXenBurned += amount;

        uint256 xenDoge = calculateMintReward(amount);
        _mint(user, xenDoge);

        emit Redeemed(user, XEN_ADDRESS, address(this), amount, xenDoge);
    }

    function calculateMintReward(uint256 amountBurned) private view returns (uint256) {
        uint256 baseReward = amountBurned / XEN_BURN_RATIO;
        uint32 percentBonus = getPercentBonus();
        uint256 earlyAdopterBonus = percentageOf(baseReward, percentBonus);

        return baseReward + earlyAdopterBonus;
    }

    function getPercentBonus() private view returns (uint32) {
        if (this.totalSupply() >= 0 && this.totalSupply() <= 7500000000000000000000000000) return 150000; 

        if (this.totalSupply() > 7500000000000000000000000000 && this.totalSupply() <= 12500000000000000000000000000) return 100000;

        if (this.totalSupply() > 12500000000000000000000000000 && this.totalSupply() <= 17500000000000000000000000000) return 66600; 

        if (this.totalSupply() > 17500000000000000000000000000 && this.totalSupply() <= 22500000000000000000000000000) return 44400; 

        if (this.totalSupply() > 22500000000000000000000000000 && this.totalSupply() <= 27500000000000000000000000000) return 29600; 

        if (this.totalSupply() > 27500000000000000000000000000 && this.totalSupply() <= 32500000000000000000000000000) return 19700; 

        if (this.totalSupply() > 32500000000000000000000000000 && this.totalSupply() <= 35000000000000000000000000000) return 13100; 

        if (this.totalSupply() > 35000000000000000000000000000 && this.totalSupply() <= 37500000000000000000000000000) return 8700; 

        if (this.totalSupply() > 37500000000000000000000000000 && this.totalSupply() <= 40000000000000000000000000000) return 5800; 

        if (this.totalSupply() > 40000000000000000000000000000 && this.totalSupply() <= 42500000000000000000000000000) return 3800; 

        if (this.totalSupply() > 42500000000000000000000000000 && this.totalSupply() <= 45000000000000000000000000000) return 2500; 

        if (this.totalSupply() > 45000000000000000000000000000 && this.totalSupply() <= 47500000000000000000000000000) return 1700; 

        return 0;
    }

    function percentageOf(uint256 number, uint32 percent) private pure returns (uint256) {
        return number * percent / 10000;
    }
}