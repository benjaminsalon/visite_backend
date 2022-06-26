const { expect } = require("chai");
const { providers } = require("ethers");
const { ethers } = require("hardhat");

let travelEscrowFactory, travelEscrow, hotelRegistry, nftIssuer,hotel;
let user1, user2;
let hotelPrice = ethers.utils.parseEther("0.0002");
let hotelName = "hotel1";
let paymentTime = 120;
let dateStart = 10000;
let numberOfNights = 1;

describe("Tests", function () {

  beforeEach(async () => {
    [user1, user2] = await hre.ethers.getSigners();

    const HotelRegistry = await ethers.getContractFactory("HotelRegistry");
    hotelRegistry = await HotelRegistry.deploy();
    console.log(`HotelRegistry is deployed on ${hotelRegistry.address}`)
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
    tx = await travelEscrowFactory.createTravel([user1.address, user2.address],hotelName,paymentTime, dateStart, numberOfNights,hotelPrice);
    rc = await tx.wait()

    ev = rc.events.find(
      (evInfo) => evInfo.event == "TravelEscrowCreated"
    )
    
    travelEscrowAddress = ev.args.travelEscrow;

    const TravelEscrow = await ethers.getContractFactory("TravelEscrow");
    travelEscrow = await TravelEscrow.attach(travelEscrowAddress);
    console.log(`travelEscrow is deployed on ${travelEscrow.address}`);


  });

  it("Travel Escrow payment", async function () {
    pricePerTraveller = await travelEscrow.getPricePerTraveller();
    price = await travelEscrow.getPrice();
    console.log(`price: ${price}`);
    console.log(`pricePerTraveller: ${pricePerTraveller}`);

    numberOfPaidTravellers = await travelEscrow.numberOfPaidTravellers();
    console.log(`numberOfPaidTravellers: ${numberOfPaidTravellers}`);
    hasUser1Paid = await travelEscrow.hasTravellerPaid(user1.address);
    console.log(`hasUser1Paid: ${hasUser1Paid}`);
    hasUser2Paid = await travelEscrow.hasTravellerPaid(user2.address);
    console.log(`hasUser2Paid: ${hasUser2Paid}`);
    hasEveryonePaid = await travelEscrow.hasEveryonePaid();
    console.log(`hasEveryonePaid: ${hasEveryonePaid}`);

    tx = await travelEscrow.connect(user1).payShare({value: pricePerTraveller});
    tx.wait();

    numberOfPaidTravellers = await travelEscrow.numberOfPaidTravellers();
    console.log(`numberOfPaidTravellers: ${numberOfPaidTravellers}`);
    hasUser1Paid = await travelEscrow.hasTravellerPaid(user1.address);
    console.log(`hasUser1Paid: ${hasUser1Paid}`);
    hasUser2Paid = await travelEscrow.hasTravellerPaid(user2.address);
    console.log(`hasUser2Paid: ${hasUser2Paid}`);
    hasEveryonePaid = await travelEscrow.hasEveryonePaid();
    console.log(`hasEveryonePaid: ${hasEveryonePaid}`);

    await expect(travelEscrow.connect(user1).withdrawShare()).to.revertedWith("Too early to withdraw");

    balanceOfTravelEscrow = await ethers.provider.getBalance(travelEscrow.address);
    console.log(`BEFORE HotelPayment balanceOfTravelEscrow: ${balanceOfTravelEscrow}`);
    balanceOfHotelContract = await ethers.provider.getBalance(hotel.address);
    console.log(`BEFORE HotelPayment balanceOfHotelContract: ${balanceOfHotelContract}`);

    tx = await travelEscrow.connect(user2).payShare({value: pricePerTraveller});
    rc = await tx.wait();

    // Check if the computed tokenId by ethers is the same than on chain
    tokenId1 = ethers.BigNumber.from(ethers.utils.solidityKeccak256([ "string", "address", "uint", "uint", "address" ], [ hotelName, hotel.address, dateStart, numberOfNights, user1.address]));
    console.log(tokenId1);
    tokenId2 = ethers.BigNumber.from(ethers.utils.solidityKeccak256([ "string", "address", "uint", "uint", "address" ], [ hotelName, hotel.address, dateStart, numberOfNights, user2.address]));
    console.log(tokenId2);

    numberOfPaidTravellers = await travelEscrow.numberOfPaidTravellers();
    console.log(`numberOfPaidTravellers: ${numberOfPaidTravellers}`);
    hasUser1Paid = await travelEscrow.hasTravellerPaid(user1.address);
    console.log(`hasUser1Paid: ${hasUser1Paid}`);
    hasUser2Paid = await travelEscrow.hasTravellerPaid(user2.address);
    console.log(`hasUser2Paid: ${hasUser2Paid}`);
    hasEveryonePaid = await travelEscrow.hasEveryonePaid();
    console.log(`hasEveryonePaid: ${hasEveryonePaid}`);
    numberOfPaidTravellers = await travelEscrow.numberOfPaidTravellers();
    console.log(`numberOfPaidTravellers: ${numberOfPaidTravellers}`);
    numberOfTravellers = await travelEscrow.numberOfTravellers();
    console.log(`numberOfTravellers: ${numberOfTravellers}`);

    balanceOfTravelEscrow = await ethers.provider.getBalance(travelEscrow.address);
    console.log(`AFTER HotelPayment balanceOfTravelEscrow: ${balanceOfTravelEscrow}`);

    balanceOfHotelContract = await ethers.provider.getBalance(hotel.address);
    console.log(`AFTER HotelPayment balanceOfHotelContract: ${balanceOfHotelContract}`);
    // console.log(rc);
    // ev = rc.events.find(
    //   (evInfo) => evInfo.event == "NFTMinted"
    // )
    
    // console.log(ev);
    // Doesnt work for NFTMinted because not the first tx

    [ hotelNameRetrieved, hotelAddressRetrieved, dateStartRetrieved, numberOfNightsRetrieved, travellerAddressRetrieved] = await nftIssuer.getMetadata(tokenId1);
    console.log(`hotelNameRetrieved: ${hotelNameRetrieved}`);
    console.log(`hotelAddressRetrieved: ${hotelAddressRetrieved}`);
    console.log(`dateStartRetrieved: ${dateStartRetrieved}`);
    console.log(`numberOfNightsRetrieved: ${numberOfNightsRetrieved}`);
    console.log(`travellerAddressRetrieved: ${travellerAddressRetrieved}`);
    });
});
