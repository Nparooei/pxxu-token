const Web3 = require("web3");
const { abi, bytecode } = require("../artifacts/contracts/PXXUToken.sol/PXXUToken.json");
require("dotenv").config();

const BSC_TESTNET_URL = process.env.BSC_TEST_RPC;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

async function main() {
  const web3 = new Web3(BSC_TESTNET_URL); // Connect to BSC Testnet
  const account = web3.eth.accounts.privateKeyToAccount(PRIVATE_KEY);
  web3.eth.accounts.wallet.add(account);
  web3.eth.defaultAccount = account.address;

  console.log("Deploying contracts with the account:", account.address);

  // Contract deployment
  const PXXUToken = new web3.eth.Contract(abi);
  const initialSupply = web3.utils.toWei("1000000", "ether"); // 1 million tokens with 18 decimals

  const deployedContract = await PXXUToken.deploy({
    data: bytecode,
    arguments: [initialSupply],
  })
    .send({
      from: account.address,
      gas: 5000000, // Gas limit
      gasPrice: web3.utils.toWei("10", "gwei"),
    })
    .on("receipt", (receipt) => {
      console.log("Contract deployed at address:", receipt.contractAddress);
    })
    .on("error", (error) => {
      console.error("Error deploying contract:", error);
    });
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});