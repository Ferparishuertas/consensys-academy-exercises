pragma solidity ^0.4.6;

import "./Owned.sol";

/**
 * This contract Manages a Database
 */
contract StockDatabase is Owned {

	uint public balance;
	mapping(address => bool) public administrators;
	mapping(bytes32 => Product) public products;


	struct Product {
	   bytes32 sku;
       uint stock; 
       uint price;
    }

	
	modifier isAdministrator(){
		require(administrators[msg.sender]);
		_;

	}

	modifier hasStock(bytes32 sku, uint units){
		require(products[sku].stock >= units);
		_;

	}

	modifier enoughFunds(uint amount){
		require(balance > 0 && balance >= amount);
		_;

	}
	event AdministratorAdded(address added);

	event AdministratorRemoved(address added);

	event ProductAdded(address administrator, bytes32 sku, uint stock, uint price);

    event ProductRemoved(address administrator, bytes32 sku);
	
	event ProductBought(address buyer, bytes32 sku, uint stock, uint price);

	event AmountWithDrawn(address owner, uint amount);

	event AmountPaid(address owner, address receiver, uint amount);

	function StockDatabase () {
		
	}

	function addAdministrator(address admintoAdd) onlyOwner returns (bool) {
		AdministratorAdded(admintoAdd);
		administrators[admintoAdd] = true;
		return true;
	}

	function removeAdministrator(address admintoRemove) onlyOwner returns (bool) {
	    AdministratorRemoved(admintoRemove);
		administrators[admintoRemove] = false;
		return true;
	}

	function addProduct(bytes32 sku, uint stock, uint price) isAdministrator returns (bool){ 
	    ProductAdded(msg.sender,sku,stock,price);
		products[sku] = Product(sku, stock, price);
		return true;
	}

	function buyProduct(bytes32 sku, uint units) payable hasStock(sku, units) returns(bool){
        ProductBought(msg.sender,sku,units,units * products[sku].price);
        balance += msg.value;
        products[sku].stock -= units;
        return true;
    }

    function removeProduct(bytes32 sku) isAdministrator returns(bool){
        ProductRemoved(msg.sender,sku);
        //TODO:SKU EXISTS
       	delete products[sku];
        return true;
    }

    function withdraw(uint amount) onlyOwner enoughFunds(amount) returns (bool){    	
        AmountWithDrawn(msg.sender,amount);
    	balance -= amount;
    	return msg.sender.send(amount);
    }

    function pay(address receiver, uint amount) onlyOwner enoughFunds(amount) returns (bool){
        require (receiver != address(0));
        AmountPaid(msg.sender,receiver,amount);
    	balance -= amount;
    	return receiver.send(amount);
    }
    
    function ()  {}


     function kill() onlyOwner returns (bool){
        bool result = owner.send(balance);
        if (result) selfdestruct(owner);
        return result;
    }
}

