// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.25 <0.9.0;

/**
 * @title Types
 * @author Aimilios Vatikiotis, Konstantinos Galiatsos, Michail Kontosoros
 * @dev All custom types that we have used in E-Voting will be declared here
 */
library Types {
    // Struct of voter,
    // Contains a bool, whether he has voted,
    // and the voting center he is assigned to
    struct Voter {
        bool hasVoted;
        uint256 votingCenter;
    }
    // Struct of candidate
    // contains the name of the party
    // a url with the logo of the party
    // and a unique id
    struct Candidate {
        string name;
        string partyFlag;
        uint256 nominationNumber; // unique ID of candidate
    }
    // Struct of the voting Center
    // Contains the id
    // the name 
    // and the count of the voters assigned to it
    struct VotingCenter {
        uint256 centerId;
        string name;
        uint256 count;
    }
    // Struct of vote
    // Contains the id of the candidate this vote was cast,
    // the voting center is vote was cast
    // and the number of votes
    struct Vote {
        uint256 candidate;
        uint256 votingCenter;
        uint256 count;
    }
}
