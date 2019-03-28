module.exports = {
    // See <http://truffleframework.com/docs/advanced/configuration>
    // to customize your Truffle configuration!
    // sudo snap refresh solc --candidate
    compilers: {
        solc: {
            version: "0.5.7",
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
            host: "localhost",
            port: 8545,
            network_id: "*" // eslint-disable-line camelcase
        },
        coverage: {
            host: 'localhost',
            network_id: '*', // eslint-disable-line camelcase
            port: 8555,
            gas: 0xfffffffffff,
            gasPrice: 0x01,
        },
    },
    coverage: {
        host: "localhost",
        network_id: "*",
        port: 8555,         // <-- If you change this, also set the port option in .solcover.js.
        gas: 0xfffffffffff, // <-- Use this high gas value
        gasPrice: 0x01      // <-- Use this low gas price
      },    
};