# XENDoge Smart Contract

XENDoge is an ERC20 token smart contract that extends the `ERC20Capped` and `IBurnRedeemable` contracts. This contract allows users to burn `XEN` tokens and redeem `XENDoge` tokens in return. The smart contract also implements a bonus system that rewards early adopters.

## Features

- The contract has a fixed cap of 50 billion XENDoge tokens.
- Users can burn their `XEN` tokens to redeem `XENDoge` tokens.
- The smart contract has a donation address where ether sent during the burning process is sent.
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
git clone https://github.com/xendogetoken/xendoge.git
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

The constructor of the `XENDoge` contract sets the token name, symbol, and cap.

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

This function is called by users to burn `XEN` tokens and receive `XENDoge` tokens in return. The function also sends any ether received during the burning process to the donation address.

```solidity
function burnXEN(uint256 xen) public payable {
    (bool sent, bytes memory data) = DONATION_ADDRESS.call{value: msg.value}("");
    require(sent, "XENDoge: Failed to send Ether to the donation address.");
    totalDonated += msg.value;
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

## Tests

This smart contract includes a test suite that uses Remix's testing framework. The test code is in the `testSuite` contract and can be found in the `test/XENDoge_test.sol` file.

The test suite tests the `calculateMintReward` function by checking the expected mint reward value for various values of `currentSupply` and `amountBurned`. The expected values are hardcoded into the test cases and are compared against the actual values returned by the function using the `Assert.equal` method.

To run the test suite, follow these steps:
1. Open the contract file in Remix.
2. In the "Solidity Compiler" tab, compile the contract.
3. In the "Solidity Unit Testing" tab, select the "testSuite" contract.
4. Click on the "Run" button to run the test cases.

All test cases should pass without errors.

# XENDoge ChatGPT Smart Contract Audit

I asked ChatGPT version 4.0 to conduct an audit of XENDoge. Here are the results. My responses are in **bold**.

I've audited the provided Solidity smart contract, and here are my findings:

## Overall Structure
The smart contract appears to be a custom implementation of an ERC20Capped token. It imports required contracts from OpenZeppelin and FairCrypto and has implemented IERC165 and IBurnRedeemable interfaces.

## Constructor and Token Info
The constructor initializes the ERC20 token with a name "XENDoge" and a symbol "XDOGE". It also sets the cap for the total supply to 50,000,000,000 (50 billion) tokens.

## Interface Support
The `supportsInterface` function has been correctly implemented according to the ERC165 standard, allowing the contract to claim support for the IBurnRedeemable interface.

## Burning XEN Tokens
The `burnXEN` function allows users to burn XEN tokens, and it forwards the Ether sent with the transaction to the `DONATION_ADDRESS`. This function should be executed within the context of the user's address and with a non-zero Ether amount. The contract assumes that the user has already approved the XENDoge contract to spend the specified amount of XEN tokens on their behalf.

## Token Minting
The `onTokenBurned` function mints new XENDoge tokens for the user who burned the XEN tokens. The minting amount is determined by the `calculateMintReward` function, which calculates the reward based on the total burned XEN amount and the current total supply of XENDoge tokens. There's a bonus percentage applied depending on the current supply.

## Utility Functions
The contract contains utility functions to calculate percentage bonuses and percentages of a number. These functions are used to calculate the mint reward.

## Suggestions and Potential Improvements

### Visibility
Consider making the utility functions `getPercentBonus` and `percentageOf` private instead of internal, as they are not intended to be used outside of this contract or inherited contracts.

**These functions were set to internal in order to make them testable. There is no difference between private and internal once the smart contract is deployed to the blockchain in terms of gas cost.**

### SafeMath
Since the contract uses Solidity 0.8.19, it already benefits from built-in overflow and underflow protection. However, if you decide to use an earlier version of Solidity, consider using OpenZeppelin's SafeMath library to protect against arithmetic overflows and underflows.

### Documentation
Consider adding comments to describe the purpose of each function, as well as any specific implementation details or assumptions made within the code. This will help other developers better understand the contract and its intended behavior.

**There is a README in the XENDoge repository on GitHub.**

Overall, the contract appears to be well-structured, and I did not find any critical security vulnerabilities. However, I recommend addressing the suggestions mentioned above to improve the contract's overall quality and maintainability.

## License

This smart contract is released under the [MIT License](https://opensource.org/licenses/MIT).