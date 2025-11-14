//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting{
    struct vote{
        address voter;
        uint candidate_no;
    }

    vote[] public votes;
    uint max_vote_count;
    address public Owner;
    bool candidate_set=false;
    bool voting_start=false;
    bool voting_ended=false;
    bool show_results=false;
    string candidate1_name;
    string candidate2_name;
    string candidate3_name;
    string candidate4_name;
    string voter_name;
    int c1_votes=0;
    int c2_votes=0;
    int c3_votes=0;
    int c4_votes=0;
    int total_votes=0;

    constructor(uint _max_vote_count){
        Owner=msg.sender;
        max_vote_count=_max_vote_count;
    }

    modifier onlyowner{
        require(msg.sender == Owner, "you are not owner");
        _;
    }
    
    function set_candidate_name( string memory c1, string memory c2,string memory c3,string memory c4) onlyowner public{
        require(candidate_set == false, "Already set!!");
        candidate1_name=c1;
        candidate2_name=c2;
        candidate3_name=c3;
        candidate4_name=c4;
        candidate_set = true;
        voting_start = true;
    }

    mapping(address => bool) public vote_placed;
    function place_your_vote_here(uint c_no) public {
        require(c_no==1||c_no==2||c_no==3||c_no==4, "no such candidates exists ");
        require(candidate_set==true,"candidate still not set by owner");
        require(voting_ended==false," you are late, voting has already ended");
        require(vote_placed[msg.sender]==false,"you have already placed your vote");
        votes.push(vote(payable(msg.sender),c_no));
        if(c_no==1) c1_votes++;
        else if(c_no==2) c2_votes++;
        else if(c_no==3) c3_votes++;
        else c4_votes++;
        total_votes++;
        vote_placed[msg.sender]=true;
    }

    function voting_over() public onlyowner{
        require(voting_ended==false,"coting already closed");
        voting_ended=true;
    }

    function declare_results() public onlyowner{
        require(voting_ended==true,"voting has still not ended");
        show_results=true;
    }

    string winner_name;
    event results(string winner_name, int c1_votes, int c2_votes, int c3_votes, int c4_votes);
    function see_the_results() public{
        require(show_results==true,"you dont have permission to see the results");

             if(c1_votes>c2_votes&&c1_votes>c3_votes&&c1_votes>c4_votes){winner_name=candidate1_name;}
        else if(c2_votes>c1_votes&&c2_votes>c3_votes&&c2_votes>c4_votes){winner_name=candidate2_name;}
        else if(c3_votes>c2_votes&&c3_votes>c1_votes&&c3_votes>c4_votes){winner_name=candidate3_name;}
        else if(c4_votes>c2_votes&&c4_votes>c3_votes&&c4_votes>c1_votes){winner_name=candidate4_name;}
        else{winner_name="draw_re-voting_will_be_done";}

        emit results(winner_name,c1_votes,c2_votes,c3_votes,c4_votes);
    }
}    