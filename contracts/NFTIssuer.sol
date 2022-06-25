//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./interfaces/Interfaces.sol";

contract NFTIssuer is ERC721URIStorage {

    struct BookingInfo {
        string hotelName;
        address hotelAddress;
        uint dateStart;
        uint numberOfNights;
    }

    address hotelRegistryAddress;
    mapping(uint256 => BookingInfo) metadata;


    constructor(address _hotelRegistryAddress) ERC721("VISITE_NFT", "VNFT") {
        hotelRegistryAddress = _hotelRegistryAddress;
    }

    modifier onlyValidHotel(address hotelAddress){
        require(IHotelRegistry(hotelRegistryAddress).isRegistered(hotelAddress),"Hotel not in registry");
    }

    function setHotelRegistry(address hotelRegistryAddressNew) public {
        hotelRegistryAddress = hotelRegistryAddressNew;
    }

    function mintBookingNFT(uint tokenId, address travelEscrowAddress) {

    }



}