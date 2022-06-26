// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

let user1, user2;
let BOBA_FAUCET_CONTRACT_ADDRESS = "0x208c3CE906cd85362bd29467819d3AcbE5FC1614"
let uuid = "0x03031ba8779a7cc1afd8e986e7b0c18bd22c58391f8c2f1da38a3f495bcede37"
let answer = "ba49a399"

async function main() {
  [user1, user2] = await hre.ethers.getSigners();
  
  const BobaFaucet = await ethers.getContractFactory("BobaFaucet");
  const bobaFaucet =  await BobaFaucet.attach(BOBA_FAUCET_CONTRACT_ADDRESS);
  const tx = await bobaFaucet.connect(user1).getBobaFaucet(uuid, answer)
  await tx.wait()
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
