pragma solidity ^0.4.6;

contract MappingWithStruct {

  struct EntityStruct {
    uint amount;
    address funder;
    bytes32 passwordHash;
    bool isEntity;
  }

  mapping (bytes32 => EntityStruct) public entityStructs;

  function isEntity(bytes32 entityAddress) public constant returns(bool isIndeed) {
    return entityStructs[entityAddress].isEntity;
  }

  function newEntity(
    bytes32 entityAddress, 
    uint amount, 
    bytes32 passwordHash, 
    address funder
  ) 
    public 
    returns(bool success) 
  {
    if (isEntity(entityAddress)) {revert();} 
    entityStructs[entityAddress].amount = amount;
    entityStructs[entityAddress].funder = funder;
    entityStructs[entityAddress].passwordHash = passwordHash;
    entityStructs[entityAddress].isEntity = true;
    return true;
  }

  function deleteEntity(bytes32 entityAddress) public returns(bool success) {
    if (!isEntity(entityAddress)) {revert();}
    entityStructs[entityAddress].isEntity = false;
    return true;
  }
}