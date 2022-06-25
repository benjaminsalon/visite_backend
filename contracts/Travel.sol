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

    function createTravel(address[] memory authorizedTravellers, string memory hotelSelected, uint timeForPayment, uint dateStart, uint numberOfNights, uint price) public returns (string memory) {
        lastTravelDeployed = new TravelEscrow(authorizedTravellers, hotelSelected, timeForPayment, dateStart, numberOfNights, address(hotelRegistry), address(nftIssuer), price);
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
    uint price;
    uint numberOfPaidTravellers;
    uint numberOfTravellers;
    address[] authorizedTravellers;
    mapping(address => bool) hasPaid;
    bool hasEveryonePaid;
    uint pricePerTraveller;
    address travelEscrowFactoryAddress;

    IHotelRegistry hotelRegistry;
    INFTIssuer nftIssuer;



    modifier everyonePaid(){
        require(!hasEveryonePaid, "Everyone has already paid");
        _;
    }

    modifier travellerAuthorized(){
        require(isTravellerAuthorized(msg.sender, authorizedTravellers ), "Traveller is not authorized");
        _;
    }

    modifier travellerPaid(){
        require(hasTravellerPaid(msg.sender), "Traveller has already paid");
        _;
    }

    modifier priceModifier(){
        require(msg.value = pricePerTraveller, "Traveller must pay the right amount");
        _;
    }

    constructor(address[] memory _authorizedTravellers, string memory hotelSelected, uint timeForPayment, uint dateStart, uint numberOfNights, address _hotelRegistryAddress, address _nftIssuerAddress, uint _price){
        hotelRegistry = IHotelRegistry(_hotelRegistryAddress);
        nftIssuer = INFTIssuer(_nftIssuerAddress);
        deadline = block.timestamp + timeForPayment;
        travelEscrowFactoryAddress = msg.sender;
        hotelName = hotelSelected;
        hotelAddress = hotelRegistry.getAddressFromName(hotelName);
        price = _price;
        authorizedTravellers = _authorizedTravellers;
        hasEveryonePaid = false;
    }

    function payShare() public payable everyonePaid travellerAuthorized travellerPaid priceModifier returns(bool hasEveryonePaid){

        hasPaid[msg.sender] = true;
        numberOfPaidTravellers += 1;

        if (numberOfPaidTravellers == numberOfTravellers){
            hasEveryonePaid = true;
            sendPaymentToHotel();
            return true;
        }
        else {
            return false;
        }
    }

    function isTravellerAuthorized(address addressOfTraveller, address[] memory authorizedTravellers) public returns (bool){
        bool result = false;
        for (uint i = 0; i < authorizedTravellers.length; i++){
            if (authorizedTravellers[i] == addressOfTraveller){
                result = true;
            }
        }
        return result;
    }

    function hasTravellerPaid(address addressOfTraveller) public returns(bool){
        return hasPaid[addressOfTraveller];
    }

    function getHotelName() public returns (string memory hotelName){
        return hotelName;
    }

    function getDateStart() public returns(uint dateStart){
        return dateStart;
    }

    function getNumberOfNights() public returns(uint numberOfNights){
        return numberOfNights;
    }

    function getDates() public returns (uint dateStart, uint numberOfNights){
        return (dateStart, numberOfNights);
    }

    function getPrice() public returns (uint travelPrice){
        return price;
    }

    function getPricePerTraveller() public returns (uint travelPricePerTraveller){
        return pricePerTraveller;
    }

    



}
