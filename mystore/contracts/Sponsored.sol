pragma solidity ^0.4.6;
contract Sponsored {

    event SponsorChanged(address oldSponsor, address newSponsor);

    address public sponsor;

    modifier onlySponsor() {
        require(msg.sender == sponsor);
        _;
    }

    function Sponsored(address _sponsor) {
        sponsor = _sponsor;
    }

		function changeSponsor(address _sponsor) onlySponsor {
    		require(_sponsor != address(0x0));
            require(_sponsor != sponsor);

            address oldSponsor = sponsor;
            sponsor = _sponsor;
            SponsorChanged(oldSponsor, sponsor);
		}

}
