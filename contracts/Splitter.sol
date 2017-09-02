pragma solidity ^0.4.6;

// NOTES:

// This implemenation is for multi use
// each funder supplies an ID & approved address. 
// the person to withdraw submits the correct password/id pair
// splits off a .01 eth fee to the owner


contract Splitter {
    address public owner;
    uint public balance;

    function Splitter() { owner = msg.sender; }

    struct EntityStruct {
        address entityAddress;
        uint amount;
    }

    EntityStruct[] public entityStructs;
    mapping(address => bool) knownEntity;

    function isEntity(address entityAddress) public constant returns(bool isIndeed) {
        return knownEntity[entityAddress];
    }

    function getEntityCount() public constant returns(uint entityCount) {
        return entityStructs.length;
    }

    function newEntity(address entityAddress, uint _amount) public returns(uint rowNumber) {
        if (isEntity(entityAddress)) {revert();}
        EntityStruct storage instance;
        instance.amount = _amount;
        knownEntity[entityAddress] = true;
        return entityStructs.push(instance) - 1;
    }


    function Withdraw() {
        // make sure it's actually been assigned a value
        if (isEntity(entityStructs[msg.sender])) {revert();}

        var instance = entityStructs[msg.sender];
        msg.sender.transfer(instance.amount);
        return true;
    }

    function Fund(address _approvedAddress) 
        payable
    {
        // Appropriates how much can be withdrawn
        entityStructs[_approvedAddress].amount += msg.value;
        return true;
    }

}