//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// import "hardhat/console.sol";
import "./interfaces/Interfaces.sol";
import './TuringHelper.sol';

contract ConnecteAPI{ 

    /* The initial idea was to connect to booking API. We asked for API but Booking team rejected the demand. 
    I think that they are affraid by the being disrupted by the web3. However, we are going to disrupt them anyway...*/

    string destination;
    string hotel;
    mapping(string => uint) numberOfHotelsPerDestination;
    mapping(string => uint) priceOfHotel;
    TuringHelper public turing;
    address public turingHelperAddress;
    string public turingUrl;

    constructor(address _turingHelperAddress, string memory _turingUrl) {
        turingHelperAddress = _turingHelperAddress;
        turing = TuringHelper(_turingHelperAddress);
        turingUrl = _turingUrl;
    }

    string urlStr = 'http://localhost:3004/';

    function numberOfHotelPerDestination(string memory _destination) public view returns(uint) {
        return numberOfHotelsPerDestination[_destination];
    }

    function pricePerHotel(string memory _hotel) public view returns(uint){
        return priceOfHotel[_hotel];
    }

    /*function retrieveInformationPerDestination(string memory destination) public returns (mapping(string => uint) priceOfHotel){
        uint counter = 1;

        string turingUrl = turingUrl + "hotel/" + uint2str(counter);
        bytes memory encRequest = abi.encodePacked(_uuid, hashedKey);

        // Decode the response from outside API
        bytes memory encResponse = turing.TuringTx(turingUrl, encRequest);
        string result = abi.decode(encResponse,(string));
        require(result != "{}", "No hotel for this destination");

        while (result != "{}"){
            
        }
    }*/

    function sendPOSTForBooking(string memory _destination) public returns(bool){
        // the local database is not able to handle a POST for booking process, we inspire themselve from the real booking process of booking
        string memory turingURL = string.concat(string.concat(turingUrl,"/processBooking?pay_now=1",string.concat("?hotel_id=", _destination)));
        //string memory turingURL = string.concat("https://secure-distribution-xml.booking.com/2.6/json/processBooking?pay_now=1",string.concat("?hotel_id=", _destination));

        bytes memory encRequest = abi.encodePacked(turingURL);
        bytes memory encResponse = turing.TuringTx(turingURL, encRequest);
        string memory result = abi.decode(encResponse,(string)); 
        if(keccak256(abi.encodePacked(result)) == keccak256(abi.encodePacked("error"))){ 
            revert("Payment failed");
        }
        return true;
    }
}