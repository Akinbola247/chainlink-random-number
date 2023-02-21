// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IrandomNumber {
    function requestRandomWords() external returns (uint256 requestId);
}