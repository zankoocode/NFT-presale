// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";


interface IWhitelist {
    function WhitelistedAddresses (address _address) external view returns (bool);
}

contract NFTsale is Context, Ownable, ERC721 {
    IWhitelist whitelist;

    string baseURI;

    uint256 public presalePrice = 0.01 ether;

    uint256 public publicPrice = 0.02 ether;

    uint256 public maxNFTTokenId = 40;

    uint256 public mintedTokenIds;

    bool public presaleStarted;

    uint256 public presaleEnded;

    constructor (string memory __baseURI, address _whitelist) ERC721 ("zankoocode", "zcd") {
        baseURI = __baseURI;
        whitelist = IWhitelist(_whitelist);
    }

    function startPresale () external onlyOwner {
        presaleStarted = true;
        presaleEnded = block.timestamp + 7 days;
    }

    function presaleMint () external payable returns (bool) {
        require (presaleStarted && presaleEnded > block.timestamp, "presale is not started or finished");
        require (whitelist.WhitelistedAddresses(_msgSender()), "you haven't been whitelisted");
        require(mintedTokenIds < maxNFTTokenId, "exceed maximum supply");
        require (msg.value >= presalePrice, "please send appropriate amount");
        mintedTokenIds += 1;
        _safeMint(_msgSender(), mintedTokenIds);
        return true;
    }

    function publicMint () external payable returns (bool) {
        require (presaleStarted && presaleEnded <= block.timestamp, "presale is not finished");
        require(mintedTokenIds < maxNFTTokenId, "exceed maximum supply");
        require (msg.value >= publicPrice, "please send appropriate amount");
        mintedTokenIds += 1;
        _safeMint(_msgSender(), mintedTokenIds);
        return true;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function withdraw () external onlyOwner {
        address _owner = owner();
        uint256 amountTobeWithdrawn = address(this).balance;
        (bool sent,) = _owner.call{value : amountTobeWithdrawn}("");
        require(sent, "withdrawal failed");
    }

    receive () external payable {}

    fallback () external payable {}
}
