pragma solidity ^0.4.6;



contract Splitter {
    address public owner;
    bytes32 public passwordHash;
    uint public balance;

    function Splitter() { owner = msg.sender; }

    modifier Authentication(bytes32 password) {
        // only including 1 password, because only the person sending the money
        // should be the one to set the password and give it to the person receiving it.
        // They set the hash when initiating the transfer,
        // the person to withdraw then submits the proposed password
        // out contract hashes to determine if correct
        if (keccak256(password) == passwordHash)
        _;
    }


    function Withdraw(bytes32 password) 
    Authentication(password) 
    {
        // withdraws ammount
        // if the owner does it, can withdraw after the deadline
    }

    function Transfer(bytes32 _passwordHash) 
        payable
    {
        passwordHash = _passwordHash;        
    }

}