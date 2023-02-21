// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract RANDOM is VRFConsumerBaseV2 {

uint64 subscriptionId;
address vrfCoordinatorAddress = 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;
bytes32 keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
uint32 callbackGasLimit = 100000;
uint16 requestConfirmations = 3;
uint32 numWords =  1;
VRFCoordinatorV2Interface COORDINATOR;
uint256[] public requestIds;
struct RequestStatus {
        bool fulfilled; 
        bool exists; 
        uint256[] randomWords;
    }
 event RequestSent(uint256 requestId, uint32 numWords);
 event RequestFulfilled(uint256 requestId, uint256[] randomWords);
 address owner;
 mapping(uint => RequestStatus) requests;
 uint public lastRequestId;
 constructor(uint64 _subscriptionId) VRFConsumerBaseV2(0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D){
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinatorAddress);
        subscriptionId = _subscriptionId;
        owner = msg.sender;
    }
modifier onlyOwner {
    require(msg.sender == owner, "you are not authorized");
    _;
}

function requestRandomWords() external onlyOwner returns (uint256 requestId) {
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        requests[requestId] = RequestStatus({
            randomWords: new uint256[](0),
            exists: true,
            fulfilled: false
        });

        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;
    }

function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords) internal override{
    require(requests[_requestId].exists, "request not found");
        requests[_requestId].fulfilled = true;
        requests[_requestId].randomWords = _randomWords;
        emit RequestFulfilled(_requestId, _randomWords);
}


function getRequestStatus(uint256 _requestId) external view returns (bool fulfilled, uint256[] memory randomWords) {
        require(requests[_requestId].exists, "request not found");
        RequestStatus memory request = requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }

}