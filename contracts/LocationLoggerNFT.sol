// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; 

contract LocationLoggerNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Log {
        uint256 timestamp;
        string location;
    }

    Log[] public logs;
    string public predefinedLocation;

    event LocationLogged(address indexed user, uint256 timestamp, string location);


    constructor(string memory _predefinedLocation) ERC721("LocationLoggerNFT", "LLNFT") {
        predefinedLocation = _predefinedLocation;


    }

    function logAndMintNFT(uint256 _timestamp, string memory _location) public {
        logs.push(Log(_timestamp, _location));

        if (keccak256(abi.encodePacked(_location)) == keccak256(abi.encodePacked(predefinedLocation))) {
            _mintNFT(msg.sender, _timestamp, _location);
        }
    }

    function _mintNFT(address recipient, uint256 _timestamp, string memory _location) private {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, _generateTokenURI(_timestamp, _location));
    }

    function _generateTokenURI(uint256 _timestamp, string memory _location) private pure returns (string memory) {
        return string(abi.encodePacked(
            "data:application/json;base64,", 
            base64(abi.encodePacked(
                '{"name": "Location Logger NFT",',
                '"description": "An NFT for logging locations.",',
                '"attributes": [',
                '{"trait_type": "Location", "value": "', _location, '"},',
                '{"trait_type": "Timestamp", "value": "', uint2str(_timestamp), '"}',
                ']}'
            ))
        ));
    }

    function base64(bytes memory data) private pure returns (string memory) {
        // Base64エンコードの実装
    }

    function uint2str(uint256 _i) private pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
