require("dotenv").config();

require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("solidity-coverage");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.9",
  networks: {

    mumbai: {
      url: process.env.MUMBAI_URL || "",
      accounts:
        [process.env.PRIVATE_KEY_JOSEPH_1, process.env.PRIVATE_KEY_JOSEPH_2]
    },

    boba_rinkeby: {
      url: 'https://rinkeby.boba.network',
      accounts: [process.env.PRIVATE_KEY_1, process.env.PRIVATE_KEY_2],
      network_id: 28,
      host: 'https://rinkeby.boba.network',
      gas: 2100000,
      gasPrice: 1000000000
    }
  }
};
