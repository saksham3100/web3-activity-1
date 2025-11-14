// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract voting {
    struct candidate{
        string name;
        uint voteCount;
    }
    candidate[] public candidates;
    address public owner;
    mapping (address => bool) public hasVoted;

    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner{
        require (msg.sender==owner,"Only the owner can perform this action");
        _;
    }
    function addCandidate (string memory _name) public onlyOwner{
        candidates.push(candidate(_name, 0));
    }
    function vote(uint _candidateIndex) public {
        require(hasVoted[msg.sender] == false, "You have already voted.");
        require(_candidateIndex < candidates.length, "Invalid candidate.");
        candidates[_candidateIndex].voteCount++;
        hasVoted[msg.sender] = true;

    }
    function getCandidateCount() public view returns (uint) {
        return candidates.length;
    }
        function getCandidate(uint _index) public view returns (string memory, uint) {
            candidate storage c = candidates[_index];
        return (c.name, c.voteCount);
        }



}
