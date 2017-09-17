pragma solidity ^0.4.6;

import "./ShopFront.sol";

contract ShopFrontHub is Pauseable {

	address [] public shopFronts;
	mapping(address => bool) shopFrontExists;

	event NewShopFront(address newShopFront);

	modifier onlyIfShopFront(address shopFront) { 
		require(shopFront != address(0x0));
		require(shopFrontExists[shopFront]);
		_; 
	}
	
	function ShopFrontHub(){

	}



	function getShopFrontsCount() public constant returns (uint shopFrontsCount){
		return shopFronts.length;
	}

	function newShopFront() public returns (address shopFrontContract){

		ShopFront trustedShopFront = new ShopFront(msg.sender);
		shopFronts.push();
		shopFrontExists[trustedShopFront]=true;
		NewShopFront(trustedShopFront);
		return trustedShopFront;
	}

	//Pass through Admin controls


	function addAdministrator(address shopFront, address admintoAdd) isNotPaused onlyOwner onlyIfShopFront(shopFront) returns (bool) {
		ShopFront trustedShopFront = ShopFront(shopFront);
		return trustedShopFront.addAdministrator(admintoAdd);
	}

	function removeAdministrator(address shopFront, address admintoRemove) isNotPaused  onlyOwner onlyIfShopFront(shopFront) returns (bool) {
	    ShopFront trustedShopFront = ShopFront(shopFront);
		return trustedShopFront.removeAdministrator(admintoRemove);
	}


	function stopShopFront(address shopFront) isNotPaused onlyOwner onlyIfShopFront(shopFront) returns (bool success){
		ShopFront trustedShopFront = ShopFront(shopFront);
		return(trustedShopFront.pause());
	}

	function startShopFront(address shopFront) isNotPaused onlyOwner onlyIfShopFront(shopFront) returns (bool success){
		ShopFront trustedShopFront = ShopFront(shopFront);
		return(trustedShopFront.start());
	}

	function changeShopFrontOwner(address shopFront, address newOwner) isNotPaused onlyOwner onlyIfShopFront(shopFront) returns (bool success){
		ShopFront trustedShopFront = ShopFront(shopFront);
		return(trustedShopFront.transferOwnership(newOwner));
	}

	function withdraw(address shopFront, uint amount) isNotPaused onlyOwner  onlyIfShopFront(shopFront) returns (bool){    	
        ShopFront trustedShopFront = ShopFront(shopFront);
		return(trustedShopFront.withdraw(amount));
    }

    function pay(address shopFront, address receiver, uint amount) isNotPaused onlyOwner  onlyIfShopFront(shopFront)  returns (bool){
        ShopFront trustedShopFront = ShopFront(shopFront);
		return(trustedShopFront.pay(receiver,amount));
    }
}