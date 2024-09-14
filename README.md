# Bank and BankVault Smart Contracts

This project contains two main smart contracts: Bank and BankVault, which together provide a system for users to deposit and withdraw ERC20 tokens.

## Contracts

### Bank

The Bank contract is the main interface for users. It allows:

- Depositing ERC20 tokens
- Withdrawing ERC20 tokens

Key features:

- Only the original depositor can withdraw their tokens
- Uses OpenZeppelin's ReentrancyGuard for security

### BankVault

The BankVault contract is responsible for actually holding the tokens. It:

- Receives tokens from users when they deposit
- Sends tokens to users when they withdraw

Key features:

- Only the Bank contract (its owner) can initiate transfers

## Usage

1. Deploy the Bank contract
2. Use the `deposit` function to deposit ERC20 tokens
3. Use the `withdraw` function to withdraw your deposited tokens
