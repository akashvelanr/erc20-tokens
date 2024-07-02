# StakingRewardsToken

StakingRewardsToken is a Solidity smart contract that implements an ERC20 token with staking capabilities. Users can stake their tokens to earn rewards based on a variable annual reward rate, with a staking duration that can also be adjusted. The contract uses OpenZeppelin libraries for secure and standardized implementation.

## Features

- ERC20 token with staking functionality
- Adjustable staking period
- Adjustable annual reward rate
- Secure and standardized using OpenZeppelin libraries

## Prerequisites

- [Remix](https://remix.ethereum.org/) (for deploying and testing the contract)
- MetaMask or other Ethereum wallet (for interacting with the deployed contract)

## Usage

### Deployment

1. Open [Remix](https://remix.ethereum.org/).

2. Create a new file called `StakingRewardsToken.sol` and copy the contract code into the file.

3. Compile the contract using the Solidity compiler.

4. Deploy the contract:
   - Select `Injected Web3` from the environment dropdown in the Remix sidebar (this connects Remix to your MetaMask wallet).
   - Ensure you are connected to the appropriate Ethereum network in MetaMask (e.g., Ropsten for testing).
   - Click the "Deploy" button.
