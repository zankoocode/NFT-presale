
const hre = require("hardhat");

async function main() {

  const NFTsale = await hre.ethers.getContractFactory("NFTsale");
  const nftsale = await NFTsale.deploy("https://ipfs.io/ipfs/QmUg9nGjLYt5mv6uFbZvAG5KCcSfexLE41rjGM76oB86Lx", "0x100F78e6499C9ffB0564c80efe2359E07A5705E1");

  await nftsale.deployed();

  console.log(
    ` deployed to ${nftsale.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
