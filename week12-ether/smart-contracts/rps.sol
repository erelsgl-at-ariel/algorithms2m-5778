// A simple rock paper scissors game on ethereum. 
// A naive implementation, just to showcase some basic features of Solidity.
// Created  by: Sebastian C. Burgel 
// Modified by: Erel Segal-Halevi

pragma solidity ^0.4.11;

contract RockPaperScissors {
  /* General utilities */  

  // These will be assigned at the construction/ phase, where `msg.sender` is the account creating this contract.
  address public owner = msg.sender;

  // This modifier guarantees that the one executing the function is the given account number.
  modifier onlyBy(address _account) {
    require(msg.sender == _account);
    _;    // If the "require" is OK, then proceed with the rest of the function.
  }

  // This modifier requires a certain fee being associated with a function call.
  // If the caller sent too much, he or she is refunded, but only after the function body.
  modifier costs(uint _amount) {
    require(msg.value >= _amount);
    _;
    if (msg.value > _amount)
      msg.sender.transfer(msg.value - _amount);
  }

  function retire() onlyBy(owner) public { 
      selfdestruct(/* and return the money to */owner);
  }


/* Utilities specific to the game */  

  mapping (string => mapping(string => int)) payoffMatrix;
  address public player1;
  address public player2;
  string public player1Choice;
  string public player2Choice;
  string public reply;

  constructor() public {
    player1 = 0;
    player2 = 0;
    player1Choice = "";
    player2Choice = "";
    payoffMatrix["rock"]["rock"] = 3;
    payoffMatrix["rock"]["paper"] = 2;
    payoffMatrix["rock"]["scissors"] = 1;
    payoffMatrix["paper"]["rock"] = 1;
    payoffMatrix["paper"]["paper"] = 3;
    payoffMatrix["paper"]["scissors"] = 2;
    payoffMatrix["scissors"]["rock"] = 2;
    payoffMatrix["scissors"]["paper"] = 1;
    payoffMatrix["scissors"]["scissors"] = 3;
  }

  function play(string choice) public
           payable
           costs(100 finney /* = 0.1 ether */)
           returns (string)  {
    if (player1 == 0)  {   // sender is the first player
      player1 = msg.sender;
      player1Choice = choice;
      reply = "Your choice is registered; wait for the next player!";
    } else {               // sender is the second player
      player2 = msg.sender;
      player2Choice = choice;
      int winner =  payoffMatrix[player1Choice][player2Choice];

      // pay winner and inform
      if (winner == 1) {
          player1.transfer(180 finney);
          reply = "Your lost!";
      } else if (winner == 2) {
          player2.transfer(180 finney);
          reply = "You won!";
      } else if (winner == 3) {   // tie
          player1.transfer(90 finney);
          player2.transfer(90 finney);
          reply = "There was a tie!";
      } else {
          player1.transfer(80 finney);
          player2.transfer(80 finney);
          reply = "There was an illegal choice!";
      }

      // unregister players and choices
      player1Choice = "";
      player2Choice = "";
      player1 = 0;
      player2 = 0;
    }
    return reply;
  }
}
