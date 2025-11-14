// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting{
    struct Candidate{
        string name;
        uint voteCount;
    }

    struct Voter{
        address voter;
        bool voted;
    }

    address public owner;
    Candidate[] public candidates;
    Voter[] public voters;

    bool public votingOpen = false;

    constructor(){
        owner=msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender==owner, "Not contract owner");
        _;
    }

    function addCandidate(string memory _name) public onlyOwner{
        require(votingOpen==false, "Voting already started");
        candidates.push(Candidate(_name, 0));
    }

    function startVoting() public onlyOwner{
        require(candidates.length>0, "No candidates added");
        votingOpen=true;
    }

    function alreadyVoted(address _voter) public view returns (bool){
        for(uint i=0; i<voters.length; i++){
            if(voters[i].voter == _voter){
                return true;
            }
        }
        return false;
    }

    function vote(uint candidateIndex) public{
        require(votingOpen==true, "Voting not open");
        require(candidateIndex<candidates.length, "Invalid candidate");
        require(!alreadyVoted(msg.sender), "You already voted");

        voters.push(Voter(msg.sender, true));
        candidates[candidateIndex].voteCount++;
    }

    function endVoting() public onlyOwner{
        require(votingOpen==true, "Voting not started");
        votingOpen=false;
    }

    function totalCandidates() public view returns(uint){
        return candidates.length;
    }

    function getVotes(uint index) public view returns(uint){
        require(index<candidates.length, "Invalid candidate");
        return candidates[index].voteCount;
    }
}
