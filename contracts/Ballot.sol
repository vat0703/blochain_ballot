// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.25 <0.9.0;

import "./Types.sol";

/**
 * @title Ballot
 * @author Aimilios Vatikiotis 
 * @dev Implements voting process along with winning candidate
 */
contract Ballot {
    Types.Candidate[] public candidates;
    mapping(uint256 => Types.Voter) voter;
    mapping(uint256 => Types.Candidate) candidate;
    Types.VotingCenter[] public votingCenters;
    mapping(uint256 => uint256) internal votesCount;
    Types.Votes[] public votes;
    address electionChief;


    /**
     * @dev Create a new ballot to choose one of 'candidateNames'
     * @param startTime_ When the voting process will start
     * @param endTime_ When the voting process will end
     */
     constructor(uint256 startTime_, uint256 endTime_) public{
        initializeCandidateDatabase_();
        initializeVoterDatabase_();
        initializeVotingCenterDatabase_();
        electionChief = msg.sender;
    }

    /**
     * @dev Get candidate list.

     * @return candidatesList_ All the politicians who participate in the election
     */
    function getCandidateList()
        public
        view
        returns (Types.Candidate[] memory)
    {    
        return candidates;
    }

    /**
     * @dev Get candidate list.
     * @param voterNumber  number of the current voter to send the relevent candidates list
     * @return voterEligible_ Whether the voter with provided  is eligible or not
     */
    function isVoterEligible(uint256 voterNumber)
        public
        view
        returns (bool voterEligible_)
    {
        Types.Voter storage voter_ = voter[voterNumber];
        if (!voter_.hasVoted) voterEligible_ = true;
    }



    /**
     * @dev Give your vote to candidate.
     * @param nominationNumber  Number of the candidate
     * @param voterNumber  Number of the voter to avoid re-entry
     */
    function vote(
        uint256 nominationNumber,
        uint256 voterNumber
    )
        public
        isEligibleVote(voterNumber, nominationNumber)
    {
        // updating the current voter values
        voter[voterNumber].hasVoted = true;

        // updates the votes the politician
        uint256 voteCount_ = votesCount[nominationNumber];
        votesCount[nominationNumber] = voteCount_ + 1;
    }



  



    /**
     * @dev sends all candidate list with their votes count
     * @param votingCenter_ voting center
     * @return candidateList_ List of Candidate objects with votes count
     */
    function getResultsPerVotingCenter(uint256 votingCenter_)
        public
        view
        returns (Types.Vote[] memory)
    {
    
        Types.Vote[] memory resultsList_ = new Types.Vote[](
            candidates.length
        );
        for (uint256 i = 0; i < candidates.length; i++) {
            if(votingCenter_ == )
            resultsList_[i] = Types.Results({
                name: candidates[i].name,
                partyFlag: candidates[i].partyFlag,
                nominationNumber: candidates[i].nominationNumber,
                voteCount: votesCount[candidates[i].nominationNumber]
            });
        }
        return resultsList_;
    }


  /**
     * @dev sends all candidate list with their votes count
     * @param votingCenter_ 
     * @return candidateList_ List of Candidate objects with votes count
     */
    function getResults(uint256 votingCenter_)
        public
        view
        returns (Types.Results[] memory)
    {
    
        Types.Results[] memory resultsList_ = new Types.Results[](
            candidates.length
        );
        for (uint256 i = 0; i < candidates.length; i++) {
            resultsList_[i] = Types.Results({
                name: candidates[i].name,
                partyFlag: candidates[i].partyFlag,
                nominationNumber: candidates[i].nominationNumber,
                voteCount: votesCount[candidates[i].nominationNumber]
            });
        }
        return resultsList_;
    }


    /**
     * @param voterId_ Id number of the current voter
     * @param nominationNumber_ Nomination number of the candidate
     */
    modifier isEligibleVote(uint256 voterId_, uint256 nominationNumber_) {
        Types.Voter memory voter_ = voter[voterId_];
        Types.Candidate memory politician_ = candidate[nominationNumber_];
    
        require(voter_.hasVoted == false);
        _;
    }

    /**
     * @notice To check if the user is Election Chief or not
     */
    modifier isElectionChief() {
        require(msg.sender == electionChief);
        _;
    }

    /**
     * Dummy data for Candidates
     * In the future, we can accept the same from construction,
     * which will be called at the time of deployment
     */
    function initializeCandidateDatabase_() internal {
        Types.Candidate[] memory candidates_ = new Types.Candidate[](5);

        // Kyriakos Mhtsotakis
        candidates_[0] = Types.Candidate({
            name: "ND",
            partyFlag: "https://www.news247.gr/img/1659/6654410/663000/w660/660/ndnewlogoofficial.jpg",
            nominationNumber: uint256(1)
        });
        candidates_[1] = Types.Candidate({
            name: "PASOK",
            partyFlag: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Panellinio_Sosialistiko_Kinima_Logo.svg/800px-Panellinio_Sosialistiko_Kinima_Logo.svg.png",
            nominationNumber: uint256(2)
        });
        candidates_[2] = Types.Candidate({
            name: "SYRIZA",
            partyFlag: "https://greekreporter.com/wp-content/uploads/2020/09/syriza-neo-sima-15-9-20.jpg",
            nominationNumber: uint256(3)
        });
        candidates_[3] = Types.Candidate({
            name: "KKE",
            partyFlag: "https://www.k-tipos.gr/wp-content/uploads/2018/04/kke-logo.jpg",
            nominationNumber: uint256(4)
        });

        candidates_[4] = Types.Candidate({
            name: "MERA25",
            partyFlag: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Mera25-logo.svg/1200px-Mera25-logo.svg.png",
            nominationNumber: uint256(5)
        });
    
    }

    /**
     * Dummy data for voter users
     */
    function initializeVoterDatabase_() internal {
        voter[uint256(1)] = Types.Voter({
            name: "test1",
            number: uint256(2),
            hasVoted: false
        });
    }

    function initializeVotingCenter_() internal {
        Types.VotingCenter[] memory votingCenters_ = new Types.VotingCenter[](10);

        votingCenters_[0] = Types.VotingCenter({
            name: "athens",
            centerId: uint256(1)
        });

           votingCenters_[1] = Types.VotingCenter({
            name: "patra",
            centerId: uint256(2)
        });

           votingCenters_[2] = Types.VotingCenter({
            name: "peiraias",
            centerId: uint256(3)
        });

           votingCenters_[3] = Types.VotingCenter({
            name: "thessaloniki",
            centerId: uint256(4)
        });

           votingCenters_[4] = Types.VotingCenter({
            name: "larissa",
            centerId: uint256(5)
        });

           votingCenters_[5] = Types.VotingCenter({
            name: "lamia",
            centerId: uint256(6)
        });

           votingCenters_[6] = Types.VotingCenter({
            name: "trikala",
            centerId: uint256(7)
        });

           votingCenters_[7] = Types.VotingCenter({
            name: "krhth",
            centerId: uint256(8)
        });

              votingCenters_[8] = Types.VotingCenter({
            name: "volos",
            centerId: uint256(9)
        });

              votingCenters_[9] = Types.VotingCenter({
            name: "trikala",
            centerId: uint256(10)
        });
    }
}