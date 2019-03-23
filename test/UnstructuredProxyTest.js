const { constants, expectEvent, shouldFail } = require('openzeppelin-test-helpers');
const { ZERO_ADDRESS } = constants;

const UnstructuredProxy = artifacts.require("UnstructuredProxy");
const Pet = artifacts.require("Pet");
const PetBreed = artifacts.require("PetBreed");
const Version = artifacts.require("Version");

contract("UnstructuredProxy", function ([_, proxyOwner, owner]) {

    beforeEach(async () => {
      this.proxy = await UnstructuredProxy.new({ from: proxyOwner });
      this.petImpl = await Pet.new({ from: owner });
      this.petBreedImpl = await PetBreed.new({ from: owner });
    });

    it("ContractVersion", async () => {
        const version = await Version.at(await this.proxy.getVersion());
        (await version.getName()).should.be.equal("UnstructuredProxy");
        (await version.getTag()).should.be.equal("v0.0.1");
    });
  
    it("Implementation is an uninitialized address", async () => {
        await shouldFail.reverting(this.proxy.setImplementation(ZERO_ADDRESS, { from: proxyOwner }));
    });

    it("Implementation is not a contract", async () => {
        await shouldFail.reverting(this.proxy.setImplementation(owner, { from: proxyOwner }));
    });

    it("Implementation is a contract", async () => {
        await this.proxy.setImplementation(this.petImpl.address, { from: proxyOwner });
    });

    it("Implementation has been set", async () => {
        const { logs } = await this.proxy.setImplementation(this.petImpl.address, { from: proxyOwner });
        expectEvent.inLogs(logs, "InitialImplementation", {
            implementation: this.petImpl.address,
        });
    });    

    it("The new implementation can't be the current implementation", async () => {
        await this.proxy.setImplementation(this.petImpl.address, { from: proxyOwner });
        await shouldFail.reverting(this.proxy.setImplementation(this.petImpl.address, { from: proxyOwner }));
    });

    it("Implementation has been upgraded", async () => {
        await this.proxy.setImplementation(this.petImpl.address, { from: proxyOwner });
        const { logs } = await this.proxy.setImplementation(this.petBreedImpl.address, { from: proxyOwner });
        expectEvent.inLogs(logs, "UpgradedImplementation", {
            fromImplementation: this.petImpl.address,
            toImplementation: this.petBreedImpl.address,
        });
    });

});