// SPDX-License-Identifier: UNLICENSED
// @author: varunarya
// contact: varunp.b832@gmail.com

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//--------ERC20 inherited standard token--------//
contract ERC20Token is ERC20 {
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        address owner
    ) ERC20(name, symbol) {
        _mint(owner, initialSupply);
    }
}

//--------Factory contract-----------------------//
contract ERC20TokenGenerator is Ownable {
    //--------events----------------------------//
    event ERC20TokenAddress(
        IERC20 indexed tokenAddress,
        address indexed owner,
        uint256 initialSupply
    );
    //----------state variabels-----------------//
    IERC20 tokenAddress;
    uint256 count;

    //-------------write function---------------//
    function create(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        address owner
    ) public onlyOwner {
        tokenAddress = new ERC20Token(name, symbol, initialSupply, owner);
        emit ERC20TokenAddress(tokenAddress, owner, initialSupply);
        count++;
    }

    //-------read function---------------------//
    function getTotalCreatedTokens() public view returns (uint256) {
        return count;
    }
}
