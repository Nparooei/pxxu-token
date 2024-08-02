// deployWithWeb3.js

require("dotenv").config();
const {Web3} = require('web3'); // Ensure correct import
const fs = require("fs");
const path = require("path");

// Load environment variables
const BSC_TESTNET_URL = process.env.BSC_TEST_RPC;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

// Initialize Web3 connection to BSC Testnet
const provider = new Web3.providers.HttpProvider(BSC_TESTNET_URL);
const web3 = new Web3(provider);

// Add account using private key
const account = web3.eth.accounts.privateKeyToAccount(PRIVATE_KEY);
web3.eth.accounts.wallet.add(account);
web3.eth.defaultAccount = account.address;

// Load contract ABI and bytecode
const contractPath = path.resolve(__dirname, "../artifacts/contracts/contract.sol/PixiuWalletContract.json");
const { abi, bytecode } = JSON.parse(fs.readFileSync(contractPath, "utf8"));

// Main deployment function
async function main() {
  console.log("Deploying contracts with the account:", account.address);
  console.log("Account balance:", web3.utils.fromWei(await web3.eth.getBalance(account.address), "ether"), "BNB");

  // Create contract instance
  const PXXUToken = new web3.eth.Contract(abi);

  // Specify initial supply and initial pauser
  const initialSupply = web3.utils.toWei("1000000", "ether"); // 1 million tokens

  try {
    // Prepare deployment transaction
    const deployOptions = {
      data: bytecode,
      arguments: [account.address], // Initial pauser is the deployer
    };

    const createTransaction = PXXUToken.deploy(deployOptions);
    const gasEstimate = await createTransaction.estimateGas({ from: account.address });

    console.log("Estimated gas:", gasEstimate);

    // Send transaction
    const deployedContract = await createTransaction.send({
      from: account.address,
      gas: gasEstimate,
      gasPrice: web3.utils.toWei("10", "gwei"),
    });

    console.log("Contract deployed at address:", deployedContract.options.address);
  } catch (error) {
    console.error("Error deploying contract:", error);
  }
}

// Execute the main function
main().catch((error) => {
  console.error("Failed to deploy contract:", error);
  process.exit(1);
});
