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
        IHotelRegistry(hotelRegistryAddress).setNftIssuer(address(this));
    }

    modifier onlyValidHotel(address hotelAddress){
        require(IHotelRegistry(hotelRegistryAddress).isRegistered(hotelAddress),"Hotel not in registry");
        _;
    }

    function setHotelRegistry(address hotelRegistryAddressNew) public {
        hotelRegistryAddress = hotelRegistryAddressNew;
    }

    function mintBookingNFT(address travelEscrowAddress) public onlyValidHotel(msg.sender) {
        address[] memory travellersAdresses = ITravelEscrow(travelEscrowAddress).getAuthorizedTravellers();
        uint dateStart = ITravelEscrow(travelEscrowAddress).getDateStart();
        uint numberOfNights = ITravelEscrow(travelEscrowAddress).getNumberOfNights();
        string memory hotelName = ITravelEscrow(travelEscrowAddress).getHotelName();
        address hotelAddress = msg.sender;
        for(uint i = 0; i<travellersAdresses.length;i++){
            address travellerAddress = travellersAdresses[i];
            BookingInfo memory bookingInfoForTraveller;
            bookingInfoForTraveller.dateStart = dateStart;
            bookingInfoForTraveller.numberOfNights = numberOfNights;
            bookingInfoForTraveller.hotelAddress = hotelAddress;
            bookingInfoForTraveller.hotelName = hotelName;
            uint tokenId = uint(keccak256(abi.encodePacked(hotelName,hotelAddress,dateStart,numberOfNights,travellerAddress)));
            _mint(travellerAddress, tokenId);
        }
    }



}