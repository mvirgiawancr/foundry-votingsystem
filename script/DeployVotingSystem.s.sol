// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {VotingSystem} from "../src/VotingSystem.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployVotingSystem is Script {
    VotingSystem public vsc;
    HelperConfig public config;

    function run() external returns (VotingSystem, HelperConfig) {
        config = new HelperConfig();
        (, uint256 durationHours) = config.activeNetworkConfig();

        vm.startBroadcast();
        vsc = new VotingSystem(durationHours);
        vm.stopBroadcast();
        return (vsc, config);
    }
}
