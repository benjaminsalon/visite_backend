//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// import "hardhat/console.sol";

contract HotelRegistry{

    string hotelName;
    mapping(string => address) hotelRegistry;
    mapping(string => bool) isNameExisting;

    function getAddressByName() public view returns(address){
        require(isNameExisting[hotelName], "There is not this hotel in this registry");
        return hotelRegistry[hotelName];
    }

    function addHotelRegistry(address hotelAddress) public {
        hotelRegistry[hotelName] = hotelAddress;
        isNameExisting[hotelName] = true;
    }
}