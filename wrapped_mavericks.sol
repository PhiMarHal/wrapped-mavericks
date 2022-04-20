// SPDX-License-Identifier: MIT

// A wrapper for EVMavericks

pragma solidity ^0.8.10;

import "https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/master/contracts/token/ERC721/ERC721Upgradeable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/master/contracts/access/OwnableUpgradeable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract WrappedMavericks is ERC721Upgradeable, OwnableUpgradeable {

    address public immutable ORIGINAL_MAVERICK_CONTRACT;
    string public baseURI = "ipfs://QmNpw6kYTQNfU7LTsbj4zrFfCN8Ck4m1reUdNE63VBiNj2/";   
    uint256 public royaltyBasis;

    // Live adr for EVM contract: 0x7ddaa898d33d7ab252ea5f89f96717c47b2fee6e
    // _contractOwner should be the community multisig if available
    // _royaltyBasis is in basis points, with a max of 750 = 7.5%
    constructor(address _maverickContract, address _contractOwner, uint256 _royaltyBasis) {
        ORIGINAL_MAVERICK_CONTRACT = _maverickContract;
        _transferOwnership(_contractOwner);
        updateRoyalty(_royaltyBasis);
    }

    // wrap 1 EVM, give the corresponding wEVM
    function wrapLion(uint256 _id) public {
        IERC721Upgradeable(ORIGINAL_MAVERICK_CONTRACT).transferFrom(msg.sender, address(this), _id);
        _mint(msg.sender, _id);
    }

    // unwrap a wEVM, give the corresponding EVM
    function unwrapLion(uint256 _id) public {
        _burn(_id);
        IERC721Upgradeable(ORIGINAL_MAVERICK_CONTRACT).transferFrom(address(this), msg.sender, _id);
    }

    // returns baseURI
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    // returns royalty info for marketplaces
    // compiler warning is normal, in order to respect the EIP2981 standard
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount) {
        receiver = address(this);
        royaltyAmount = _salePrice * royaltyBasis / 10000;
    }

    // upgrade royalty info
    function updateRoyalty(uint256 _royaltyBasis) public onlyOwner() {
        require(_royaltyBasis < 750, "Wrapped Mavericks: royalty should be at or below 7.5%");

        royaltyBasis = _royaltyBasis;
    }

    // transfers contract balance to owner
    function transferBalance() onlyOwner() public{            
            payable(msg.sender).transfer(address(this).balance);
    }
    
    // transfers contract balance of given erc20 to owner
    function transferERC20Balance(address _erc20ContractAddress, uint256 _amount) onlyOwner() public{
        IERC20(_erc20ContractAddress).transfer(msg.sender, _amount);
    }

}