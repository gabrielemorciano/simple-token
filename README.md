# SimpleToken (STK)

A custom ERC20 token implementation with minting and burning capabilities, built with Foundry.

![Tests](https://img.shields.io/badge/tests-24%20passing-brightgreen)
![Coverage](https://img.shields.io/badge/coverage-100%25-brightgreen)
![Solidity](https://img.shields.io/badge/solidity-0.8.20-blue)

##  Overview

SimpleToken is a fully-featured ERC20 token that demonstrates understanding of:
- Token standards (ERC20)
- Access control (owner-only functions)
- Safe arithmetic (Solidity 0.8+ built-in protection)
- Comprehensive testing with Foundry
- Deployment to public testnets

##  Features

-  **Standard ERC20 Functions**
  - `transfer()`: Send tokens to another address
  - `approve()`: Allow spender to transfer on your behalf
  - `transferFrom()`: Transfer tokens on behalf of another address

-  **Extended Functionality**
  - `mint()`: Create new tokens (owner only)
  - `burn()`: Destroy tokens from your balance

-  **Safety Features**
  - Zero address checks on all transfers
  - Overflow/underflow protection (Solidity 0.8+)
  - Proper allowance management
  - Comprehensive input validation

##  Technical Stack

- **Language:** Solidity 0.8.20
- **Framework:** Foundry
- **Testing:** Forge (22 test cases, 100% coverage)
- **Network:** Deployed on Sepolia testnet

##  Installation
```bash
# Clone repository
git clone https://github.com/gabrielemorciano/simple-token.git
cd simple-token

# Install dependencies
forge install

# Build contracts
forge build
```

##  Testing
```bash
# Run all tests
forge test

# Run with verbosity
forge test -vvv

# Run with gas reporting
forge test --gas-report

# Run specific test
forge test --match-test testTransfer

# Run coverage
forge coverage
```

### Test Suite

- **Constructor Tests**: Initial supply, owner balance, metadata
- **Transfer Tests**: Basic transfer, events, edge cases
- **Approve Tests**: Allowance setting, events, validations
- **TransferFrom Tests**: Delegation transfers, allowance checks
- **Mint Tests**: Token creation, access control
- **Burn Tests**: Token destruction, balance updates
- **Fuzz Tests**: Randomized inputs for transfer and mint


##  Deployment

### Sepolia Testnet

**Contract Address:** `0x1d12c46104241885E9fa5A362c2Ee23a212c1D5B`

**View on Etherscan:** [\[Link to Sepolia Etherscan\]](https://sepolia.etherscan.io/token/0x1d12c46104241885e9fa5a362c2ee23a212c1d5b)

### Deploy Your Own

1. Get Sepolia ETH from faucet: https://sepoliafaucet.com/

2. Create `.env` file:
```bash
PRIVATE_KEY=your_private_key
SEPOLIA_RPC_URL=your_alchemy_url
ETHERSCAN_API_KEY=your_etherscan_key
```

3. Deploy:
```bash
forge script script/DeploySimpleToken.s.sol:DeploySimpleToken \
    --rpc-url $SEPOLIA_RPC_URL \
    --broadcast \
    --verify
```
```

### Known Limitations (Educational Project)

-  Simple ownership (no multi-sig or DAO governance)
-  No pausing mechanism
-  No blacklist/whitelist functionality
-  Unlimited minting by owner

For production use, consider:
- OpenZeppelin's audited implementations
- Multi-signature wallets for ownership
- Timelock contracts for critical operations
- Third-party security audits

##  Gas Optimization

The contract is optimized for gas efficiency:
- Uses `uint256` (EVM's native word size)
- Minimal storage operations
- Efficient mappings

Average gas costs (Sepolia):
- Transfer: ~52,000 gas
- Approve: ~46,000 gas
- Mint: ~51,000 gas
- Burn: ~28,000 gas

##  Acknowledgments

- Built as part of blockchain security learning journey
- Inspired by ERC20 standard and OpenZeppelin implementations
- Testing framework powered by Foundry

##  Screenshots

![Contract on Etherscan](/docs/etherscan-screenshot.png)