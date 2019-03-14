const { constants, expectEvent, shouldFail } = require('openzeppelin-test-helpers');
const { ZERO_ADDRESS } = constants;

const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const Pet = artifacts.require("Pet");
const PetBreed = artifacts.require("PetBreed");

contract("OwnedUnstructuredProxy", function ([_, proxyOwner, newProxyOwner]) {

    beforeEach(async () => {
      this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
      this.pet = await Pet.new("Dog", { from: proxyOwner });
      this.petBreed = await PetBreed.new("Dog", "Labrador", { from: proxyOwner });
    });
  
    it("Implementation is an uninitialized address.", async () => {
        await shouldFail.reverting(this.proxy.setImplementation(ZERO_ADDRESS));
    });

    it("Implementation is not a contract.", async () => {
        await shouldFail.reverting(this.proxy.setImplementation(proxyOwner, { from: proxyOwner }));
    });

    it("Only a proxy owner can set an implementation.", async () => {
        await shouldFail.reverting(this.proxy.setImplementation(newProxyOwner));
    });

    it("Implementation is a contract.", async () => {
        await this.proxy.setImplementation(this.pet.address, { from: proxyOwner });
    });

    it("Implementation has been set.", async () => {
        const { logs } = await this.proxy.setImplementation(this.pet.address,  { from: proxyOwner });
        expectEvent.inLogs(logs, "InitialImplementation", {
            implementation : this.pet.address,
        });
    });    

    it("Pet implementation does not have the function getBreed().", async () => {
        await this.proxy.setImplementation(this.pet.address, { from: proxyOwner });
        const currentPet = await Pet.at(await this.proxy.getImplementation());
        try {
             await currentPet.getBreed();
        } catch (exception) {
            return;
        }
        should.fail();
    });

    it("The new implementation can't be the current implementation.", async () => {
        await this.proxy.setImplementation(this.pet.address, { from: proxyOwner });
        await shouldFail.reverting(this.proxy.setImplementation(this.pet.address));
    });

    it("Implementation has been upgraded.", async () => {
        await this.proxy.setImplementation(this.pet.address, { from: proxyOwner });
        const { logs } = await this.proxy.setImplementation(this.petBreed.address, { from: proxyOwner });
        expectEvent.inLogs(logs, "UpgradedImplementation", {
            fromImplementation : this.pet.address,
            toImplementation: this.petBreed.address,
        });
    });

    it("PetBreed implementation does have the function getBreed().", async () => {
        await this.proxy.setImplementation(this.petBreed.address, { from: proxyOwner });
        const currentPet = await PetBreed.at(await this.proxy.getImplementation());
        try {
            await currentPet.getBreed();
        } catch (exception) {
            should.fail();
        }
    });

    it("New proxy owner is an uninitialized address.", async () => {
        await shouldFail.reverting(this.proxy.setTransferProxyOwnership(ZERO_ADDRESS));
    });    

    it("New proxy owner can't be the current proxy owner.", async () => {
        await shouldFail.reverting(this.proxy.setTransferProxyOwnership(proxyOwner, { from: proxyOwner }));
    });    

    it("Proxy ownership has been transferred.", async () => {
        const { logs } = await this.proxy.setTransferProxyOwnership(newProxyOwner, { from: proxyOwner });
        expectEvent.inLogs(logs, "ProxyOwnershipTransferred", {
            previousOwner : proxyOwner,
            newOwner : newProxyOwner,
        });
    });    

});