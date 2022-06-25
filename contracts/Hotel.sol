//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./interfaces/Interfaces.sol";

// import "hardhat/console.sol";

contract HotelRegistry{

    mapping(string => address) hotelRegistry;
    mapping(string => bool) isNameExisting;

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

    mapping(uint => uint) priceForJourney;


    modifier rightPrice(uint price){
        require(price == msg.value, "The amount of money sent is not the correct");
        _;
    }

    function bookTrip(uint datestart, uint numberOfNights, uint numberOfTraveller, INFTIssuer nftIssuer) payable external rightPrice(priceForJourney[numberOfNights]){
        mint(msg.sender, datestart, numberOdNights);
    }

    function minter()

    
}