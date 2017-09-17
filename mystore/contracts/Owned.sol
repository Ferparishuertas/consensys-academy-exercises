pragma solidity ^0.4.6;


contract Owned {

    address public owner;
    
    function Owned() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    event NewOwner(address indexed old, address indexed current);

    function transferOwnership(address newOwner) external onlyOwner returns (bool){
        require(newOwner != address(0));
        NewOwner(owner,newOwner);
        owner = newOwner;
        return true;
    }
}
