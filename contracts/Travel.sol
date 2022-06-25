//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// import "hardhat/console.sol";

interface IHotelRegistry {
    function getAddressFromName(string memory name) external returns (address);
}

interface INFTIssuer {

}

contract TravelEscrowFactory {
    IHotelRegistry hotelRegistry;
    INFTIssuer nftIssuer;

    TravelEscrow lastTravelDeployed;

    constructor(address _hotelRegistryAddress, address _nftIssuerAddress) {
        hotelRegistry = IHotelRegistry(_hotelRegistryAddress);
        nftIssuer = INFTIssuer(_nftIssuerAddress);
    }

    function setIHotelRegistry(address _newIHotelRegistryAddress) public {
        hotelRegistry = IHotelRegistry(_newIHotelRegistryAddress);
    }

    function setINFTIssuer(address _newNftIssuerAddress) public {
        nftIssuer = INFTIssuer(_newNftIssuerAddress);
    }

    function createTravel(address[] memory authorizedTravellers, string memory hotelSelected, uint timeForPayment, uint dateStart, uint numberOfNights) public returns (string memory) {
        lastTravelDeployed = new TravelEscrow(authorizedTravellers, hotelSelected, timeForPayment, dateStart, numberOfNights, address(hotelRegistry), address(nftIssuer));
    }
}

interface ITravelEscrow {
    function payShare() external returns(bool hasEveryTravellerPaid);
    function withDrawShare() external returns(bool success);

    function hasEveryTravellerPaid() external returns (bool hasEveryTravellerPaid);
    function isTravellerAuthorized(address traveller) external returns(bool isTravellerAuthorized);
    function hasTravellerPaid(address traveller) external returns(bool hasTravellerPaid);

    function getHotelName() external returns (string memory hotelName);
    function getDateStart() external returns(uint dateStart);
    function getNumberOfNights() external returns(uint numberOfNights);
    function getDates() external returns (uint dateStart, uint numberOfNights);
    function getPrice() external returns (uint travelPrice);
    function getPricePerTraveller() external returns (uint travelPricePerTraveller);


}

contract TravelEscrow {
    string hotelName;
    address hotelAddress;
    uint deadline;
    uint dateStart;
    uint numberOfNights;

    address travelEscrowFactoryAddress;

    IHotelRegistry hotelRegistry;
    INFTIssuer nftIssuer;

    constructor(address[] memory authorizedTravellers, string memory hotelSelected, uint timeForPayment, uint dateStart, uint numberOfNights, address _hotelRegistryAddress, address _nftIssuerAddress){
        hotelRegistry = IHotelRegistry(_hotelRegistryAddress);
        nftIssuer = INFTIssuer(_nftIssuerAddress);
        deadline = block.timestamp + timeForPayment;
        travelEscrowFactoryAddress = msg.sender;
        hotelName = hotelSelected;
        hotelAddress = hotelRegistry.getAddressFromName(hotelName);
    }



}
