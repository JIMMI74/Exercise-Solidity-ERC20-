// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NeoToken is ERC20 {
    address public owner;

    constructor() ERC20("NeoToken", "NKT") {
        owner = msg.sender;
        _mint(owner, 100000000 * 10**decimals());
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner call function");
        _;
    }

    //function mint(address to, uint256 amount) public onlyOwner {
    //    _mint(to, amount);
    // }
}

//pragma solidity ^0.8.17;
//
//import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
//import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
//
//
//
//contract NeoToken is ERC20, ERC20Capped, ERC20Burnable {
//    address payable public owner;
//
//
//    constructor(uint256) ERC20("NeoToken", "NTK") ERC20Capped(1000*10**18) {
//        owner = payable(msg.sender);
//        ERC20._mint(msg.sender, 10000000 * (10 ** decimals()));
//    }
//    modifier onlyOwner{
//        require(msg.sender == owner);
//        _;
//    }
//
//
//    function _mint(address account, uint256 amount) internal virtual override(ERC20Capped, ERC20) {
//        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
//        super._mint(account, amount);
//    }
//
//}
