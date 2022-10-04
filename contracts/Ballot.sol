// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.25 <0.9.0;

import "./Types.sol";

/**
 * @title Ballot
 * @author Aimilios Vatikiotis, Konstantinos Galiatsos, Michail Kontosoros
 * @dev Implements voting process along with voting results
 */
contract Ballot {
    // Array of candidates (name, partyFlag, numinationNumber)
    Types.Candidate[] public candidates;
    // mapping of voters (address => Voters (hasVoted, votingCenter) )
    mapping(address => Types.Voter) voters;
    // Array of VotingCenter (centerId, name, count)
    Types.VotingCenter[] public votingCenters;
    // number of total votes cast
    uint256 votesCount;
    // Array of Votes (candidate, votingCenter, count)
    Types.Vote[] public votes;
    // The owner of the contract
    // has permission to do more actions than a voter
    address electionChief;
    //2-dim results array. 1st dim: voting centers, 2nd dim candidates
    uint256[][] Results;
    // number of register voters.
    uint256 votersCount = 0;

    /**
     * @dev Create a new ballot to choose one of 'candidateNames'
     */
    constructor() public {
        initializeCandidateDatabase_();
        initializeVotingCenterDatabase_();
        initializeResultsDatabase_();
        electionChief = msg.sender;
    }

    /**
     * @dev Get candidate list.
     * @return candidatesList_ All the politicians who participate in the election
     */
    function getCandidateList() public view returns (Types.Candidate[] memory) {
        return candidates;
    }

    /**
     * @dev Give your vote to candidate.
     * @param votingCenter_ Number of the voting center
     * @param candidate_  Number of the candidate
     */
    function vote(uint256 votingCenter_, uint256 candidate_)
        public
        isEligibleVote
        belongsInVotingCenter(votingCenter_)
    {
        emit startVoting(msg.sender);
        // updating the current voter values
        voters[msg.sender].hasVoted = true;

        // add 1 vote to the currernt of the selected candidate in the voting center
        Results[votingCenter_][candidate_] += 1;
        // increase total number of votes
        votesCount += 1;
        emit voted(msg.sender);
    }

    /**
     * @dev returns all candidate list with their votes count per voting center
     * @param votingCenter_ voting center
     * @return uint256[] array of total counts per candidate of voting center
     */
    function getResultsPerVotingCenter(uint256 votingCenter_)
        public
        view
        returns (uint256[] memory)
    {
        uint256[] memory results = new uint256[](candidates.length);

        for (uint256 i = 0; i < candidates.length; i++) {
            results[i] = 0;
            results[i] += Results[votingCenter_][i];
        }

        return results;
    }

    /**
     * @dev returns all candidate list with their votes count
     * @return uint256[] array of total counts per candidate
     */
    function getResults() public view returns (uint256[] memory) {
        uint256[] memory results = new uint256[](candidates.length);
        for (uint256 i = 0; i < candidates.length; i++) {
            results[i] = 0;
            for (uint256 j = 0; j < votingCenters.length; j++) {
                results[i] += Results[j][i];
            }
        }
        return results;
    }

    /**
     * @notice To check if the user has already voted
     */
    modifier isEligibleVote() {
        Types.Voter memory voter_ = voters[msg.sender];
        require(voter_.hasVoted == false, " voter has already voted");
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
     * @notice To check if the user is registered in the selected voting center
     */
    modifier belongsInVotingCenter(uint256 votingCenter_) {
        //voter belongs to voting center
        require(
            voters[msg.sender].votingCenter == votingCenter_,
            "voter doesn't belong in voting center"
        );
        _;
    }

    /**
     * Initialize the array of candidates
     */
    function initializeCandidateDatabase_() internal {
        candidates.push(
            Types.Candidate({
                name: "ND",
                partyFlag: "https://www.news247.gr/img/1659/6654410/663000/w660/660/ndnewlogoofficial.jpg",
                nominationNumber: uint256(1)
            })
        );
        candidates.push(
            Types.Candidate({
                name: "PASOK",
                partyFlag: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Panellinio_Sosialistiko_Kinima_Logo.svg/800px-Panellinio_Sosialistiko_Kinima_Logo.svg.png",
                nominationNumber: uint256(2)
            })
        );
        candidates.push(
            Types.Candidate({
                name: "SYRIZA",
                partyFlag: "https://greekreporter.com/wp-content/uploads/2020/09/syriza-neo-sima-15-9-20.jpg",
                nominationNumber: uint256(3)
            })
        );
        candidates.push(
            Types.Candidate({
                name: "KKE",
                partyFlag: "https://www.902.gr/sites/default/files/styles/902-grid-8/public/MediaV2/misc/kke-1_0.jpg",
                nominationNumber: uint256(4)
            })
        );

        candidates.push(
            Types.Candidate({
                name: "MERA25",
                partyFlag: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Mera25-logo.svg/1200px-Mera25-logo.svg.png",
                nominationNumber: uint256(5)
            })
        );
    }

    /**
     * Initialize the Voting Centers with data
     */
    function initializeVotingCenterDatabase_() internal {
        votingCenters.push(
            Types.VotingCenter({centerId: uint256(1), name: "athens", count: 0})
        );
        votingCenters.push(
            Types.VotingCenter({
                centerId: uint256(2),
                name: "thessaloniki",
                count: 0
            })
        );
        votingCenters.push(
            Types.VotingCenter({centerId: uint256(3), name: "patra", count: 0})
        );
        votingCenters.push(
            Types.VotingCenter({
                centerId: uint256(4),
                name: "irakleio",
                count: 0
            })
        );
        votingCenters.push(
            Types.VotingCenter({
                centerId: uint256(5),
                name: "larissa",
                count: 0
            })
        );
        votingCenters.push(
            Types.VotingCenter({centerId: uint256(6), name: "volos", count: 0})
        );
        votingCenters.push(
            Types.VotingCenter({
                centerId: uint256(7),
                name: "ioannina",
                count: 0
            })
        );
        votingCenters.push(
            Types.VotingCenter({
                centerId: uint256(8),
                name: "trikala",
                count: 0
            })
        );
        votingCenters.push(
            Types.VotingCenter({
                centerId: uint256(9),
                name: "xalkida",
                count: 0
            })
        );
        votingCenters.push(
            Types.VotingCenter({
                centerId: uint256(10),
                name: "serres",
                count: 0
            })
        );
    }

    /**
     * Initialize the results array with zero values
     */
    function initializeResultsDatabase_() internal {
        for (uint256 i = 0; i < votingCenters.length; i++) {
            uint256[] memory arr = new uint256[](votingCenters.length);
            for (uint256 j = 0; j < candidates.length; j++) {
                arr[i] = 0;
            }
            Results.push(arr);
        }
        votesCount = uint256(0);
    }

    /**
     * @dev returns all candidate list with their votes count
     * @param voter_ the address of the voter to be registered
     */
    function registerVoter(address voter_) isElectionChief public  {
        uint256 votingCenterIndex = 0;
        for (uint256 i = 0; i < votingCenters.length; i++) {
            if (votingCenters[i].count < 10) {
                votingCenterIndex = i;
                votingCenters[i].count += 1;
                break;
            }
        }
        voters[voter_] = Types.Voter(false, votingCenterIndex);
        votersCount += 1;
        emit voterRegistered(voter_);
    }

    function registerVoters(address[] memory voters_) public {
        for (uint256 i = 0; i < voters_.length; i++) {
            registerVoter(voters_[i]);
        }
    }

    function getVotersCount() public view returns (uint256) {
        return votersCount;
    }

    function getVotingCenter(address voter_) public view returns (uint256) {
        Types.Voter memory voter = voters[voter_];
        return voter.votingCenter;
    }

    event voterRegistered(address voter_);
    event voted(address voter_);
    event startVoting(address voter_);

    function getVotesCount() public view returns (uint256) {
        return votesCount;
    }

    function getVotingCenters()
        public
        view
        returns (Types.VotingCenter[] memory)
    {
        return votingCenters;
    }

    function getVotingCentersCount() public view returns (uint256) {
        return votingCenters.length;
    }
}
