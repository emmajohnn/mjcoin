# mjcoin

mjcoin is a simple fungible token implemented as a Clarity smart contract and managed with [Clarinet](https://github.com/hirosystems/clarinet).

The Clarinet project for the contract lives in the `mjcoin-clarinet` subdirectory of this repository.

## Project structure

- `mjcoin-clarinet/`
  - `Clarinet.toml` – Clarinet project configuration
  - `contracts/mjcoin.clar` – mjcoin token smart contract
  - `settings/` – network configuration for Mainnet/Testnet/Devnet
  - `tests/` – placeholder for TypeScript tests

## Requirements

- [Clarinet](https://docs.hiro.so/clarinet) (already installed and available in your environment)
- Node.js (optional, only needed if you plan to run the generated TypeScript tests)

## The mjcoin contract

The `contracts/mjcoin.clar` contract implements a minimal fungible token with:

- `mint` – mint new tokens to a given principal (open to any caller; suitable for local testing)
- `transfer` – move tokens from one principal to another, authorized by the sender
- `get-balance` – read-only function returning the token balance for a principal
- `get-total-supply` – read-only function returning the total token supply
- `get-name` – read-only function returning the token name ("mjcoin")
- `get-symbol` – read-only function returning the token symbol ("MJC")
- `get-decimals` – read-only function returning the number of decimals (`u6`)

### Error codes

The contract uses the following error codes (returned as `(err uXXX)`):

- `u100` – unauthorized (for example, attempting to transfer from another principal)
- `u101` – insufficient balance
- `u102` – invalid amount (zero or negative-like amounts)

## Common workflows

All commands below are run from the Clarinet project directory:

```bash
cd mjcoin-clarinet
```

### Check contract syntax

Run Clarinet's static checks against all contracts in the project:

```bash
clarinet check
```

### Start a local Devnet (optional)

To interact with the contract from a browser or scripts:

```bash
clarinet integrate
```

Then follow the prompts and Clarinet documentation for broadcasting transactions.

### Running tests (optional)

Clarinet has scaffolded a TypeScript test file for the `mjcoin` contract in `mjcoin-clarinet/tests/mjcoin.test.ts`.

To install dependencies and run tests:

```bash
cd mjcoin-clarinet
npm install
npm test
```

## Development notes

- The `mint` function is intentionally open to any caller for local development and experimentation. For production, you should restrict minting to an admin, multisig, or DAO contract.
- You can extend `mjcoin.clar` with additional functionality such as burning, pausing transfers, or integrating with SIP-010 traits for wallet compatibility.
