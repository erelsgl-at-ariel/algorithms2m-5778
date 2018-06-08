pragma solidity ^0.4.11;

// simple rock paper scissors game on ethereum in a very naive implementation, just to showcase some basic features of Solidity
// Created  by: Sebastian C. Burgel 
// Modified by: Erel Segal-Halevi

contract rps {

  /* General utilities */  
  // These will be assigned at the construction/ phase, where `msg.sender` is the account creating this contract.
  address public owner = msg.sender;
  // uint public creationTime = now;

  modifier onlyBy(address _account) {
    require(msg.sender == _account);
    _;
  }

  // This modifier requires a certain/ fee being associated with a function call.
  // If the caller sent too much, he or she is refunded, but only after the function body.
  modifier costs(uint _amount) {
    require(msg.value >= _amount);
    _;
    if (msg.value > _amount)
      msg.sender.transfer(msg.value - _amount);
  }

  function retire() onlyBy(owner) { 
      selfdestruct(/* and return the money to */owner);
  }


/* RPS-specific utilities */  

  mapping (string => mapping(string => int)) payoffMatrix;
  address player1;
  address player2;
  string player1Choice;
  string player2Choice;

  function rps() {   // constructor
    player1 = 0;
    player2 = 0;
    player1Choice = "";
    player2Choice = "";
    payoffMatrix["rock"]["rock"] = 0;
    payoffMatrix["rock"]["paper"] = 2;
    payoffMatrix["rock"]["scissors"] = 1;
    payoffMatrix["paper"]["rock"] = 1;
    payoffMatrix["paper"]["paper"] = 0;
    payoffMatrix["paper"]["scissors"] = 2;
    payoffMatrix["scissors"]["rock"] = 2;
    payoffMatrix["scissors"]["paper"] = 1;
    payoffMatrix["scissors"]["scissors"] = 0;
  }

  function play(string choice) 
           payable
           costs(100 finney /* = 0.1 ether */)
           returns (string reply)  {
    if (player1 == 0)  {   // sender is the first player
      player1 = msg.sender;
      player1Choice = choice;
      return "Your choice is registered; wait for the next player!";
    } else {               // sender is the second player
      player2 = msg.sender;
      player2Choice = choice;
      int winner =  payoffMatrix[player1Choice][player2Choice];

      // pay winner and inform
      if (winner == 1) {
          player1.transfer(180 finney);
          reply = "Your partner won!";
      } else if (winner == 2) {
          player2.transfer(180 finney);
          reply = "You won!";
      } else {   // tie
          player1.transfer(90 finney);
          player2.transfer(90 finney);
          reply = "There is a tie!";
      }

      // unregister players and choices
      player1Choice = "";
      player2Choice = "";
      player1 = 0;
      player2 = 0;
    }
  }
}
