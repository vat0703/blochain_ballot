// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.25 <0.9.0;

/**
 * @title Types
 * @author Aimilios Vatikiotis
 * @dev All custom types that we have used in E-Voting will be declared here
 */
library Types {
    struct Voter {
        bool hasVoted;
        uint256 votingCenter;
      }
    struct Candidate {
        // Note: If we can limit the length to a certain number of bytes,
        // we can use one of bytes1 to bytes32 because they are much cheaper

        string name;
        string partyFlag;
        uint256 nominationNumber; // unique ID of candidate
    }

    struct VotingCenter {
        uint256 centerId;
        string name;
        uint256 count;
    }

    struct Vote {
        uint256 candidate;
        uint256 votingCenter;
        uint256 count;
    }
}