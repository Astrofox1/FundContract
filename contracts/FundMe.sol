// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

/**@title A sample Funding Contract
 * @author Patrick Collins
 * @notice This contract is for creating a sample funding contract
 * @dev This implements price feeds as our library
 */

contract FundMe {
    using PriceConverter for uint256;
    uint256 minUsd = 50 * 1e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public owner;

    AggregatorV3Interface public priceFeed;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner!");
        _;
    }

    constructor(address priceFeedAddress) {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function Fund() public payable {
        //want to be able to set a minimum fund amount in USD
        //1- How de we send ETH to this contract?

        require(
            msg.value.getConversionRate(priceFeed) >= minUsd,
            "You didn't send enough!"
        ); // 1e18 = 1 * 10 ** 18 = 100000000000000000

        // 2- What is reverting?
        // Undo any action before, and send remaining gas back

        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 idx = 0; idx < funders.length; idx++) {
            address funder = funders[idx];
            addressToAmountFunded[funder] = 0;
        }
        // Reseting the array
        funders = new address[](0);
        // Withdraw
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed!");
    }
}
