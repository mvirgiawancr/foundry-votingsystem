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

    uint256 deployerKey;
    uint256 durationHours;
    string constant CANDIDATE_NAME = "Bob";
    address VOTER = makeAddr("Voter");

    function setUp() public {
        deployer = new DeployVotingSystem();
        (vsc, config) = deployer.run();
        (deployerKey, durationHours) = config.activeNetworkConfig();
    }

    modifier addCandidate(string memory _name) {
        vm.startPrank(msg.sender);
        vsc.addCandidate(_name);
        vm.stopPrank();
        _;
    }

    function testAddCandidate() public addCandidate(CANDIDATE_NAME) {
        (string memory _name,) = vsc.getCandidate(0);
        assertEq(_name, CANDIDATE_NAME);
        assert(0 == vsc.candidatesCount() - 1);
    }

    function testVote() public addCandidate(CANDIDATE_NAME) {
        (string memory _name, uint256 voteCount) = vsc.getCandidate(0);
        console.log("Vote count before voting: %s", voteCount);

        vm.startPrank(VOTER);
        vsc.vote(0);
        vm.stopPrank();

        (string memory _nameAfterVote, uint256 voteCountAfterVote) = vsc.getCandidate(0);
        console.log("Vote count after voting: %s", voteCountAfterVote);

        assertEq(vsc.hasVoted(VOTER), true);
        assertEq(voteCountAfterVote, voteCount + 1);
        assertEq(_nameAfterVote, _name);
    }

    function testCannotVoteTwice() public addCandidate(CANDIDATE_NAME) {
        vm.startPrank(VOTER);
        vsc.vote(0);
        vm.stopPrank();

        vm.expectRevert(VotingSystem.VotingSystem__AlreadyVoted.selector);
        vm.startPrank(VOTER);
        vsc.vote(0);
        vm.stopPrank();
    }

    function testCannotVoteInvalidCandidate() public addCandidate(CANDIDATE_NAME) {
        vm.startPrank(VOTER);
        vm.expectRevert(VotingSystem.VotingSystem__InvalidCandidateIndex.selector);
        vsc.vote(1);
        vm.stopPrank();
    }

    function testEndVotingWhenVotingHasEnded() public addCandidate(CANDIDATE_NAME) {
        vm.warp(block.timestamp + durationHours * 1 hours + 1);

        vm.startPrank(msg.sender);
        vsc.endVoting();
        vm.stopPrank();

        assertTrue(vsc.votingEnded());
    }

    function testCannotEndVotingWhenVotingIsOpen() public addCandidate(CANDIDATE_NAME) {
        vm.startPrank(msg.sender);
        vm.expectRevert(VotingSystem.VotingSystem__VotingStillOpen.selector);
        vsc.endVoting();
        vm.stopPrank();
    }

    function testGetResults() public addCandidate(CANDIDATE_NAME) {
        vm.startPrank(VOTER);
        vsc.vote(0);
        vm.stopPrank();

        vm.warp(block.timestamp + durationHours * 1 hours + 1);
        vm.startPrank(msg.sender);
        vsc.endVoting();
        vm.stopPrank();
        assertTrue(vsc.votingEnded());

        (string[] memory names, uint256[] memory voteCounts) = vsc.getResults();
        assertEq(names.length, 1);
        assertEq(voteCounts.length, 1);
        assertEq(names[0], CANDIDATE_NAME);
        assertEq(voteCounts[0], 1);
    }

    function testCannotGetResultsWhenVotingIsOpen() public addCandidate(CANDIDATE_NAME) {
        vm.expectRevert(VotingSystem.VotingSystem__VotingStillOpen.selector);
        vsc.getResults();
    }

    function testGetCandidate() public addCandidate(CANDIDATE_NAME) {
        (string memory name, uint256 voteCount) = vsc.getCandidate(0);
        assertEq(name, CANDIDATE_NAME);
        assertEq(voteCount, 0);
    }

    function testCannotGetCandidateWithInvalidIndex() public addCandidate(CANDIDATE_NAME) {
        vm.expectRevert(VotingSystem.VotingSystem__InvalidCandidateIndex.selector);
        vsc.getCandidate(1);
    }

    function testCannotVoteWhenVotingClosed() public addCandidate(CANDIDATE_NAME) {
        vm.warp(block.timestamp + durationHours * 1 hours + 1);
        vm.startPrank(VOTER);
        vm.expectRevert(VotingSystem.VotingSystem__VotingClosed.selector);
        vsc.vote(0);
        vm.stopPrank();
    }
}
