// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {VotingSystem} from "../src/VotingSystem.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployVotingSystem} from "../script/DeployVotingSystem.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract VotingSystemTest is Test {
    VotingSystem public vsc;
    HelperConfig public config;
    DeployVotingSystem public deployer;

    string name;
    uint256 deployerKey;
    uint256 durationHours;

    function setUp() public {
        deployer = new DeployVotingSystem();
        (vsc, config) = deployer.run();
        (deployerKey, durationHours) = config.activeNetworkConfig();
    }

    function testAddCandidate() public {
        string memory candidateName = "Bob";
        uint256 candidateIndex = vsc.candidatesCount();

        vm.startPrank(msg.sender);
        vsc.addCandidate(candidateName, candidateIndex);
        vm.stopPrank();

        (string memory _name,) = vsc.getCandidate(candidateIndex);
        assertEq(_name, candidateName);
        assert(candidateIndex == vsc.candidatesCount() - 1);
    }
}
