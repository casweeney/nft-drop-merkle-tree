// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";



contract MerkleTreeExample is ERC721URIStorage {
    using Counters for Counters.Counter;

    bytes32 public merkleRoot = 0xd38a533706a576a634c618407eb607df606d62179156c0bed7ab6c2088b01de9;
    mapping(address => bool) public whitelistClaimed;
    
    Counters.Counter private _myCounter;
    uint256 MAX_SUPPLY = 21;

    constructor() ERC721("Developeruche", "DUC") {}



    function whitelistMint(bytes32[] calldata _merkleProof) internal view returns(bool status) {
        require(!whitelistClaimed[msg.sender], "Address already claimed");
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProof.verify(_merkleProof, merkleRoot, leaf),
            "Invalid Merkle Proof."
        );
        status = true;
    }

    function safeMint(string memory uri, bytes32[] calldata _merkleProof) public{

        bool stat = whitelistMint(_merkleProof);

        require(stat, "Invaild Proof");


        uint256 tokenId = _myCounter.current();
        require(tokenId <= MAX_SUPPLY, "Sorry, all NFTs have been minted!");
        _myCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);

        whitelistClaimed[msg.sender] = true;
    }
}
