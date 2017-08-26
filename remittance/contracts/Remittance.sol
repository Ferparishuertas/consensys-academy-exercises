
pragma solidity ^0.4.6;

contract Remittance  {
    
    address public owner ;
    uint maxDays = 100 ;
    uint fee = 40;
    
    struct Challenge {
        address sender;
        address receiver;
        uint challengedValue;
        uint deadline;
        bytes32 password;
    }
    
     mapping(bytes32 => Challenge) public challenges;

    
    function Remittance(){
      owner = msg.sender;   
    }
    
    function openChallenge(address receiver, bytes32 password1,bytes32 password2, uint deadline) payable returns (bool) {
        require(challenges[password1].deadline != 0);
        require(deadline < maxDays);
        require(msg.value > fee);
        challenges[password1] = Challenge(msg.sender, receiver, msg.value,now + deadline * 1 days,password2);
        return true;
    }
    
    function withDraw(bytes32 password1, bytes32 password2) returns (bool){
        require(now < challenges[password1].deadline);
        require(challenges[password1].password == password2);
        var toWithDraw = challenges[password1].challengedValue - fee;
        msg.sender.transfer(toWithDraw);
        owner.transfer(fee);
        return true;
    }

    function kill() {
        selfdestruct(owner);
    }

    
    function ()  {}
}
