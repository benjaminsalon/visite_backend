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

    constructor(address _turingHelperAddress, string memory url) {
        turingHelperAddress = _turingHelperAddress;
        turing = TuringHelper(_turingHelperAddress);
        turingUrl = url;
    }

    

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
        string memory turingURLCopy = turingUrl;
        string memory processBooking = "/processBooking?pay_now=1";
        string memory hotelId = "?hotel_id=";
        // string memory turingURLProcessBooking = string.concat(turingURLCopy,"/processBooking?pay_now=1");
        // string memory hotelIdDestination = string.concat("?hotel_id=", _destination);
        // string memory turingURL = string.concat(turingURLProcessBooking,hotelIdDestination);
        //string memory turingURL = string.concat("https://secure-distribution-xml.booking.com/2.6/json/processBooking?pay_now=1",string.concat("?hotel_id=", _destination));
        string memory turingURL = string(abi.encodePacked(turingURLCopy,processBooking,hotelId,_destination));
        bytes memory encRequest = abi.encodePacked(turingURL);//Not turingUrl but what we want to send
        bytes memory encResponse = turing.TuringTx(turingURL, encRequest);
        string memory result = abi.decode(encResponse,(string)); 
        if(keccak256(abi.encodePacked(result)) == keccak256(abi.encodePacked("error"))){ 
            revert("Payment failed");
        }
       
        return true;
    }

    function uintToString(uint256 _i) public pure returns (string memory){
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = _i;
        while (j != 0){
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        return string(bstr);
    }

    function finalPOSTForBooking(string memory _city, string memory _hotelName, uint _startDay, uint _numberOfNights, uint _id, uint _price) public returns(bool){    
        string memory data = string(abi.encodePacked('{"city"  : "',_city, '", "hotelName" : "' ,_hotelName,'", "startDay" : "',uintToString(_startDay),
                             '", "numberOfNights" : "',
                             uintToString(_numberOfNights),
                             '", "id" : "',
                             uintToString(_id),
                             '", "price" : "',
                             uintToString(_price), '"}'));
        bytes memory encRequest = abi.encodePacked(data);
        bytes memory encResponse = turing.TuringTx(turingUrl, encRequest);
        string memory result = abi.decode(encResponse,(string)); 
        if(keccak256(abi.encodePacked(result)) == keccak256(abi.encodePacked("error"))){ 
            revert("Payment failed");
        }
       
        return true;
    }
}