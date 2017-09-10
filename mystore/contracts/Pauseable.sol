pragma solidity ^0.4.6;

import "./Owned.sol";

contract Pauseable is Owned {

		event LogContractPaused();
		event LogContractResumed();

    bool public isPaused;

    function pause() public onlyOwner {
        isPaused = true;
		LogContractPaused();
    }

    function resume() public onlyOwner {
        isPaused = false;
		LogContractResumed();
    }

    modifier isNotPaused {
        require(!isPaused);
        _;
    }
}
