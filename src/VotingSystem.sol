// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title VotingSystem
 * @author mvirgiawancr
 * @notice This contract implements a simple voting system where users can vote for candidates.
 * @dev The contract allows adding candidates and voting for them. Each address can vote only once.
 */
contract VotingSystem is Ownable {
    error VotingSystem__AlreadyVoted();
    error VotingSystem__InvalidCandidateIndex();
    error VotingSystem__VotingClosed();
    error VotingSystem__VotingStillOpen();

    struct Candidate {
        string name;
        uint256 voteCount;
    }

    Candidate[] public candidates;
    uint256 public candidatesCount = 0;
    mapping(address => bool) public hasVoted;
    uint256 public endTime;
    bool public votingEnded = false;
    uint256 private candidateIndex = 0;

    constructor(uint256 _durationHours) Ownable(msg.sender) {
        endTime = block.timestamp + _durationHours * 1 hours;
        candidateIndex++;
    }

    modifier hasNotVoted() {
        if (hasVoted[msg.sender]) {
            revert VotingSystem__VotingClosed();
        }
        _;
    }

    modifier votingOpen() {
        if (block.timestamp >= endTime) {
            revert VotingSystem__VotingClosed();
        }
        _;
    }

    modifier votingClosed() {
        if (!votingEnded) {
            revert VotingSystem__VotingStillOpen();
        }
        _;
    }

    function addCandidate(string memory _name, uint256 _candidateIndex) public onlyOwner {
        candidates.push(Candidate(_name, _candidateIndex));
        candidatesCount++;
    }

    function vote(uint256 _candidateIndex) external hasNotVoted votingOpen {
        if (_candidateIndex >= candidatesCount) {
            revert VotingSystem__InvalidCandidateIndex();
        }
        candidates[_candidateIndex].voteCount++;
        hasVoted[msg.sender] = true;
    }

    function endVoting() external onlyOwner {
        if (block.timestamp >= endTime) {
            votingEnded = true;
        }
        revert VotingSystem__VotingStillOpen();
    }

    function getResults() external view votingClosed returns (string[] memory names, uint256[] memory voteCounts) {
        if (votingEnded) {
            revert VotingSystem__VotingStillOpen();
        }
        names = new string[](candidatesCount);
        voteCounts = new uint256[](candidatesCount);

        for (uint256 i = 0; i < candidatesCount; i++) {
            names[i] = candidates[i].name;
            voteCounts[i] = candidates[i].voteCount;
        }
    }

    function getCandidate(uint256 _candidateIndex) external view returns (string memory name, uint256 voteCount) {
        if (_candidateIndex >= candidatesCount) {
            revert VotingSystem__InvalidCandidateIndex();
        }
        Candidate storage candidate = candidates[_candidateIndex];
        return (candidate.name, candidate.voteCount);
    }
}
