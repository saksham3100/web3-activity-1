// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.20;

contract Voting {

    struct Candidate {
        string name;
        uint vote_ct;
    }

    Candidate[] public candidates;

    mapping(address => bool) public Voted;
    address public owner;

     constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender==owner,"you are not the owner");
        _;

    }

    function addCandidate(string memory _name) public {
        candidates.push(Candidate(_name, 0));
    }

    function vote(uint id) public {
        require(!Voted[msg.sender], "You have already voted");
        require(id < candidates.length, "Invalid input");
        Voted[msg.sender] = true;
        candidates[id].vote_ct++;
    }

    function candidate_ct() public view returns (uint) {
        return candidates.length;
    }

    function GetCandidate(uint _index) public view returns (string memory, uint) {
        require(_index < candidates.length, "Candidate doesn't exist");
        return (candidates[_index].name, candidates[_index].vote_ct);
    }
}



