//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// import "hardhat/console.sol";
import "./interfaces/Interfaces.sol";

contract TravelEscrowFactory {
    address public hotelRegistryAddress;
    address public nftIssuerAddress;

    address public lastTravelDeployedAddress;

    event TravelEscrowCreated(address travelEscrow);

    constructor(address _hotelRegistryAddress, address _nftIssuerAddress) {
        hotelRegistryAddress = _hotelRegistryAddress;
        nftIssuerAddress = _nftIssuerAddress;
    }

    function setIHotelRegistry(address _newIHotelRegistryAddress) public {
        hotelRegistryAddress = _newIHotelRegistryAddress;
    }

    function setINFTIssuer(address _newNftIssuerAddress) public {
        nftIssuerAddress = _newNftIssuerAddress;
    }

    function createTravel(address[] memory authorizedTravellers, string memory hotelSelected, uint timeForPayment, uint dateStart, uint numberOfNights, uint price) public returns(address) {
        lastTravelDeployedAddress = address(new TravelEscrow(authorizedTravellers, hotelSelected, timeForPayment, dateStart, numberOfNights, hotelRegistryAddress, nftIssuerAddress, price));
        emit TravelEscrowCreated(address(lastTravelDeployedAddress));
        return address(lastTravelDeployedAddress);
    }

    function getLastTravelDeployedAddress() public view returns(address){
        return lastTravelDeployedAddress;
    }
}



contract TravelEscrow {
    string public hotelName;
    address public hotelAddress;
    uint public deadline;
    uint public dateStart;
    uint public numberOfNights;
    uint public price;
    uint public numberOfPaidTravellers;
    uint public numberOfTravellers;
    address[] public authorizedTravellers;
    mapping(address => bool) hasPaid;
    bool public hasEveryonePaid;
    uint public pricePerTraveller;
    address public travelEscrowFactoryAddress;

    IHotelRegistry hotelRegistry;
    INFTIssuer nftIssuer;

    event SharePaid(address traveller);


    modifier everyonePaid(){
        require(!hasEveryonePaid, "Everyone has already paid");
        _;
    }

    modifier travellerAuthorized(address travellerAddress){
        require(isTravellerAuthorized(travellerAddress), "Traveller is not authorized");
        _;
    }

    modifier travellerPaid(address traveller){
        require(!hasTravellerPaid(traveller), "Traveller has already paid");
        _;
    }

    modifier priceModifier(){
        require(msg.value == pricePerTraveller, "Traveller must pay the right amount");
        _;
    }

    constructor(address[] memory _authorizedTravellers, string memory _hotelSelected, uint _timeForPayment, uint _dateStart, uint _numberOfNights, address _hotelRegistryAddress, address _nftIssuerAddress, uint _price){
        hotelRegistry = IHotelRegistry(_hotelRegistryAddress);
        nftIssuer = INFTIssuer(_nftIssuerAddress);
        deadline = block.timestamp + _timeForPayment;
        travelEscrowFactoryAddress = msg.sender;
        hotelName = _hotelSelected;
        hotelAddress = hotelRegistry.getAddressFromName(hotelName);
        price = IHotel(hotelAddress).pricePerNight()*_numberOfNights;
        pricePerTraveller = price /2;
        authorizedTravellers = _authorizedTravellers;
        hasEveryonePaid = false;
        numberOfNights = _numberOfNights;
        dateStart = _dateStart;
        numberOfTravellers = _authorizedTravellers.length;
    }

    function payShare() public payable everyonePaid travellerAuthorized(msg.sender) travellerPaid(msg.sender) priceModifier returns(bool){

        hasPaid[msg.sender] = true;
        numberOfPaidTravellers += 1;
        emit SharePaid(msg.sender);

        if (numberOfPaidTravellers == numberOfTravellers){
            hasEveryonePaid = true;
            sendPaymentToHotel();
            return true;
        }
        else {
            return false;
        }
    }

    function withdrawShare() public {
        require(!hasEveryonePaid, "Payment already made to Hotel");
        require(block.timestamp > deadline, "Too early to withdraw");
        require(isTravellerAuthorized(msg.sender), "Traveller must be authorized");
        require(hasPaid[msg.sender], "User has not paid yet");
        hasPaid[msg.sender] = false;
        numberOfPaidTravellers -= 1;
        payable(msg.sender).transfer(pricePerTraveller);
    }

    function sendPaymentToHotel() public {
        IHotel(hotelAddress).bookTrip{value: price}(dateStart, numberOfNights, numberOfTravellers);
    }



    //Utilities
    function isTravellerAuthorized(address addressOfTraveller) public view returns (bool){
        bool result = false;
        for (uint i = 0; i < authorizedTravellers.length; i++){
            if (authorizedTravellers[i] == addressOfTraveller){
                result = true;
            }
        }
        return result;
    }

    function hasTravellerPaid(address addressOfTraveller) public view returns(bool){
        return hasPaid[addressOfTraveller];
    }

    function getHotelName() public view returns (string memory){
        return hotelName;
    }

    function getDateStart() public view returns(uint){
        return dateStart;
    }

    function getNumberOfNights() public view returns(uint){
        return numberOfNights;
    }

    function getDates() public view returns (uint, uint){
        return (dateStart, numberOfNights);
    }

    function getPrice() public view returns (uint){
        return price;
    }

    function getPricePerTraveller() public view returns (uint){
        return pricePerTraveller;
    }

    function getAuthorizedTravellers() public view returns (address[] memory) {
        return authorizedTravellers;
    }

}

