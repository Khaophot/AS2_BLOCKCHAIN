// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract ProofOfStudent {  

  mapping (bytes32 => bool) private listStudent;

  //---events---
  event NameAdded(
    address from,   
    string text,
    bytes32 hash
  );
  
  event RegistrationError(
    address from,
    string text,
    string reason
  );

  // store the proof for a student in the contract state
  function recordProof(bytes32 proof) private {
    listStudent[proof] = true;
  }
  
  // record a student name
  function registration(string memory name) public payable {
    
    //---check if string was previously stored---
    if (listStudent[hashing(name)]) {
        //---fire the event---
        emit RegistrationError(msg.sender , name, 
              "This Student was added preciously");
        //---refund back to the sender---
        payable(msg.sender).transfer(msg.value);

        //---exit the function---
        return;
    }
 
    recordProof(hashing(name));
    
    //---fire the event---
    emit NameAdded(msg.sender, name, 
        hashing(name));
    
  }
  
  // SHA256 for Integrity
  function hashing(string memory name) private 
  pure returns (bytes32) {
    return sha256(bytes(name));
  }
  
  // check name of student in this class
  function checkName(string memory name) public 
  view returns (bool) {
    return listStudent[hashing(name)];
  }
}