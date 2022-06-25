//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// import "hardhat/console.sol";

interface HotelRegistry {
    function getAddressFromName(string memory name) external returns (address);
}

interface NFTIssuer {

}

contract TravelEscrowFactory {
    HotelRegistry hotelRegistry;
    NFTIssuer nftIssuer;

    TravelEscrow lastTravelDeployed;

    constructor(address _hotelRegistryAddress, address _nftIssuerAddress) {
        hotelRegistry = HotelRegistry(_hotelRegistryAddress);
        nftIssuer = NFTIssuer(_nftIssuerAddress);
    }

    function setHotelRegistry(address _newHotelRegistryAddress) public {
        hotelRegistry = HotelRegistry(_newHotelRegistryAddress);
    }

    function setNFTIssuer(address _newNftIssuerAddress) public {
        nftIssuer = NFTIssuer(_newNftIssuerAddress);
    }

    function createTravel(address[] memory authorizedTravellers, string memory hotelSelected, uint timeForPayment, uint dateStart, uint dateEnd) public view returns (string memory) {
        lastTravelDeployed = new TravelEscrow(authorizedTravellers, hotelSelected, timeForPayment, dateStart, dateEnd, address(hotelRegistry), address(NFTIssuer));
    }
}


contract TravelEscrow {
    string hotelName;
    address hotelAddress;
    uint deadline;
    uint dateStart;
    uint dateEnd;

    address travelEscrowFactoryAddress;

    HotelRegistry hotelRegistry;
    NFTIssuer nftIssuer;

    constructor(address[] memory authorizedTravellers, string memory hotelSelected, uint timeForPayment, uint dateStart, uint dateEnd, address _hotelRegistryAddress, address _nftIssuerAddress){
        hotelRegistry = HotelRegistry(_hotelRegistryAddress);
        nftIssuer = NFTIssuer(_nftIssuerAddress);
        
        travelEscrowFactoryAddress = msg.sender;
        hotelName = hotelSelected;
        hotelAddress = hotelRegistry.getAddressFromName(hotelName);
    }

}
