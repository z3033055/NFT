// contracts/LocationContract.sol
pragma solidity ^0.8.4;

contract LocationContract {
    struct LocationLog {
        uint256 timestamp;
        string location;
    }

    LocationLog[] public logs;

    function logLocation(uint256 _timestamp, string memory _location) public {
        logs.push(LocationLog(_timestamp, _location));
    }

    function getLog(uint256 index) public view returns (uint256, string memory) {
        require(index < logs.length, "Index out of bounds");
        LocationLog storage log = logs[index];
        return (log.timestamp, log.location);
    }
}
