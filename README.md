# Smart Contract Voting System

This is a smart contract project that implements a voting system where the duration of the voting period is customizable via the constructor. The system is built using Solidity and the OpenZeppelin contracts library.

## 📌 Features

- Customizable voting duration (in hours) set via constructor
- Secure voting mechanism using OpenZeppelin's standard contracts
- Only authorized users (contract owner) can start and end the vote
- Voting can only be done during the active voting period
- Transparent vote tracking

## 🚀 Getting Started

### 1. Install Requirements

Make sure you have installed:

- Git
- Foundry (for local Ethereum development)
- Node.js (optional, for interacting with contracts)

### 2. Clone the Repository

Clone the project repository to your local machine:

```bash
git clone https://github.com/yourusername/smart-contract-voting-system.git
cd smart-contract-voting-system
```

### 3. Install OpenZeppelin Contracts

Run the following command to install OpenZeppelin contracts:

```bash
forge install openzeppelin/openzeppelin-contracts@v4.8.3 --no-commit
```

### 4. Configure Environment Variables

Create a .env file based on .env.example and add your details (e.g., your private key and RPC URL).

```bash
SEPOLIA_RPC_URL=<your_rpc_url>
PRIVATE_KEY=<your_private_key>
ETHERSCAN_API_KEY=<your_etherscan_api_key>
```

## 🔧 Usage

### 1. Start a Local Node

To test your contract locally, you can start an Ethereum node using Anvil (provided by Foundry):

```bash
make anvil
```

### 2. Connect MetaMask to Anvil Local Network

Add the local Anvil network to MetaMask:

- Network Name: Anvil Local
- RPC URL: http://127.0.0.1:8545
- Chain ID: 31337
- Currency Symbol: ETH

Import an Anvil test account into MetaMask by using the private key provided by Anvil when it starts.

### 3. Deploy the Smart Contract

To deploy the voting contract locally, use the following command:

```bash
make deploy
```

For testnet deployment, you can use:

```bash
make deploy ARGS="--network sepolia"
```

### 4. Testing

Run unit tests for your contract using Foundry:

```bash
forge test
```

For coverage:

```bash
forge coverage
```

## 🧩 Contract Architecture

### VotingSystem

The main contract responsible for managing the voting process:

- **Voting Duration**: Specified during contract deployment.
- **Vote Tracking**: Keeps track of votes for each candidate.
- **Voting Period Management**: The contract owner can start and end the voting period.

Key features:

- Customizable voting duration (set during contract creation).
- Only the contract owner can start and end the voting.
- Transparent and immutable voting process.

## 🔗 Dependencies

This project uses the following libraries:

OpenZeppelin Contracts for secure contract development:

```bash
forge install openzeppelin/openzeppelin-contracts@v4.8.3 --no-commit
```

## 🌐 Example Deployed Contracts

Sepolia Testnet:

- Voting System Contract: 0x1234567890abcdef1234567890abcdef12345678

## 🛡️ Security Notes

- Use test funds only on testnets — never use real funds during development.
- Always verify contract addresses before any interactions.
- Ensure that private keys are stored securely, never expose them to public repositories.

## 📜 License

This project is created for educational purposes and is free to use for further development.

## 💙 Thank You!

If you find this project helpful, don't forget to ⭐ the repository on GitHub!

Made with 💖 by Virgi
