const ConvertLib = artifacts.require("ConvertLib");
const MetaCoin = artifacts.require("MetaCoin");
const Ballot = artifacts.require("Ballot");
const Types = artifacts.require("Types");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);
  deployer.deploy(Types);
  deployer.link(Types, Ballot);
  deployer.deploy(Ballot, 1649250142, 1662550200);
};
