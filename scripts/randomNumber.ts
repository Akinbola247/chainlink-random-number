import { ethers } from "hardhat";
import helpers from "@nomicfoundation/hardhat-network-helpers";
import Web3 from "web3"


async function main() {
    const [owner] = await ethers.getSigners();
    // const subscriptionID = 10084;
//   const RandomNumber = await ethers.getContractFactory("RANDOM");
//   const randomNumber = await RandomNumber.connect(owner).deploy(subscriptionID);
//   await randomNumber.deployed();
//   console.log(`Random number is deployed to ${randomNumber.address}`);


const Randao = await ethers.getContractAt("IrandomNumber", "0xb36d8D7293FC6677c6e2bd0B1be3aD8B32C48CF9");
await Randao.connect(owner).requestRandomWords();
console.log(Randao)

}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});



