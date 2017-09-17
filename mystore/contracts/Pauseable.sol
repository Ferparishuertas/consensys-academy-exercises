pragma solidity ^0.4.6;

import "./Owned.sol";

contract Pauseable is Owned {

		event ContractPaused();
		event ContractResumed();

    bool public isPaused;

    function pause() public onlyOwner returns (bool)  {
        isPaused = true;
		ContractPaused();
        return true;
    }

    function resume() public onlyOwner returns (bool) {
        isPaused = false;
		ContractResumed();
        return true;
    }

    modifier isNotPaused {
        require(!isPaused);
        _;
    }
}
