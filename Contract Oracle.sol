// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Oracle {
    address public owner;
    mapping(bytes32 => uint256) public data;

    event DataRequest(bytes32 requestId, string dataSource, string query);
    event DataResponse(bytes32 requestId, uint256 result);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function requestData(string memory dataSource, string memory query) external returns (bytes32) {
        bytes32 requestId = keccak256(abi.encodePacked(block.timestamp, msg.sender, dataSource, query));
        emit DataRequest(requestId, dataSource, query);
        return requestId;
    }

    function respondToRequest(bytes32 requestId, uint256 result) external onlyOwner {
        data[requestId] = result;
        emit DataResponse(requestId, result);
    }

    function getData(bytes32 requestId) external view returns (uint256) {
        return data[requestId];
    }
}
