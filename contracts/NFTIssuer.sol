//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./interfaces/Interfaces.sol";

contract NFTIssuer is ERC721URIStorage {

    address hotelRegistryAddress;
    constructor(address _hotelRegistryAddress) ERC721URIStorage("VISITE_NFT", "VNFT") {
        hotelRegistryAddress = _hotelRegistryAddress;
    }

    modifier onlyValidHotel(address hotelAddress){
        require(IHotelRegistry(hotelRegistryAddress).isRegistered(hotelAddress),"Hotel not in registry");
    }

    function setHotelRegistry(address hotelRegistryAddressNew) public {
        hotelRegistryAddress = hotelRegistryAddressNew;
    }

    


}