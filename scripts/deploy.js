// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

let travelEscrowFactory, travelEscrow, hotelRegistry, nftIssuer,hotel;
let user1, user2;
let hotelPrice = ethers.utils.parseEther("0.0002");
let hotelName = "hotel1";
let paymentTime = 120;
let dateStart = 10000;
let numberOfNights = 1;

async function main() {
  [user1, user2] = await hre.ethers.getSigners();
  const HotelRegistry = await ethers.getContractFactory("HotelRegistry");
    hotelRegistry = await HotelRegistry.deploy();
    console.log(`HotelRegistry is deployed on ${hotelRegistry.address}`)
    await hotelRegistry.deployed();
    const NftIssuer = await ethers.getContractFactory("NFTIssuer");
    nftIssuer = await NftIssuer.deploy(hotelRegistry.address);
    await nftIssuer.deployed();
    console.log(`NFTIssuer is deployed on ${nftIssuer.address}`);

    //Hotel Creation
    const Hotel = await ethers.getContractFactory("Hotel");
    hotel = await Hotel.deploy("hotel1",hotelPrice,hotelRegistry.address);
    await hotel.deployed();

    //Add hotel to registry
    tx = await hotelRegistry.addHotelToRegistry(hotel.address);
    tx.wait()

    const TravelEscrowFactory = await ethers.getContractFactory("TravelEscrowFactory");
    const travelEscrowFactory = await TravelEscrowFactory.deploy(hotelRegistry.address, nftIssuer.address);
    await travelEscrowFactory.deployed();
    console.log(`travelEscrowFactory is deployed on ${travelEscrowFactory.address}`);
    
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
