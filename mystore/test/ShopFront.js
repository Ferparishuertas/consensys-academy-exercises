var ShopFront = artifacts.require("./ShopFront.sol");

contract('ShopFront', function(accounts) {

	var instance;	
	var owner = accounts[0];
	var address1 = accounts[1];
	var address2 = accounts[2];
    var skuPrice =  40;
    var stock = 1;

	beforeEach(function() {
		return ShopFront.new({from: owner}).then(thisInstance => {
          instance = thisInstance;
        });

	});

    it("Owner is owner", () => {

       return instance.owner({from: owner})
        .then(_owner  => {
            assert.strictEqual(_owner, owner, "Administrator not added");
            return; 
            });
 	});

    it("Add Adminsrator works", () => {
    	instance.addAdministrator(address1,{from: owner});
    	return instance.administrators(address1,{from: owner} )
        .then(result  => {
            assert.isTrue(result, "Administrator not on list");
            return instance.administrators(owner,{from: owner} )
            })
        .then(result  => {
        	assert.isFalse(result, "other admin must not be there");
         	return;
        });
 	});


 	it("Add Administrator cannot be done by non owner", () => {
    	return instance.addAdministrator(address1,{from: address1})
        .catch(result  => {
            assert.isTrue((result + '').indexOf('invalid opcode')  > -1, "Administrator not on list");
            return;
        });
        
 	});


 	it("Administrator can add Product",  async () => {
 		await instance.addAdministrator(address1,{from: owner});
 		await instance.addProduct("sku-1",stock,skuPrice,{from: address1});
    	return await instance.getProduct("sku-1",{from: owner})
        .then(product  => {
            assert.isTrue(product[0], "Cannot add product as admin");
            return;
        });
        
 	});
   
   it("Product cannot be added by non administrator", () => {
    	return instance.addProduct("sku-1",stock,40,{from: owner})
        .catch(result  => {
            assert.isTrue((result + '').indexOf('invalid opcode')  > -1, "Non Administrator can add");
            return;
        });
        
 	});

   it("user can buy Product",  async () => {
   	    await instance.addAdministrator(address1,{from: owner});
 		await instance.addProduct("sku-1",stock,skuPrice,{from: address1});
 	    await instance.buyProduct("sku-1",stock,{from: address2, value:skuPrice });
        return await instance.getProduct("sku-1",{from: owner})
        .then(product  => {
            assert.isTrue(product[1] == stock - 1, "Cannot add product as admin");
            return;
        });
        
 	});


   it("cannot buy more than stock",  async () => {
   	    await instance.addAdministrator(address1,{from: owner});
 		await instance.addProduct("sku-1",stock,skuPrice,{from: address1});
 	    return await instance.buyProduct("sku-1",stock + 1,{from: address2, value:skuPrice })
        .catch(result  => {
            assert.isTrue((result + '').indexOf('invalid opcode')  > -1, "Non Administrator can add");
            return;
        });
        
 	});

});
