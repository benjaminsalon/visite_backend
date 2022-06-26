const { expect } = require("chai");
const { providers } = require("ethers");
const { ethers } = require("hardhat");

let user1, user2;

describe.only("Tests", function () {

  beforeEach(async () => {
    [user1, user2] = await hre.ethers.getSigners();
    Factory__Helper = await ethers.getContractFactory("TuringHelper");
    myTuringHelper = await Factory__Helper.deploy()

    const ConnectAPI = await ethers.getContractFactory("ConnecteAPI");
    connectAPI = await ConnectAPI.deploy(myTuringHelper.address);
    await connectAPI.deployed();
    console.log(`connectAPI is deployed on ${connectAPI.address}`)
    const ONE_BOBA = utils.parseEther('1')
    await turingCredit.addBalanceTo(ONE_BOBA, myTuringHelper.address)

    await myTuringHelper.addPermittedCaller(connectAPI.address)

  });

  it("Travel Escrow payment", async function () {
    
});
});
