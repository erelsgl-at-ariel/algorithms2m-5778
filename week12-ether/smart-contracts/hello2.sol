// A second "hello world" program with an ability to change the status.
pragma solidity ^0.4.24;

contract hello2  {
     
     // A dynamic string variable.
     // Change to "bytes32" to limit its length to 32 bytes.
     string public greeting;
     
     // Events that get logged on the blockchain
     event GreetingChanged(string _greeting);

     constructor(string _greeting) public {
         greeting = _greeting;
     }
 
     // Change the greeting message
     function setGreeting(string _greeting) public {
         greeting = _greeting;
         
         // Log an event that the greeting message has been updated
         emit GreetingChanged(_greeting);
     }
 
     // Get the greeting message
     function greet() public view returns (string _greeting) {
        _greeting = greeting;
     }
}

