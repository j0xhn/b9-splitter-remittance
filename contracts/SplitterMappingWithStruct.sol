pragma solidity ^0.4.6;

contract MappingWithStruct {

  struct EntityStruct {
    bytes32 id;
    address address1;
    address address2;
    uint amount;
    address funder;
    bool isEntity;
  }

  mapping (bytes32 => EntityStruct) public entityStructs;

  function isEntity(bytes32 id) public constant returns(bool isIndeed) {
    return entityStructs[id].isEntity;
  }

  function newEntity(
    bytes32 id, 
    address address1,
    address address2,
    uint amount, 
    address funder
  ) 
    public 
    returns(bool success) 
  {
    if (isEntity(id)) {revert();} 
    entityStructs[id].amount = amount;
    entityStructs[id].funder = funder;
    entityStructs[id].address1 = address1;
    entityStructs[id].address2 = address2;
    entityStructs[id].isEntity = true;
    return true;
  }

  function deleteEntity(bytes32 id) public returns(bool success) {
    if (!isEntity(id)) {revert();}
    entityStructs[id].isEntity = false;
    return true;
  }
}