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

    function Splitter() { owner = msg.sender; }

    event LogFund(bytes32 id, address funder, uint amount);
	event LogWithdrawal(address recipient, uint amount);
	event LogAccidentalFund(address recipient, uint amount);

    function Withdraw(bytes32 id, bytes32 password) returns(bool) {
        // make sure it's actually been assigned a value
        if (!isEntity(id)) {revert();}
        var instance = entityStructs[id];

        // make sure password is correct
        if (!(keccak256(password) == instance.passwordHash)) {revert();}
        msg.sender.transfer(instance.amount);
        // resolve as complete
        LogWithdrawal(msg.sender, instance.amount);
        deleteEntity(id);
        return true;
    }

    function Fund(bytes32 id, bytes32 passwordHash) 
        payable
        returns(bool)
    {
        // Increases or creates amount with specified id
        if (isEntity(id)) {
            entityStructs[id].amount += msg.value;
        // Ensure's they've provided an id and passwordHash
        } else if (id.length > 0 && passwordHash.length > 0) {
            LogFund(id, msg.sender, msg.value);
            newEntity(id, msg.value, passwordHash, msg.sender);
        } else {revert();}
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
        LogAccidentalFund(msg.sender, msg.value);
    }

}