# 🏀 HOOPS - Web3 Sports Betting Platform

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![GitHub stars](https://img.shields.io/github/stars/KENDY-Neilla-Gisa/hoops?style=social)](https://github.com/KENDY-Neilla-Gisa/hoops/stargazers)

HOOPS is a decentralized sports betting platform built on blockchain technology, allowing users to bet on sports events using cryptocurrency. The platform combines the excitement of sports betting with the security and transparency of blockchain.

## 🌟 Features

- 🎲 **Decentralized Betting**: Place bets directly on the blockchain with no intermediaries
- 💰 **HPS Token**: Native ERC-20 token for all platform transactions
- 🔒 **Secure & Transparent**: All transactions are verifiable on the blockchain
- 🤝 **Social Features**: Compete with friends and track leaderboards
- 📱 **Responsive Design**: Seamless experience across all devices
- ⚡ **Instant Payouts**: Automated smart contracts ensure quick and fair payouts
- 🔄 **Real-time Updates**: Live odds and game statistics
- 🛡️ **Non-Custodial**: You control your funds at all times

## 🚀 Demo

[Live Demo](https://hoops-app.vercel.app) | [Video Walkthrough](#) (coming soon)

## 🛠 Tech Stack

- **Frontend**: Next.js, React, TypeScript, Tailwind CSS
- **Blockchain**: Solidity, Hardhat, Ethers.js
- **Web3**: Wagmi, RainbowKit
- **Database**: The Graph (for indexing)
- **Deployment**: Vercel, IPFS
- **Testing**: Jest, Hardhat

## 🚀 Getting Started

### Prerequisites

- Node.js (v16 or later)
- npm or yarn
- MetaMask or other Web3 wallet

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/KENDY-Neilla-Gisa/hoops.git
   cd hoops
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

4. Open [http://localhost:3000](http://localhost:3000) in your browser.

## 🔧 Smart Contracts

The project includes the following smart contracts:

- `Hoops.sol`: ERC-20 token contract for HPS tokens
- `InviteFriends.sol`: Contract handling user invitations and rewards

### Deploying Contracts

1. Install Hardhat:
   ```bash
   cd web3-contracts
   npm install
   ```

2. Configure your environment variables in `.env` (create if it doesn't exist):
   ```
   PRIVATE_KEY=your_private_key
   INFURA_API_KEY=your_infura_key
   ETHERSCAN_API_KEY=your_etherscan_key
   ```

3. Compile contracts:
   ```bash
   npx hardhat compile
   ```

4. Deploy to a testnet:
   ```bash
   npx hardhat run scripts/deploy.js --network sepolia
   ```

## 📱 Mobile Support

HOOPS is built with a mobile-first approach and works seamlessly on all devices. For the best mobile experience:

1. **Progressive Web App (PWA)**: Install directly to your home screen
2. **Responsive Design**: Optimized for all screen sizes
3. **Mobile Wallet Support**: Connect with popular Web3 wallets like MetaMask Mobile, Trust Wallet, and more

```bash
# For PWA installation, look for the install button in your mobile browser
# or use the 'Add to Home Screen' option
```

## 🗺️ Roadmap

### Phase 1: Core Features (Current)
- [x] Smart contract development
- [x] Basic betting interface
- [x] Wallet integration
- [x] Token integration

### Phase 2: Enhanced Features
- [ ] Advanced betting options
- [ ] Live betting
- [ ] Social features
- [ ] Mobile app development

### Phase 3: Expansion
- [ ] Multi-chain support
- [ ] Governance features
- [ ] Staking and yield farming

## 🤝 Contributing

We welcome contributions from the community! Whether you're a developer, designer, or just have ideas, we'd love to have you on board.

### How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please read our [Contributing Guidelines](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md) for details.

## 🛡️ Security

Security is our top priority. If you discover any security issues, please disclose them responsibly by contacting us at [security@hoops.app](mailto:security@hoops.app).

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📬 Contact

- **Email**: [contact@hoops.app](mailto:contact@hoops.app)
- **GitHub Issues**: [https://github.com/KENDY-Neilla-Gisa/hoops/issues](https://github.com/KENDY-Neilla-Gisa/hoops/issues)

## 🙏 Acknowledgments

- Built with ❤️ using Next.js and Web3 technologies
- Special thanks to all our contributors and the open-source community
- Inspired by the vision of decentralized finance and Web3

## 🌟 Show Your Support

If you find this project useful, please consider giving it a ⭐️ on GitHub to help us grow our community!
