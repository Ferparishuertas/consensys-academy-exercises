var StockDatabase = artifacts.require("./StockDatabase.sol");

module.exports = function(deployer) {
  deployer.deploy(StockDatabase);
};
