// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract SimpleElection {

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    address public owner;
    uint public candidateCount;

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public hasVoted;

    event CandidateAdded(uint indexed id, string name);
    event Voted(address indexed voter, uint indexed candidateId);


    modifier onlyOwner {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier candidateExists(uint _id) {
        require(_id > 0 && _id <= candidateCount, "Candidate does not exist");
        _;
    }


    constructor() {
        owner = msg.sender;
        candidateCount = 0; 
    }

    
    function addCandidate(string calldata _name) external onlyOwner {
        require(bytes(_name).length > 0, "Name required");

        candidateCount += 1;
        candidates[candidateCount] = Candidate({
            id: candidateCount,
            name: _name,
            voteCount: 0
        });

        emit CandidateAdded(candidateCount, _name);
    }



    function vote(uint _candidateId)   external candidateExists(_candidateId) 
    {
        require(!hasVoted[msg.sender], "Already voted");

        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount += 1;

        emit Voted(msg.sender, _candidateId);
    }


    function getCandidate(uint _candidateId)  external  view 
        candidateExists(_candidateId)
        returns (uint id, string memory name, uint voteCount)
    {
        Candidate storage c = candidates[_candidateId];
        return (c.id, c.name, c.voteCount);
    }


    function getWinner() external view returns (uint winnerId, string memory winnerName, uint winnerVotes) {
        require(candidateCount > 0, "No candidates available");

        uint maxVotes = 0;
        uint winningId = 0;

        for (uint i = 1; i <= candidateCount; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winningId = candidates[i].id;
            }
        }

        Candidate memory w = candidates[winningId];
        return (w.id, w.name, w.voteCount);
    }
}
