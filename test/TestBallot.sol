pragma solidity >=0.4.25 <0.9.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import '../contracts/Ballot.sol';

contract TestBallot {
    Ballot ballot;
    address voterAddress = 0x4D3C87d289ba2F3A3A57Ab563b2CBec408094C26;

    function beforeAll() public {
        ballot = Ballot(DeployedAddresses.Ballot());
    }
    function testCanRegisterVoter() public {

        ballot.registerVoter(voterAddress);
        uint256 votersCount = ballot.getVotersCount();
        Assert.equal(votersCount, 1, "Voters should be 1");
    }
    // function testVotingCentersCount() public {
    //     uint256 c = ballot.getVotingCentersCount();
    //     Assert.equal(c, 10, "Voting Centers should be 10");
    // }
    function testCanVote() public {
        uint votingCenter_ = 0;
        uint candidate_ = 0;
        ballot.vote(votingCenter_, candidate_);
        uint votesCount = ballot.getVotesCount();
        Assert.equal(votesCount, 1, "Only one person has voted");

        uint256 results = ballot.getResults()[candidate_];
        uint256 expected = 1;
        Assert.equal(results, expected, "First candidate of first voting center should have one vote");
    }
    // function testCanGetResultsBeforeVoting() public {
    //     uint256[] memory results = ballot.getResults();
    //     Assert.equal(results[0], 0, 'should have no result');
    // }
    // function testCanGetResultsOfVotingCenterBeforeVoting() public {
    //     uint256[] memory results = ballot.getResultsPerVotingCenter(uint256(0));
    //     Assert.equal(results[0], 0, 'should have no result');
    // }
}