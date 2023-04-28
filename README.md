# XENDoge Smart Contract

XENDoge is an ERC20 token smart contract that extends the `ERC20Capped` and `IBurnRedeemable` contracts. This contract allows users to burn `XEN` tokens and redeem `XENDoge` tokens in return. The smart contract also implements a bonus system that rewards early adopters.

## Features

- XENDoge token contract is built on the Ethereum blockchain.
- The contract has a fixed cap of 50 billion XENDoge tokens.
- Users can burn their `XEN` tokens to redeem `XENDoge` tokens.
- The smart contract has a donation address where a portion of the ether sent during the burning process is sent.
- The contract implements a bonus system that rewards early adopters.
- The smart contract is open-source and licensed under the MIT License.

## Requirements

- [Solidity 0.8.19](https://solidity.readthedocs.io/en/v0.8.19/)
- [@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol](https://docs.openzeppelin.com/contracts/4.x/api/token/ERC20/extensions/ERC20Capped)
- [@openzeppelin/contracts/interfaces/IERC165.sol](https://docs.openzeppelin.com/contracts/4.x/api/introspection/IERC165)
- [@faircrypto/xen-crypto/contracts/interfaces/IBurnableToken.sol](https://github.com/fair-crypto/xen-crypto/blob/main/contracts/interfaces/IBurnableToken.sol)
- [@faircrypto/xen-crypto/contracts/interfaces/IBurnRedeemable.sol](https://github.com/fair-crypto/xen-crypto/blob/main/contracts/interfaces/IBurnRedeemable.sol)

## Installation

To use this smart contract, you need to have [Node.js](https://nodejs.org/) and [npm](https://www.npmjs.com/) installed.

1. Clone this repository:

```bash
git clone https://github.com/your-username/xendoge-smart-contract.git
```

2. Install the required packages:

```bash
npm install
```

3. Compile the smart contract:

```bash
npx hardhat compile
```

4. Deploy the smart contract:

```bash
npx hardhat run scripts/deploy.js --network <network-name>
```

## Usage

### Constructor

The constructor of the `XENDoge` contract sets the token name, symbol, and cap. It also initializes the `XEN_ADDRESS` and `DONATION_ADDRESS` variables and sets the `XEN_BURN_RATIO` to 1000.

```solidity
constructor() ERC20("XENDoge", "XDOGE") ERC20Capped(50000000000000000000000000000) {}
```

### supportsInterface

This function checks if the contract implements the `IBurnRedeemable` interface or the `IERC165` interface.

```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
    return interfaceId == type(IBurnRedeemable).interfaceId || interfaceId == this.supportsInterface.selector;
}
```

### burnXEN

This function is called by users to burn `XEN` tokens and receive `XENDoge` tokens in return. The function also sends a portion of the ether sent during the burning process to the donation address.

```solidity
function burnXEN(uint256 xen) public payable {
    DONATION_ADDRESS.transfer(msg.value);
    IBurnableToken(XEN_ADDRESS).burn(_msgSender(), xen);
}
```

### onTokenBurned

This function is called by the `XEN` token contract after a user has burned their `XEN` tokens. The function calculates the `XENDoge` tokens to be minted to the user based on the amount of `XEN` tokens burned and the current supply of `XENDoge` tokens. The function also updates the total amount of `XEN` tokens burned and emits a `Redeemed` event.

```solidity
function onTokenBurned(address user, uint256 amount) external {
    require(_msgSender() == XEN_ADDRESS, "XENDoge: Caller must be XEN Crypto.");
    require(user != address(0), "XENDoge: Address cannot be the 0 address.");
    require(amount >= 100000, "XENDoge: Burn amount too small.");

    totalXenBurned += amount;

    uint256 xenDoge = calculateMintReward(this.totalSupply(), amount);
    _mint(user, xenDoge);

    emit Redeemed(user, XEN_ADDRESS, address(this), amount, xenDoge);
}
```

### calculateMintReward

This function calculates the number of `XENDoge` tokens to be minted to the user based on the amount of `XEN` tokens burned and the current supply of `XENDoge` tokens. The function also takes into account the early adopter bonus system.

```solidity
function calculateMintReward(uint256 currentSupply, uint256 amountBurned) internal pure returns (uint256) {
    uint256 baseReward = amountBurned / XEN_BURN_RATIO;
    uint32 percentBonus = getPercentBonus(currentSupply);
    uint256 earlyAdopterBonus = percentageOf(baseReward, percentBonus);

    return baseReward + earlyAdopterBonus;
}
```

### getPercentBonus

This function returns the early adopter bonus percentage based on the current supply of `XENDoge` tokens.

```solidity
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
```

### percentageOf

This function calculates the percentage of a number.

```solidity
function percentageOf(uint256 number, uint32 percent) internal pure returns (uint256) {
    return number * percent / 10000;
}
```

## License

This smart contract is released under the [MIT License](https://opensource.org/licenses/MIT).