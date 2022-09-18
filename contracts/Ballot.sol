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
    mapping(address => Types.Voter) voters;
    // mapping(uint256 => Types.Candidate) candidate;
    Types.VotingCenter[] public votingCenters;
    mapping(uint256 => uint256) internal votesCount;
    Types.Vote[] public votes;
    address electionChief;
    //2-dim results array. 1st dim: voting centers, 2nd dim candidates
    uint256[][] Results;


    /**
     * @dev Create a new ballot to choose one of 'candidateNames'
     */
      constructor() public{
        initializeCandidateDatabase_();
        initializeVotingCenterDatabase_();
        initializeVoterDatabase_();
        
        initializeResultsDatabase_();
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
     * @param voterAddress  address of the current voter to send the relevent candidates list
     * @return voterEligible_ Whether the voter with provided  is eligible or not
     */
    function isVoterEligible(address voterAddress)
        public
        view
        returns (bool voterEligible_)
    {
        Types.Voter storage voter_ = voters[voterAddress];
        if (!voter_.hasVoted) voterEligible_ = true;
    }



    /**
     * @dev Give your vote to candidate.
     * @param votingCenter_ Number of the voting center
     * @param candidate_  Number of the candidate
     */
    function vote(uint256 votingCenter_, uint256 candidate_) isEligibleVote public
    {
        // updating the current voter values
        voters[msg.sender].hasVoted = true;

       Results[votingCenter_][candidate_] += 1;
    }

    /**
     * @dev sends all candidate list with their votes count
     * @param votingCenter_ voting center
     * @return uint256[] array of total counts per candidate of voting center
     */
    function getResultsPerVotingCenter(uint256 votingCenter_)
        public
        view
        returns (uint256[] memory)
    {
    
        return Results[votingCenter_];
    }


   /**
     * @dev sends all candidate list with their votes count
     * @return uint256[] array of total counts per candidate
     */
    function getResults()
        public
        view
        returns (uint256[] memory)
    {
        uint256[] memory results;
        for(uint i = 0; i < candidates.length; i++) {
            results[i] = 0;
            for(uint j = 0; j < votingCenters.length; j++) {
                results[i] += Results[i][j];
            }
        }
        return results;
    }


    /**
     */
    modifier isEligibleVote() {
        Types.Voter memory voter_ = voters[msg.sender];    
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
        candidates.push(Types.Candidate({
            name: "ND",
            partyFlag: "https://www.news247.gr/img/1659/6654410/663000/w660/660/ndnewlogoofficial.jpg",
            nominationNumber: uint256(1)
        }));
        candidates.push(Types.Candidate({
            name: "PASOK",
            partyFlag: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Panellinio_Sosialistiko_Kinima_Logo.svg/800px-Panellinio_Sosialistiko_Kinima_Logo.svg.png",
            nominationNumber: uint256(2)
        }));
        candidates.push(Types.Candidate({
            name: "SYRIZA",
            partyFlag: "https://greekreporter.com/wp-content/uploads/2020/09/syriza-neo-sima-15-9-20.jpg",
            nominationNumber: uint256(3)
        }));
        candidates.push(Types.Candidate({
            name: "KKE",
            partyFlag: "https://www.kke.gr/export/sites/default/.content/site-images/logo-og.jpg",
            nominationNumber: uint256(4)
        }));

        candidates.push(Types.Candidate({
            name: "MERA25",
            partyFlag: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Mera25-logo.svg/1200px-Mera25-logo.svg.png",
            nominationNumber: uint256(5)
        }));

    
    }

    function initializeVotingCenterDatabase_() internal {
        votingCenters.push(Types.VotingCenter({
            centerId: 1,
            name: "voting center 1",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: 2,
            name: "voting center 2",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: 3,
            name: "voting center 3",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: 4,
            name: "voting center 4",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: 5,
            name: "voting center 5",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: 6,
            name: "voting center 6",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: 7,
            name: "voting center 7",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: 8,
            name: "voting center 8",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: 9,
            name: "voting center 9",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: 10,
            name: "voting center 10",
            count: 0
        }));
    }
    function initializeResultsDatabase_() internal {
        for (uint i=0;i<votingCenters.length;i++){
            for (uint j=0;j<candidates.length;j++){
                Results.push ([0,0]);
            }
        }
    }

    function registerVoter(address voter_) public {
        uint256 votingCenterIndex = 0;
        for(uint i = 0; i < votingCenters.length; i++) {
            if(votingCenters[i].count < 10) {
                votingCenterIndex = i;
                votingCenters[i].count += 1;
                break;
            }
        }
        voters[voter_] = Types.Voter(false, votingCenterIndex);
    }

    /**
     * Dummy data for voter users
     */
    function initializeVoterDatabase_() internal {
        // voter[uint256(1)] = Types.Voter({
        //     name: "test1",
        //     number: uint256(2),
        //     hasVoted: false
        // });
    }

    function initializeVotingCenter_() internal {
        Types.VotingCenter[] memory votingCenters_ = new Types.VotingCenter[](10);

        votingCenters_[0] = Types.VotingCenter({
            name: "athens",
            centerId: uint256(1),
            count: 0
        });

           votingCenters_[1] = Types.VotingCenter({
            name: "patra",
            centerId: uint256(2),
            count: 0
        });

           votingCenters_[2] = Types.VotingCenter({
            name: "peiraias",
            centerId: uint256(3),
            count: 0
        });

           votingCenters_[3] = Types.VotingCenter({
            name: "thessaloniki",
            centerId: uint256(4),
            count: 0
        });

           votingCenters_[4] = Types.VotingCenter({
            name: "larissa",
            centerId: uint256(5),
            count: 0
        });

           votingCenters_[5] = Types.VotingCenter({
            name: "lamia",
            centerId: uint256(6),
            count: 0
        });

           votingCenters_[6] = Types.VotingCenter({
            name: "trikala",
            centerId: uint256(7),
            count: 0
        });

           votingCenters_[7] = Types.VotingCenter({
            name: "krhth",
            centerId: uint256(8),
            count: 0
        });

              votingCenters_[8] = Types.VotingCenter({
            name: "volos",
            centerId: uint256(9),
            count: 0
        });

              votingCenters_[9] = Types.VotingCenter({
            name: "trikala",
            centerId: uint256(10),
            count: 0
        });
    }
}