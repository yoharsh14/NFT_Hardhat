// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BasicNFT is ERC721 {
    uint256 private s_tokenCounter;

    constructor() ERC721("OGDogie", "OG") {
        s_tokenCounter = 0;
    }

    function mintNft() public returns (uint256) {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
        return s_tokenCounter;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
