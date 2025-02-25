import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  // Deploy our multi-sig wallet
  const Multisig = await ethers.getContractFactory("LockedMultySigWallet");
  const multisig = await Multisig.deploy();
  await multisig.waitForDeployment();
  console.log(`Multisig deployed at: ${await multisig.getAddress()}`);
}

// Run the script
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});