// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
let addresses = require("./addresses.json");
let travelEscrowFactory, travelEscrow, hotelRegistry, nftIssuer,hotel;
let user1, user2;
let hotelPrice = ethers.utils.parseEther("0.0002");
let hotelName = "Marriot";
let paymentTime = 120;
let dateStart = 10000;
let numberOfNights = 1;

let apiContractAddress = "0xa93217DB43b5defFAfb00259be41D8d097CADC55";

async function main() {
  [user1, user2] = await hre.ethers.getSigners();
  const ConnectAPI = await ethers.getContractFactory("ConnecteAPI");
    connectAPI = await ConnectAPI.attach(apiContractAddress);
    console.log(`connectAPI is deployed on ${connectAPI.address}`);

    let tx = await connectAPI.finalPOSTForBooking("a", "a",1, 1,  1, 1);
    let rc = await tx.wait();
    console.log(tx);
    console.log(rc);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
