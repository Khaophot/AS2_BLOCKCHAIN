// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract ForestRoom {  

  mapping (bytes32 => bool) private listRoom;

  //---events---
  event NameAdded(
    address from,   
    string text,
    bytes32 hash,
    string time
  );
  
  event ReserveError(
    address from,
    string text,
    string reason
  );

  // store the proof for a room in the contract state
  function recordProof(bytes32 proof) private {
    listRoom[proof] = true;
  }
  
  // record a room name
  function reserve(string memory name, string memory time) public payable {

    //---check if string was previously stored---
    if (listRoom[hashing(name)]) {
        //---fire the event---
        emit ReserveError(msg.sender , name, "This Room was reserved");
        //---refund back to the sender---
        payable(msg.sender).transfer(msg.value);
        //---exit the function---
        return;
    }
 
    recordProof(hashing(name));
    
    //---fire the event---
    emit NameAdded(msg.sender, name, 
        hashing(name), time);
    
}
  
  // SHA256 for Integrity
  function hashing(string memory name) private 
  pure returns (bytes32) {
    return sha256(bytes(name));
  }
  
  // check name of room in this class
  function checkName(string memory name) public 
  view returns (bool) {
    return listRoom[hashing(name)];
  }
}