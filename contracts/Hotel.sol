//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./interfaces/Interfaces.sol";

// import "hardhat/console.sol";

contract HotelRegistry{

    mapping(string => address) hotelRegistry;
    mapping(string => bool) isNameExisting;
    address nftIssuer;

    constructor() {
    }

    function setNftIssuer(address newAddress) public {
        nftIssuer = newAddress;
    }

    function getAddressByName(string memory hotelName) public view returns(address){
        require(isNameExisting[hotelName], "There is not this hotel in this registry");
        return hotelRegistry[hotelName];
    }

    function addHotelRegistry(string memory hotelName, address hotelAddress) public {
        hotelRegistry[hotelName] = hotelAddress;
        isNameExisting[hotelName] = true;
    }
}

contract Hotel{

    string name;
    uint pricePerNight;
    address hotelRegistry;

    constructor(string memory _name, uint _pricePerNight, address hotelRegistryAddress) {
        name = _name;
        pricePerNight = _pricePerNight;
        hotelRegistry = hotelRegistryAddress;
    }

    modifier rightPrice(uint _price){
        require(_price == msg.value, "The amount of money sent is not correct");
        _;
    }

    function bookTrip(uint datestart, uint numberOfNights, uint numberOfTraveller, INFTIssuer nftIssuer) payable external rightPrice(pricePerNight*numberOfNights){
        address travelEscrowAddress = msg.sender;

        INFTIssuer(IHotelRegistry(hotelRegistry).nftIssuer()).mintBookingNFT(travelEscrowAddress);
    }

    
}