pragma solidity ^0.4.6;

import './MappingWithStruct.sol';

// NOTES:

// This implemenation is for multi use
// each funder supplies the approved address to withdraw. 
// on withdraw contract splits off a .01 eth fee to the owner

// todo:    Create a deadline in blocks, assign that to the entity
//          in order to allow owner to withdraw after deadline expires.


contract Splitter is MappingWithStruct {
    address public owner;
    uint public balance;
    uint public fee = 10000000000000000; // .01 Eth

    function Splitter() { owner = msg.sender; }

    function Withdraw() returns(bool) {
        // make sure it's actually been assigned a value
        if (!isEntity(msg.sender)) {revert();}

        // a little for me, the rest for you
        var instance = entityStructs[msg.sender];
        owner.transfer(fee);
        msg.sender.transfer(instance.amount - fee);
        // resolve as complete
        deleteEntity(msg.sender);
        return true;
    }

    function Fund(address approvedAddress) 
        payable
        returns(bool)
    {
        // Checks to make sure minimum fee is met
        if (msg.value <= fee) {revert();}

        // Increases amount, or creates amount
        if (isEntity(approvedAddress)) {
            entityStructs[approvedAddress].amount += msg.value;
        } else {
            newEntity(approvedAddress, msg.value);
        }
        return true;
    }

}