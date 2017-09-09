//Remittance  Practice


pragma solidity ^0.4.6;

contract Remittance  {
    
    address public owner;
    uint public maxSeconds = 100;
    uint public fee = 40;
    
    struct Challenge {
        address sender;
        address receiver;
        uint challengedValue;
        uint deadline;
        bytes32 password1;
    }
    
     mapping(bytes32 => Challenge) public challenges;
     mapping(bytes32 => bool) public withDrawm;
     mapping(bytes32 => bool) public cancelledNonWithDrawn;

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier isChallengeSender(bytes32 challengeId) {
        require(msg.sender == challenges[challengeId].sender);
        _;
    }

     modifier isChallengePassedAndNotWithDrawn(bytes32 challengeId) {
        require(now > challenges[challengeId].deadline);
        require(!withDrawm[challengeId]);
        require(!cancelledNonWithDrawn[challengeId]);
        _;
    }


    
    function Remittance(){
      owner = msg.sender;   
    }
    
    function openChallenge(address receiver, bytes32 password1, uint deadline) payable returns (bytes32 challengeId) {
        require(deadline <= maxSeconds);
        require(msg.value > fee);
        challengeId = keccak256(msg.sender,receiver,msg.value);
        uint toChallenge = msg.value - fee;
        challenges[challengeId] = Challenge(msg.sender, receiver, toChallenge ,now + deadline,password1);
        owner.transfer(fee);
        return challengeId;
    }
    
    function withDraw(bytes32 challengeId, bytes32 password1) returns (bool){
        require(challenges[challengeId].receiver == msg.sender);
        require(challenges[challengeId].password1 == keccak256(password1));
        require(now < challenges[challengeId].deadline);
        withDrawm[challengeId] = true;
        msg.sender.transfer(challenges[challengeId].challengedValue);
        return true;
    }

    function cancelNonWithDrawnChallenge(bytes32 challengeId) isChallengeSender(challengeId) isChallengePassedAndNotWithDrawn(challengeId)  returns (bool) {
        cancelledNonWithDrawn[challengeId] = true;
        msg.sender.transfer(challenges[challengeId].challengedValue);
        return true;
    }

    function kill() isOwner returns (bool) {

        selfdestruct(owner);
        return true;
    }

    
    function ()  {}

}