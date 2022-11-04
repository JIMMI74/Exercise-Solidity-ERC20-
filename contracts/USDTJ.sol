// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract USDTJ is ERC20 {
   address public  owner;

    constructor() ERC20("USDTJ", "UDJ") {
        owner = msg.sender;
        _mint(owner, 100000000 * 10 ** decimals());

    }

    modifier onlyOwner {
        require(msg.sender ==owner, "Only the owner call function");
        _;
    }

    //function mint(address to, uint256 amount) public onlyOwner {
    //    _mint(to, amount);
    // }
}
