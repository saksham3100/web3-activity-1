// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract voting {
    struct candidate {
        uint id;
        string name;
        uint vote;
    }
    bool public votingstatus = true;
    candidate[] public candidates;
    mapping(address => bool) public hasvoted;
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "you are not the owner");
        _;
    }
    function addcandidate(string memory name) public onlyOwner {
        candidate memory newcandidate = candidate({
            id: candidates.length + 1,
            name: name,
            vote: 0
        });
        candidates.push(newcandidate);
    }
    function vote(uint _id) public {
        require(votingstatus == true, "voting is not started yet");
        require(!hasvoted[msg.sender], "you have already voted");
        hasvoted[msg.sender] = true;
        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].id == _id) {
                candidates[i].vote++;
                break;
            }
        }
    }

    function viewvote(uint _id) public view returns (uint) {
        return candidates[_id].vote;
    }
}
