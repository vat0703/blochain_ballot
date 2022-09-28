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
    uint256 votesCount;
    Types.Vote[] public votes;
    address electionChief;
    //2-dim results array. 1st dim: voting centers, 2nd dim candidates
    uint256[][] Results;
    uint256 votersCount = 0;


    /**
     * @dev Create a new ballot to choose one of 'candidateNames'
     */
      constructor() public{
        initializeCandidateDatabase_();
        initializeVotingCenterDatabase_();
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
     * @dev Give your vote to candidate.
     * @param votingCenter_ Number of the voting center
     * @param candidate_  Number of the candidate
     */
    function vote(uint256 votingCenter_, uint256 candidate_) isEligibleVote belongsInVotingCenter(votingCenter_) public
    {
        // updating the current voter values
        voters[msg.sender].hasVoted = true;

       Results[votingCenter_][candidate_] += 1;
       votesCount +=1;
       emit voted(msg.sender);
    }

    /**
     * @dev sends all candidate list with their votes count per voting center
     * @param votingCenter_ voting center
     * @return uint256[] array of total counts per candidate of voting center
     */
    function getResultsPerVotingCenter(uint256 votingCenter_)
        public
        view
        returns (uint256[] memory)
    {
        uint256[] memory results;

        for(uint i = 0; i < candidates.length; i++) {
            results[i] = Results[votingCenter_][i];
        }
    
        return results;
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
                results[i] += Results[j][i];
            }
        }
        return results;
    }


    /**
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

    modifier belongsInVotingCenter(uint256 votingCenter_) {
        //voter belongs to voting center
        require(voters[msg.sender].votingCenter == votingCenter_, "voter doesn't belong in voting center");
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
            centerId: uint256(1),
            name: "athens",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: uint256(2),
            name: "thessaloniki",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: uint256(3),
            name: "patra",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: uint256(4),
            name: "irakleio",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: uint256(5),
            name: "larissa",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: uint256(6),
            name: "volos",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: uint256(7),
            name: "ioannina",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: uint256(8),
            name: "trikala",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: uint256(9),
            name: "xalkida",
            count: 0
        }));
        votingCenters.push(Types.VotingCenter({
            centerId: uint256(10),
            name: "serres",
            count: 0
        }));
    }
    function initializeResultsDatabase_() internal {
        Results = new uint256[][](votingCenters.length * candidates.length);

        // note: if voting is wrong change this
        // to embedded for loops
        uint256[] memory candidates_array;
        for (uint j=0;j<candidates.length;j++) {
            candidates_array[j] = 0;
        }
        for (uint i=0;i<votingCenters.length;i++){
            Results[i] = candidates_array;
        }
        votesCount = 0;
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
        votersCount += 1;
        emit voterRegistered(voter_);
    }
    function registerVoters(address[] memory voters_) public {
        for(uint256 i = 0; i < voters_.length; i++) {
            registerVoter(voters_[i]);
        }
    }
    function getVotersCount() public view returns (uint256) {
        return votersCount;
    }
    function getVotingCenter() public view returns (uint256) {
        Types.Voter memory voter = voters[msg.sender];
        return voter.votingCenter;
    }
    event voterRegistered(address voter_);
    event voted(address voter_);
    function getVotesCount() public view returns (uint256) {
        return votesCount;
    }
    function getVtingCenters() public view returns (Types.VotingCenter[] memory) {
        return votingCenters;
    }
}