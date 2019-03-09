module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  // sudo snap refresh solc --candidate
  compilers: {
    solc: {
      version: "0.5.5",
      settings: {
        optimizer: {
          enabled: true, 
          runs: 200
        }
      }
    }
  },  
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    }
  }
};
