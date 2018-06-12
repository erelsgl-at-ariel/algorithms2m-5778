// From: http://www.talkcrypto.org/blog/2018/01/04/hello-world-ethereum-smart-contract/
pragma solidity ^0.4.24;

contract hello1 {
    // bytes32 - a single word of the EVM - exactly 32 bytes.
    // string  - a dynamic string of UTF-8 chars.  
    function greet() public pure returns (bytes32 _greeting) {
        _greeting = 'Hello World!';
    }
}

