import { ethers, network } from "hardhat";

async function main() {
  try {
    // Get the deployer's signer
    const [deployer] = await ethers.getSigners();
    
    if (!deployer) {
      throw new Error("No deployer account found. Make sure your private key is set in the .env file.");
    }
    
    console.log("Deploying contracts with the account:", await deployer.getAddress());
    
    // Get balance
    const balance = await ethers.provider.getBalance(deployer.address);
    console.log("Account balance:", ethers.formatEther(balance), "ETH");
    
    if (balance === 0n) {
      console.warn("WARNING: Your account balance is 0. You need some ETH to pay for gas fees.");
    }
    
    // Get the contract factories
    console.log("\n1. Preparing contract factories...");
    const Hoops = await ethers.getContractFactory("Hoops");
    const InviteFriends = await ethers.getContractFactory("InviteFriends");
    
    // Deploy HOOPS Token
    console.log("\n2. Deploying HOOPS Token...");
    const hoops = await Hoops.deploy();
    console.log("   Waiting for transaction to be mined...");
    await hoops.waitForDeployment();
    const hoopsAddress = await hoops.getAddress();
    console.log("   HOOPS Token deployed to:", hoopsAddress);
    
    // Deploy InviteFriends
    console.log("\n3. Deploying InviteFriends...");
    const inviteFriends = await InviteFriends.deploy(hoopsAddress);
    console.log("   Waiting for transaction to be mined...");
    await inviteFriends.waitForDeployment();
    const inviteFriendsAddress = await inviteFriends.getAddress();
    console.log("   InviteFriends deployed to:", inviteFriendsAddress);
    
    // Deployment complete
    console.log("\n✅ Deployment complete!");
    console.log("\n📝 Contract Addresses:");
    console.log("   HOOPS Token:", hoopsAddress);
    console.log("   InviteFriends:", inviteFriendsAddress);
    
    // Verification instructions
    if (network.name !== "hardhat") {
      console.log("\n🔍 To verify the contracts on Etherscan, run:");
      console.log(`   npx hardhat verify --network ${network.name} ${hoopsAddress}`);
      console.log(`   npx hardhat verify --network ${network.name} ${inviteFriendsAddress} "${hoopsAddress}"`);
    }
    
    return {
      hoops: hoopsAddress,
      inviteFriends: inviteFriendsAddress
    };
  } catch (error) {
    console.error("\n❌ Deployment failed:", error);
    throw error;
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });