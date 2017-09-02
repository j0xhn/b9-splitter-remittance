pragma solidity ^0.4.6;

contract MappingWithStruct {

  struct EntityStruct {
    uint amount;
    bool isEntity;
  }

  mapping (address => EntityStruct) public entityStructs;

  function isEntity(address entityAddress) public constant returns(bool isIndeed) {
    return entityStructs[entityAddress].isEntity;
  }

  function newEntity(address entityAddress, uint amount) public returns(bool success) {
    if (isEntity(entityAddress)) {revert();} 
    entityStructs[entityAddress].amount = amount;
    entityStructs[entityAddress].isEntity = true;
    return true;
  }

  function deleteEntity(address entityAddress) public returns(bool success) {
    if (!isEntity(entityAddress)) {revert();}
    entityStructs[entityAddress].isEntity = false;
    return true;
  }

  function updateEntity(address entityAddress, uint amount) public returns(bool success) {
    if (!isEntity(entityAddress)) {revert();}
    entityStructs[entityAddress].amount = amount;
    return true;
  }
}