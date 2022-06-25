//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IHotelRegistry {
    function getAddressFromName(string memory name) external returns (address);
}

interface INFTIssuer {

}

interface IHotel {
    function bookTrip(uint dateStart, uint numberOfNights, uint numberOfTravellers) payable external;
}