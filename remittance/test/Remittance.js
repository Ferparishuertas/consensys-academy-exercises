var Remittance = artifacts.require("./Remittance.sol");

contract('Remittance', function(accounts) {

	var instance;	
	var address1 = accounts[0];
	var address2 = accounts[1];
	var address3 = accounts[2];
        var amountToPay =  1000;

	beforeEach(function() {
		return Remittance.new({from:address1}).then(thisInstance => {
          instance = thisInstance;
        });

	});

        it("After opening the challenge,  balance must be 1000", () => {
 
	       return instance.openChallenge(address3,"pp@ppx.com","",10,{from:address1,amount:amountToPay})
	        .then(result  => {
	            assert.isTrue(result, "Challenge not opened");
                    return instance.showBalance()
               })
                .then(result => {
                    assert.isTrue(result == 1000, "Balance is not 1000");
                    return;
                });
       
	 });
       
});
