//Splitter  Practice

pragma solidity ^0.4.6;

contract Splitter  {
    
    address public owner ;
    address public receiver1;
    address public receiver2;
    mapping(address => uint) balances;
    
    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function Splitter() {
    
        owner = msg.sender;
    }

    function kill() isOwner returns (bool){
        bool result = owner.send(balance);
        if (result) selfdestruct(owner);
        return result;
    }
    
    function showBalance() constant returns (uint){
        return this.balance;
    }
    
    
    function pay(address receiver1, address receiver2) public payable returns (bool){
        require(msg.value > 0);
        require(receiver1 != 0 );
        require(receiver2 != 0 );

        balances[receiver1]+=msg.value/2;
        balances[receiver2]+=msg.value/2;
        balances[msg.sender] += msg.value%2;
        return true;
    }

    function withdraw() constant returns (bool){
      require(balances[msg.sender]!=0);
      bool result = msg.sender.send()
      return result;
    }

    
    function ()  {}
}
