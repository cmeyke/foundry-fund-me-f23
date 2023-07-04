// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(
        address mostRecentlyDeployed,
        address who,
        uint256 value
    ) public {
        if (who == address(0)) {
            vm.startBroadcast();
        } else {
            vm.startBroadcast(who);
        }
        FundMe(payable(mostRecentlyDeployed)).fund{value: value}();
        vm.stopBroadcast();
        console.log("Funded %s with %s", mostRecentlyDeployed, value);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        console.log("Most recently deployed FundMe: %s", mostRecentlyDeployed);
        fundFundMe(mostRecentlyDeployed, address(0), SEND_VALUE);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Withdraw FundMe balance!");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdrawFundMe(mostRecentlyDeployed);
    }
}
