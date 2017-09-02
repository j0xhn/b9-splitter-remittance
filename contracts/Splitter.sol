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

    function Withdraw(bytes32 id, bytes32 password) returns(bool) {
        // make sure it's actually been assigned a value
        if (!isEntity(id)) {revert();}
        var instance = entityStructs[id];

        // make sure password is correct
        if (!(keccak256(password) == instance.passwordHash)) {revert();}
        // a little for me, the rest for you
        owner.transfer(fee);
        msg.sender.transfer(instance.amount - fee);
        // resolve as complete
        deleteEntity(id);
        return true;
    }

    function Fund(bytes32 id, bytes32 passwordHash) 
        payable
        returns(bool)
    {
        // Checks to make sure minimum fee is met
        if (msg.value <= fee) {revert();}

        // Increases amount, or creates amount
        if (isEntity(id)) {
            entityStructs[id].amount += msg.value;
        } else {
            newEntity(id, msg.value, passwordHash, msg.sender);
        }
        return true;
    }

    function kill() {
		if (msg.sender == owner) {
            selfdestruct(owner);
		}
	}

    function() payable {
        // whoops, I guess if someone accidentally
        // sends ETH to this contract I'll just
        // get to keep it ¯\_(ツ)_/¯
    }

}