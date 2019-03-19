const { constants, expectEvent, shouldFail } = require('openzeppelin-test-helpers');
const { ZERO_ADDRESS } = constants;

const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const Pet = artifacts.require("Pet");
const PetBreed = artifacts.require("PetBreed");

contract("OwnedUnstructuredProxy", function ([_, proxyOwner, newProxyOwner, petOwner]) {

    beforeEach(async () => {
      this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
      this.pet = await Pet.new("Dog", { from: petOwner });
      this.petBreed = await PetBreed.new("Dog", "Labrador", { from: petOwner })
    });

    it("ContractVersionName", async () => {
        (await this.proxy.getVersionName()).should.be.equal("OwnedUnstructuredProxy");
    });    

    it("ContractVersionTag", async () => {
        (await this.proxy.getVersionTag()).should.be.equal("v0.0.1");
    });        
  
    it("Only a proxy owner can set an implementation", async () => {
        await shouldFail.reverting(this.proxy.setImplementation(newProxyOwner, { from: proxyOwner }));
    });

    it("New proxy owner is an uninitialized address", async () => {
        await shouldFail.reverting(this.proxy.setTransferProxyOwnership(ZERO_ADDRESS, { from: proxyOwner }));
    });    

    it("New proxy owner can't be the current proxy owner", async () => {
        await shouldFail.reverting(this.proxy.setTransferProxyOwnership(proxyOwner, { from: proxyOwner }));
    });    

    it("Proxy ownership has been transferred", async () => {
        const { logs } = await this.proxy.setTransferProxyOwnership(newProxyOwner, { from: proxyOwner });
        expectEvent.inLogs(logs, "ProxyOwnershipTransferred", {
            previousOwner: proxyOwner,
            newOwner: newProxyOwner,
        });
    });

});