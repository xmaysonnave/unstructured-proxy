const encodedMethod = require("./helpers/encodedMethod");
const { constants, expectEvent, shouldFail } = require('openzeppelin-test-helpers');
const { ZERO_ADDRESS } = constants;

const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const Pet = artifacts.require("Pet");
const PetBreed = artifacts.require("PetBreed");
const Version = artifacts.require("Version");

contract("OwnedUnstructuredProxy", function ([_, proxyOwner, owner, anotherProxyOwner]) {

    beforeEach(async () => {
        this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
        this.pet = await Pet.new({ from: owner });
        this.petBreed = await PetBreed.new({ from: owner })
    });

    it("ContractVersion", async () => {
        const version = await Version.at(await this.proxy.getVersion());
        (await version.getName()).should.be.equal("OwnedUnstructuredProxy");
        (await version.getTag()).should.be.equal("v0.0.1");
    });
  
    it("Only a proxy owner can set an implementation", async () => {
        await shouldFail.reverting(this.proxy.setImplementation(anotherProxyOwner, { from: proxyOwner }));
    });

    it("New proxy owner is an uninitialized address", async () => {
        await shouldFail.reverting(this.proxy.setTransferProxyOwnership(ZERO_ADDRESS, { from: proxyOwner }));
    });    

    it("New proxy owner can't be the current proxy owner", async () => {
        await shouldFail.reverting(this.proxy.setTransferProxyOwnership(proxyOwner, { from: proxyOwner }));
    });    

    it("Proxy ownership has been transferred", async () => {
        const { logs } = await this.proxy.setTransferProxyOwnership(anotherProxyOwner, { from: proxyOwner });
        expectEvent.inLogs(logs, "ProxyOwnershipTransferred", {
            previousProxyOwner: proxyOwner,
            newProxyOwner: anotherProxyOwner,
        });
    });

});