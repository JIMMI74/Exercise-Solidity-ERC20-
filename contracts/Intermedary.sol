// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import './NeoToken.sol';
import './USDTJ.sol';

contract Intermediary {
  string public name = 'Intermediary';
  address public owner;
  NeoToken public neoToken;
  USDTJ public usdtj;

  address[] public investors;

  mapping(address => uint) public depositStakingBalance;
  mapping(address => bool) public staked;
  mapping(address => bool) public isStaking;
  mapping(address => uint)public reward;


  constructor(NeoToken _neoToken, USDTJ _usdtj)  {
    neoToken = _neoToken;
    usdtj = _usdtj;
    owner = msg.sender;
  }


  function depositToken (uint _amount) public {
    if(_amount > 0) {
       usdtj.transferFrom(msg.sender, address(this), _amount);
    //put to stake
    depositStakingBalance[msg.sender] +=  _amount;
    }

    else {
    require(_amount > 0, 'The amount must be more than zero');
    }
     if (!staked[msg.sender]) {
      investors.push(msg.sender);
      // update stack balance
     }
    {
      isStaking[msg.sender]= true;
      staked[msg.sender]= true;
    }

  }

      // transfer and reward
  function tokenRewards() public {
    require(msg.sender == owner, 'call only owner'); // must to be oly owner
      for (uint i=0; i<investors.length; i++){
        address drawer = investors[i]; // track address investors
        uint balance = depositStakingBalance[drawer] / 10 ; // reward  10%
        if(balance > 0){
        neoToken.transfer(drawer, balance);// transfer token  //
        }

      }

  }
  // unstake tokens
  function unstakeTokens() public {
    uint balance = depositStakingBalance[msg.sender];
    // require the amount to be greater than zero
    require(balance > 0, 'staking balance cannot be less than zero');

    // transfer the tokens to the specified contract address from our bank
    usdtj.transfer(msg.sender, balance);

    // reset staking balance
    depositStakingBalance[msg.sender] = 0;

    // Update Staking Status
    isStaking[msg.sender] = false;

  }
}
