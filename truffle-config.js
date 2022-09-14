module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*", // Match any network id
    }
  },
  compilers: {
    solc: {
      settings: {
        optimizer: {
          enabled: false, // Default: false
          runs: 200      // Default: 200
        },
      }
    }
  }
};
