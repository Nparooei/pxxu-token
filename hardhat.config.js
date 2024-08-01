require("dotenv").config();
const Web3 = require("web3");

const BSC_TESTNET_URL = process.env.BSC_TEST_RPC;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

module.exports = {
  solidity: "0.8.20", // Solidity version
  networks: {
    hardhat: {}, // Local development network
    bscTestnet: {
      url: BSC_TESTNET_URL,
      accounts: [PRIVATE_KEY],
      chainId: 97,
    },
  },
};
