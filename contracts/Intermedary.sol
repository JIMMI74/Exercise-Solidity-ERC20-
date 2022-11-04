// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "./NeoToken.sol";
import "./USDTJ.sol";

contract Intermediary {
    string public name = "Intermediary";
    address public owner;

    NeoToken public neoToken;
    USDTJ public usdtj;

    address[] public investors;

    mapping(address => uint256) public depositStakingBalance;
    mapping(address => bool) public staked;
    mapping(address => bool) public isStaking;
    mapping(address => uint256) public reward;

    constructor(NeoToken _neoToken, USDTJ _usdtj) {
        neoToken = _neoToken;
        usdtj = _usdtj;
        owner = msg.sender;
    }

    function stake(uint256 _amount) public {
        require(_amount > 0, "The amount must be more than zero");
        require(
            usdtj.balanceOf(msg.sender) >= _amount,
            "You don't have enough tokens"
        );

        usdtj.transferFrom(msg.sender, address(this), _amount);
        depositStakingBalance[msg.sender] += _amount;

        if (!staked[msg.sender]) {
            investors.push(msg.sender);
        }

        isStaking[msg.sender] = true;
        staked[msg.sender] = true;
    }

    function claim() public {
        require(isStaking[msg.sender] == true, "You are not staking");
        require(
            depositStakingBalance[msg.sender] > 0,
            "You don't have any tokens"
        );

        uint256 userReward = depositStakingBalance[msg.sender] / 10 ; // reward  10%

        require(userReward > 0, "The amount must be more than zero");
        require(
            neoToken.balanceOf(address(this)) >= userReward,
            "The amount must be more than zero"
        );

        neoToken.transfer(msg.sender, userReward);
    }

    // unstake tokens
    function unstake() public {
        uint256 balance = depositStakingBalance[msg.sender];
        // require the amount to be greater than zero
        require(balance > 0, "staking balance cannot be less than zero");

        claim();

        // transfer the tokens to the specified contract address from our bank
        usdtj.transfer(msg.sender, balance);

        // reset staking balance
        depositStakingBalance[msg.sender] = 0;

        // Update Staking Status
        isStaking[msg.sender] = false;
    }
}
