const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');
import { ethers } from "hardhat";

// 0X5B38DA6A701C568545DCFCB03FCB875F56BEDDC4

async function main() {
    console.log("Obtaining the addresses for hardhat");
    let whiteListedAddresses = await ethers.getSigners();

    // Using keccak256 hashing algorithm to hash the leavves of the trees
    const leaf_nodes = whiteListedAddresses.map(signer => keccak256(signer.address)); //this line of code would handle all the hashing

    // now creating the merkle tree object
    const merkleTree = new MerkleTree(leaf_nodes, keccak256, { sortPairs: true});

    // obtaining the root hash
    const rootHash = merkleTree.getHexRoot();

    const claimingAddress = leaf_nodes[0];
    
    const hexProof = merkleTree.getHexProof(claimingAddress);
   // console.log(hexProof);


    // Making the call to the smart contract
    const NFTDrop = await ethers.getContractFactory("MerkleTreeExample");
    const nFTDrop = await NFTDrop.deploy();
    await nFTDrop.deployed();

    await nFTDrop.safeMint("https://url.com", hexProof);

    const tokenID = await nFTDrop.tokenURI(0);

    console.log(tokenID);
    




}


// const claimingAddress = leafNodes[6];
// const hexProof = merkleTree.getHexProof(claimingAddress);
// console.log(hexProof);
// console.log(merkleTree.verify(hexProof, claimingAddress, rootHash));

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });