//Splitter  Practice

pragma solidity ^0.4.6;

contract Splitter  {
    
    address public owner ;
    address public receiver1;
    address public receiver2;
    uint public balance;
    
    
    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function Splitter(address ownerAddress,address receiver1Address,address receiver2Address) {
    
        owner = ownerAddress;
        receiver1 = receiver1Address;
        receiver2 = receiver2Address;
    }

    function kill() isOwner{
        owner.transfer(balance);
        selfdestruct(owner);
    }
    
    function showBalance() constant returns (uint){
        return balance;
    }
    
    function showAddressBalance(address caller) constant returns (uint){
        return caller.balance;
    }
    
    function pay() payable returns (bool){
        require(msg.value > 0);
        if(msg.sender != owner){
            balance += msg.value;   
        }
        else{
          receiver1.transfer(msg.value/2);
          receiver2.transfer(msg.value/2);
        }
        return true;
    }
    
    function ()  {}
}
