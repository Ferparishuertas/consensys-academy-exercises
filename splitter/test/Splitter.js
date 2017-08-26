var Splitter = artifacts.require("./Splitter.sol");

contract('Splitter', function(accounts) {

	var instance;	
	var address1 = accounts[0];
	var address2 = accounts[1];
	var address3 = accounts[2];
        var amountToPay =  1000;

	beforeEach(function() {
		return Splitter.new(address1,address2,address3, {from:address1}).then(thisInstance => {
          instance = thisInstance;
        });

	});

        it("At the beginning balance must be 0", () => {
 
	       return instance.showBalance()
	        .then(result  => {
	            assert.isTrue(result == 0, "Balance is not 0");
	            return; 
                });
	 });
       
       it("There must be Balance if paid by a none owner", done => {

	         return instance.pay({from: address2,amount:amountToPay})
	        .then(success => {
	            assert.isTrue(success, "Payment failed")
	            return instance.showBalance()
	       }) 
	        .then(result => {
	            assert.isTrue(result == 1000, "Balance is not 1000");
	            return; 
                });
	 });
});
