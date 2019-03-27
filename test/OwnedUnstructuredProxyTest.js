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
        this.petImpl = await Pet.new({ from: owner });
        this.petBreedImpl = await PetBreed.new({ from: owner })
    });

    it("ContractVersion", async () => {
        const version = await Version.at(await this.proxy.getVersion());
        (await version.getName()).should.be.equal("OwnedUnstructuredProxy");
        (await version.getTag()).should.be.equal("v0.0.1");
    });

    it("Proxy callable is an uninitialized address", async () => {
        await shouldFail.reverting(this.proxy.setProxyCallable(ZERO_ADDRESS, { from: proxyOwner }));
    });

    it("Proxy callable is a contract", async () => {
        await this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner });
    });    
  
    it("Only a proxy owner can set an proxy callable", async () => {
        await shouldFail.reverting(this.proxy.setProxyCallable(this.petImpl.address, { from: anotherProxyOwner }));
    });

    it("Proxy callable is initialized once", async () => {
        this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner });
        const data = encodedMethod.call("initialize", ["address"], [proxyOwner]);
        await shouldFail.reverting(web3.eth.sendTransaction({ from: proxyOwner, to: this.proxy.address, data: data }));
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