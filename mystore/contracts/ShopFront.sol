pragma solidity ^0.4.6;

import "./Pauseable.sol";

/**
 * This contract Manages a Database
 */
contract ShopFront is Pauseable {

	uint public balance;
	mapping(address => bool) public administrators;
	mapping(bytes32 => Product) private products;
	bytes32[] private productList;


	struct Product {
       uint stock; 
       uint price;
       bool isProduct;
       uint index;
       bool isActive;
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

	modifier productDoesNotExists(bytes32 sku){
		require(!products[sku].isProduct);
		_;

	}


	modifier productMustExist(bytes32 sku){
		require(products[sku].isProduct);
		_;

	}

	modifier productIsActive(bytes32 sku){
		require(products[sku].isActive);
		_;

	}

	modifier productIsNotActive(bytes32 sku){
		require(!products[sku].isActive);
		_;

	}



	event AdministratorAdded(address added);

	event AdministratorRemoved(address added);

	event ProductAdded(address administrator, bytes32 sku, uint stock, uint price, uint index);

    event ProductDeactivated(address administrator, bytes32 sku);

    event ProductActivated(address administrator, bytes32 sku);
	
	event ProductBought(address buyer, bytes32 sku, uint stock, uint price);

	event AmountWithDrawn(address owner, uint amount);

	event AmountPaid(address owner, address receiver, uint amount);

	event StockIncreased(address, bytes32 sku, uint units);

	function StockDatabase () {
		
	}

	function addAdministrator(address admintoAdd) isNotPaused onlyOwner returns (bool) {
		AdministratorAdded(admintoAdd);
		administrators[admintoAdd] = true;
		return true;
	}

	function removeAdministrator(address admintoRemove) isNotPaused onlyOwner returns (bool) {
	    AdministratorRemoved(admintoRemove);
		administrators[admintoRemove] = false;
		return true;
	}

	function addProduct(bytes32 sku, uint stock, uint price) productDoesNotExists(sku) isNotPaused isAdministrator returns (bool){ 
	   
		products[sku].stock = stock;
		products[sku].price = price;
		products[sku].index = productList.push(sku) - 1;
		products[sku].isProduct = true;
		products[sku].isActive = true;
        ProductAdded(msg.sender,sku,stock,price,products[sku].index);
		return true;
	}

	function buyProduct(bytes32 sku, uint units) payable isNotPaused productMustExist(sku) productIsActive(sku) hasStock(sku, units) returns(bool){
        ProductBought(msg.sender,sku,units,units * products[sku].price);
        balance += msg.value;
        products[sku].stock -= units;
        return true;
    }

    function deactivateProduct(bytes32 sku) productMustExist(sku) productIsActive(sku) isNotPaused isAdministrator returns(bool){
        ProductDeactivated(msg.sender,sku);
       	products[sku].isActive = false;
        return true;
    }

     function activateProduct(bytes32 sku) productMustExist(sku) productIsNotActive(sku) isNotPaused isAdministrator returns(bool){
        ProductDeactivated(msg.sender,sku);
       	products[sku].isActive = true;
        return true;
    }

    function withdraw(uint amount) isNotPaused onlyOwner enoughFunds(amount) returns (bool){    	
        AmountWithDrawn(msg.sender,amount);
    	balance -= amount;
    	return msg.sender.send(amount);
    }

    function pay(address receiver, uint amount) isNotPaused onlyOwner enoughFunds(amount) returns (bool){
        require (receiver != address(0));
        AmountPaid(msg.sender,receiver,amount);
    	balance -= amount;
    	return receiver.send(amount);
    }
    
    function getProductCount() public constant returns(uint count){
    	 return productList.length;
    }

    function getProduct(bytes32 sku) isNotPaused productMustExist(sku) public constant returns(bool isProduct,uint stock, uint price, uint index)
   {
	    return(
	      products[sku].isProduct
	      products[sku].stock, 
	      products[sku].price,
	      products[sku].index);
   }

   function increasStock(bytes32 sku, uint units) isNotPaused productMustExist(sku) public  returns(bool)
   {
   		StockIncreased(msg.sender, sku, units);
   		products[sku].stock+=units; 
	    return true;
   }



    function ()  {}


     function kill() onlyOwner returns (bool){
        bool result = owner.send(balance);
        if (result) selfdestruct(owner);
        return result;
    }
}

