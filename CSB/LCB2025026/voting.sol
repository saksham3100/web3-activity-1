// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract voting{
    struct candidate{
        string name;
        uint voteCount;
    }
    candidate[2] public candidates;

    address public owner;
    mapping(address => bool) public hasVoted;
    bool public voting_started;
    bool public voting_ended;

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner is allowed!");
        _;
    }

    constructor(string memory candidate1, string memory candidate2) {
        owner = msg.sender;
        candidates[0] = candidate(candidate1, 0);
        candidates[1] = candidate(candidate2, 0);
    }


    function startVoting() public onlyOwner{
       require(voting_started == false, "Voting already started");
       voting_started = true;
    }

    function _voting(uint candidateIndex) public{

        require(voting_started == true, "Voting not started yet");
        require(voting_ended == false, "Voting ended!");
        require(candidateIndex == 0 || candidateIndex == 1, "Invalid Candidate.");
        require(hasVoted[msg.sender] == false, "You have already voted!");

       hasVoted[msg.sender] = true;
       candidates[candidateIndex].voteCount += 1;
    }

    
    function winner() public view returns (string memory winnerName) {
        require(voting_ended == true, "Voting is still ongoing");

        if(candidates[0].voteCount > candidates[1].voteCount){
            winnerName = candidates[0].name;
        }else if(candidates[1].voteCount > candidates[0].voteCount){
            winnerName = candidates[1].name;        
        }else{
            winnerName = "Tie";
        }
    }

    function endVoting() public onlyOwner{
        require(voting_ended == false, "Voting ended!");
        voting_ended = true;
    }

}

