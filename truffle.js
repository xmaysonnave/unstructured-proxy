module.exports = {
    // See <http://truffleframework.com/docs/advanced/configuration>
    // to customize your Truffle configuration!
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
            network_id: "*",    // eslint-disable-line camelcase
            port: 8545
        },
        coverage: {
            host: "localhost",
            network_id: "*",    // eslint-disable-line camelcase
            port: 8555,         // <-- If you change this, also set the port option in .solcover.js.
            gas: 0xfffffffffff, // <-- Use this high gas value
            gasPrice: 0x01      // <-- Use this low gas price
        },
    },
};