//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IHotelRegistry {
    function getAddressFromName(string memory name) external returns (address);
    function addHotelToRegistry(address hotelAddress) external;
    function isRegistered(address hotelAddress) external returns (bool);
    function setNftIssuer(address newAddress) external;
    function nftIssuer() external returns(address);
}

interface INFTIssuer {
    function mintBookingNFT(address travelEscrowAddress) external;
}

interface IHotel {
    function bookTrip(uint dateStart, uint numberOfNights, uint numberOfTravellers) payable external;
    function name() external returns(string memory);
    function pricePerNight() external returns(uint);
}

interface ITravelEscrow {
    function payShare() external returns(bool);
    function withDrawShare() external;

    function hasEveryTravellerPaid() external returns (bool );
    function isTravellerAuthorized(address traveller) external returns(bool );
    function hasTravellerPaid(address traveller) external returns(bool );

    function getHotelName() external returns (string memory hotelName);
    function getDateStart() external returns(uint dateStart);
    function getNumberOfNights() external returns(uint numberOfNights);
    function getDates() external returns (uint dateStart, uint numberOfNights);
    function getPrice() external returns (uint travelPrice);
    function getPricePerTraveller() external returns (uint );
    function getAuthorizedTravellers() external returns (address[] memory);

    function authorizedTravellers() external returns (address[] memory);


}