// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import '@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol';

contract BettingPool is ERC721Holder {
    using SafeERC20 for IERC20;

    // Events for important state changes
    event NewUser(uint256 userID, address userAddress);        // New user registered
    event Deposit(uint256 userID, uint256 amount, uint256 poolId);  // Tokens deposited
    event Withdrawal(uint256 userID, uint256 amount, uint256 poolId); // Tokens withdrawn
    event MomentPurchased(address indexed buyer, uint256 indexed momentID, uint256 amount); // NFT purchased
    event AccruedFeesWithdrawn(uint256 amount, address to);    // Platform fees withdrawn
    event BetPlaced(address indexed user, uint256 amount, uint256 poolId); // New bet placed
    event BetWon(address indexed user, uint256 poolId, uint256 nftId); // Bet won
    event RewardClaimed(address indexed user, uint256 nftId);  // NFT reward claimed

// External contracts
    IERC20 public flowToken;        // The token used for betting (HOOPS)
    IERC721 public nftContract;     // The NFT contract for rewards
    
    // State variables
    uint256 public accruedFees;     // Total fees collected by the platform
    address public commissionsAddress; // Where to send commissions
    uint256 public commission = 5;  // 5% commission on deposits
    uint256 public bettingPeriod = 24 hours; // How long bets are open

// User information
    struct User {
        uint256 owedValue;  // How much the user can withdraw
        uint256 uuid;       // Unique user ID
    }

    // Bet information
    struct Bet {
        address user;   // Who placed the bet
        uint256 amount; // How much they bet
    }

// Storage mappings
    mapping(address => User) public users;           // User address -> User info
    mapping(uint256 => uint256) public poolAmount;   // Pool ID -> Total amount in pool
    mapping(uint256 => Bet[]) public bets;           // Pool ID -> List of bets
    mapping(uint256 => uint256) public nftPrices;    // NFT ID -> Price
    mapping(address => uint256) public userBalance;  // User -> Total balance
    mapping(address => uint256) public userInvested; // User -> Total invested

    // NFT statistics
    uint256 public totalNFTs;      // Total number of NFTs
    uint256 public totalNFTPrice;  // Combined value of all NFTs

    // Initialize the contract with token, NFT, and commission addresses
    constructor(address _flowToken, address _nftContract, address _commissionsAddress) {
        flowToken = IERC20(_flowToken);
        nftContract = IERC721(_nftContract);
        commissionsAddress = _commissionsAddress;
    }

    // Register a new user
    function createUser() external returns (uint256) {
        require(users[msg.sender].uuid == 0, "User already exists");

        // Generate a unique user ID
        uint256 userId = uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp)));
        users[msg.sender] = User({owedValue: 0, uuid: userId});
        
        emit NewUser(userId, msg.sender);
        return userId;
    }

    // Deposit tokens into a betting pool
    function deposit(uint256 amount, uint256 poolId) external {
        require(amount > 0, "Amount must be greater than zero");
        User storage user = users[msg.sender];
        require(user.uuid != 0, "User not registered");

        // Transfer tokens from user to contract
        flowToken.safeTransferFrom(msg.sender, address(this), amount);
        
        // Calculate amount after commission (5%)
        uint256 afterCommission = (amount * (100 - commission)) / 100;
        
        // Update balances
        user.owedValue += afterCommission;
        poolAmount[poolId] += afterCommission;
        userBalance[msg.sender] += afterCommission;
        userInvested[msg.sender] += afterCommission;
        
        // Add commission to fees
        accruedFees += (amount - afterCommission);

        emit Deposit(user.uuid, amount, poolId);
    }

    // Withdraw tokens from a betting pool
    function withdraw(uint256 amount, uint256 poolId) external {
        User storage user = users[msg.sender];
        require(user.owedValue >= amount, "Insufficient owed value");
        require(poolAmount[poolId] >= amount, "Insufficient pool balance");

        // Update balances before transfer (prevents reentrancy)
        user.owedValue -= amount;
        poolAmount[poolId] -= amount;
        userBalance[msg.sender] -= amount;
        userInvested[msg.sender] -= amount;

        // Transfer tokens to user
        flowToken.safeTransfer(msg.sender, amount);

        emit Withdrawal(user.uuid, amount, poolId);
    }

    // Purchase an NFT moment
    function purchaseMoment(uint256 momentID, uint256 amount) external {
        User storage user = users[msg.sender];
        require(user.owedValue >= amount, "Insufficient balance");

        // Update user balance and NFT stats
        user.owedValue -= amount;
        accruedFees += amount;  // Add to platform fees
        
        // Update NFT information
        nftPrices[momentID] = amount;
        totalNFTs++;
        totalNFTPrice += amount;

        emit MomentPurchased(msg.sender, momentID, amount);
    }

    // Withdraw collected fees (commission address only)
    function withdrawAccruedFees() external {
        require(msg.sender == commissionsAddress, "Not authorized");
        require(accruedFees > 0, "No accrued fees to withdraw");

        // Transfer fees and reset counter
        uint256 fees = accruedFees;
        accruedFees = 0;
        flowToken.safeTransfer(commissionsAddress, fees);
        
        emit AccruedFeesWithdrawn(fees, commissionsAddress);
    }

    // Place a bet in a specific pool
    function enterBet(uint256 poolId, uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        User storage user = users[msg.sender];
        require(user.uuid != 0, "User not registered");

        // Transfer betting amount
        flowToken.safeTransferFrom(msg.sender, address(this), amount);
        
        // Record the bet
        bets[poolId].push(Bet({user: msg.sender, amount: amount}));
        
        // Update user balances
        userBalance[msg.sender] += amount;
        userInvested[msg.sender] += amount;

        emit BetPlaced(msg.sender, amount, poolId);
    }

    // Finalize a betting round and determine the winner
    function finalizeBet(uint256 poolId, uint256 nftId) external {
        require(block.timestamp >= bettingPeriod, "Betting period not over");

        Bet[] storage poolBets = bets[poolId];
        require(poolBets.length > 0, "No bets placed");

        // Find the highest bet
        Bet memory highestBet = poolBets[0];
        for (uint256 i = 1; i < poolBets.length; i++) {
            if (poolBets[i].amount > highestBet.amount) {
                highestBet = poolBets[i];
            }
        }

        // Refund all losing bets
        for (uint256 i = 0; i < poolBets.length; i++) {
            if (poolBets[i].user != highestBet.user) {
                // Refund the bet amount
                flowToken.safeTransfer(poolBets[i].user, poolBets[i].amount);
                
                // Update user balances
                userBalance[poolBets[i].user] -= poolBets[i].amount;
                userInvested[poolBets[i].user] -= poolBets[i].amount;
            }
        }

        // Transfer NFT to the highest bidder
        nftContract.safeTransferFrom(address(this), highestBet.user, nftId);
        
        // Clear the bets for this pool
        delete bets[poolId];
        
        emit BetWon(highestBet.user, poolId, nftId);
    }

    // Claim an NFT reward
    function claimReward(uint256 nftId) external {
        require(nftContract.ownerOf(nftId) == address(this), "NFT not available for claim");
        
        // Transfer NFT to the caller
        nftContract.safeTransferFrom(address(this), msg.sender, nftId);
        
        emit RewardClaimed(msg.sender, nftId);
    }

    // Get user's owed value and UUID
    function getUserDetails(address userAddress) external view returns (uint256 owedValue, uint256 uuid) {
        User storage user = users[userAddress];
        return (user.owedValue, user.uuid);
    }

    // Get total amount in a specific pool
    function getPoolBalance(uint256 poolId) external view returns (uint256) {
        return poolAmount[poolId];
    }

    // Get total token balance of the contract
    function getContractBalance() external view returns (uint256) {
        return flowToken.balanceOf(address(this));
    }

    // Calculate average price of all NFTs
    function getAverageNFTPrice() external view returns (uint256) {
        return totalNFTs > 0 ? totalNFTPrice / totalNFTs : 0;
    }
}