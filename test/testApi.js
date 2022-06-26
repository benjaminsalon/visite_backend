const { expect } = require("chai");
const { providers } = require("ethers");
const { ethers } = require("hardhat");

let user1, user2;
let bobarinkebycreditaddress = "0x208c3CE906cd85362bd29467819d3AcbE5FC1614";
let url = "https://ekjo44bgc1.execute-api.us-east-2.amazonaws.com/travelBooked";

describe.only("Tests", function () {

  beforeEach(async () => {
    [user1, user2] = await hre.ethers.getSigners();
    Factory__Helper = await ethers.getContractFactory("TuringHelper");
    myTuringHelper = await Factory__Helper.deploy()
    await myTuringHelper.deployed();

    TuringCredit = await ethers.getContractFactory("BobaTuringCredit");
    turingCredit = await TuringCredit.attach(bobarinkebycreditaddress)
    await turingCredit.deployed();

    const ConnectAPI = await ethers.getContractFactory("ConnecteAPI");
    connectAPI = await ConnectAPI.deploy(myTuringHelper.address,url);
    await connectAPI.deployed();
    console.log(`connectAPI is deployed on ${connectAPI.address}`)
    const ONE_BOBA = ethers.utils.parseEther('1')
    await turingCredit.addBalanceTo(ONE_BOBA, myTuringHelper.address)

    await myTuringHelper.addPermittedCaller(connectAPI.address)

  });

  it("Travel Escrow payment", async function () {
    
});
});
