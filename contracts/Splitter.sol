pragma solidity ^0.4.6;

import './SplitterMappingWithStruct.sol';
// NOTES:

// This implemenation is for multi use
// each funder supplies the approved addressess to split between. 

// todo:    Create a deadline in blocks, assign that to the entity
//          in order to allow owner to withdraw after deadline expires.
// todo:    Factor in if odd number with 1 wei left over.
// todo:    Require party to withdraw their own half, 
//          adding the recent withdrawal address to a sort of "blacklist"

contract Splitter is MappingWithStruct {
    address public owner;
    uint public balance;

    function Splitter() { owner = msg.sender; }

    event LogFund(bytes32 id, address funder, uint amount);
    event LogWithdrawal(address recipient, uint amount);
    event LogAccidentalFund(address recipient, uint amount);

    function Fund(bytes32 id, address address1, address address2) 
        payable
        returns(bool)
    {
        // Increases or creates amount with specified id
        if (isEntity(id)) {revert();}
        // Ensure's they've provided an id and passwordHash
        if (address1 == 0 || address2 == 0) {revert();}
        newEntity(id, address1, address2, msg.value, msg.sender);
        LogFund(id, msg.sender, msg.value);
        return true;
    }

    function Withdraw(bytes32 id) returns(bool) {
        // make sure it's actually been assigned a value
        if (!isEntity(id)) {revert();}
        var instance = entityStructs[id];

        // make sure address requesting to split is authorized
        if (msg.sender == instance.address1 || msg.sender == instance.address2) {
          deleteEntity(id);
          if (!instance.address1.send(instance.amount/2)) {revert();}
          if (!instance.address2.send(instance.amount/2)) {revert();}
          LogWithdrawal(msg.sender, instance.amount);
          return true;
        } else {revert();}
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