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
  
    it("Proxy callable is an uninitialized address", async () => {
        await shouldFail.reverting(this.proxy.setProxyCallable(ZERO_ADDRESS, { from: proxyOwner }));
    });

    it("Proxy callable is a contract", async () => {
        await this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner });
    });

    it("Proxy callable has been set", async () => {
        const { logs } = await this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner });
        expectEvent.inLogs(logs, "InitialProxyCallable", {
            callable: this.petImpl.address,
        });
    });

    it("The new proxy callable can't be the current proxy callable", async () => {
        await this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner });
        await shouldFail.reverting(this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner }));
    });

    it("Proxy callable has been upgraded", async () => {
        await this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner });
        const { logs } = await this.proxy.setProxyCallable(this.petBreedImpl.address, { from: proxyOwner });
        expectEvent.inLogs(logs, "UpgradedProxyCallable", {
            fromCallable: this.petImpl.address,
            toCallable: this.petBreedImpl.address,
        });
    });

});