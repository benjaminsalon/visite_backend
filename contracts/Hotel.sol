//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./interfaces/Interfaces.sol";

// import "hardhat/console.sol";

contract HotelRegistry{

    mapping(string => address) hotelRegistry;
    mapping(string => bool) isNameExisting;
    mapping(address => bool) registeredHotelAddress;
    address public nftIssuer;

    constructor() {
    }

    function setNftIssuer(address newAddress) public {
        nftIssuer = newAddress;
    }

    function getAddressFromName(string memory hotelName) public view returns(address){
        require(isNameExisting[hotelName], "There is not this hotel in this registry");
        return hotelRegistry[hotelName];
    }

    function addHotelToRegistry(address hotelAddress) public {
        string memory hotelName = IHotel(hotelAddress).name();
        hotelRegistry[hotelName] = hotelAddress;
        isNameExisting[hotelName] = true;
        registeredHotelAddress[hotelAddress] = true;
    }

    function isRegistered(address hotelAddress) public view returns(bool) {
        return registeredHotelAddress[hotelAddress];
    }
}

contract Hotel{

    string public name;
    uint public pricePerNight;
    address public hotelRegistry;

    constructor(string memory _name, uint _pricePerNight, address hotelRegistryAddress) {
        name = _name;
        pricePerNight = _pricePerNight;
        hotelRegistry = hotelRegistryAddress;
    }

    modifier rightPrice(uint _price){
        require(_price == msg.value, "The amount of money sent is not correct");
        _;
    }

    function bookTrip(uint datestart, uint numberOfNights, uint numberOfTraveller) payable public rightPrice(pricePerNight*numberOfNights){
        address travelEscrowAddress = msg.sender;

        INFTIssuer(IHotelRegistry(hotelRegistry).nftIssuer()).mintBookingNFT(travelEscrowAddress);
    }

    
}