// contracts/HappyHipposNFTs.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC1155.sol";
import "./Ownable.sol";
import "./Pausable.sol";

contract HappyHipposNFTs is ERC1155, Pausable, Ownable {

mapping(uint256=>bool) private tokenCheck;

constructor() ERC1155("https://infinity8.io/upload/hippos_metadata/{id}.json") {}

// Single Address - Multiple Tokens _mintBatch
function mintSingleToMultipleBatch(address to, uint256[] memory ids, bytes memory data) public onlyOwner {
uint256 _length= ids.length;
uint256[] memory amounts = new uint256[](_length);
for (uint256 i = 0; i < ids.length; i++) {
require(!tokenCheck[ids[i]], "Token with this ID already exists");
}
for (uint256 i = 0; i < ids.length; i++) {
tokenCheck[ids[i]] = true;
amounts[i]= 1;
}
_mintBatch(to, ids, amounts, data);
}

// Single Address - Multiple Tokens
function mintSingleToMultiple(address account, uint256[] memory ids) public onlyOwner {
for (uint256 i = 0; i < ids.length; i++) {
require(!tokenCheck[ids[i]], "Token with this ID already exists");
_mint(account, ids[i], 1, "");
tokenCheck[ids[i]] = true;
}
}

// One by One
function tokenMint(address account,uint256 newItemId, uint256 amount)
 public onlyOwner
 {
 require(!tokenCheck[newItemId],"TokenID already exists");
_mint(account,newItemId,amount,'');
tokenCheck[newItemId] = true;
}

function tokenBurn(address account,uint256 id, uint256 amount) public onlyOwner returns (bool){
_burn(account,id,amount);
return true;
}

function setURI(string memory newuri) public onlyOwner {
_setURI(newuri);
}

function pause() public onlyOwner {
_pause();
}

function unpause() public onlyOwner {
_unpause();
}

function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
internal
whenNotPaused
override
{
super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
}
}
