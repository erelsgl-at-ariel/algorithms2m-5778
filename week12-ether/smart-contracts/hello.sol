pragma solidity ^0.4.8;

contract Hello  {
     
     // A string variable
     string public greeting;
     
     // Events that gets logged on the blockchain
     event GreetingChanged(string _greeting);
     
     // The function with the same name as the class is a constructor
     function Hello(string _greeting) {
         greeting = _greeting;
     }
 
     // Change the greeting message
     function setGreeting(string _greeting) {
         greeting = _greeting;
         
         // Log an event that the greeting message has been updated
         GreetingChanged(_greeting);
     }
 
     // Get the greeting message
     function greet() constant returns (string _greeting) {
        _greeting = greeting;
     }
}

