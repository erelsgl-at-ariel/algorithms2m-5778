pragma solidity ^0.4.11;

/* 
A base-class for creating a contract that can be "retired" and return its funds to its owner. 
Also uses some patterns from http://solidity.readthedocs.io/en/develop/common-patterns.html
*/

contract Mortal {
  // These will be assigned at the construction/ phase, where `msg.sender` is the account creating this contract.
  address public owner = msg.sender;
  uint public creationTime = now;

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
      msg.sender.send(msg.value - _amount);
  }

  function retire() onlyBy(owner) costs(0) { 
      selfdestruct(/* and return the money to */owner); 
  }
}
