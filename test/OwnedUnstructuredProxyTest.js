const { constants, expectEvent, shouldFail } = require('openzeppelin-test-helpers');
const { ZERO_ADDRESS } = constants;

const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const Pet = artifacts.require("Pet");
const PetBreed = artifacts.require("PetBreed");

contract("OwnedUnstructuredProxy", function ([_, proxyOwner, tokenOwner]) {

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
        await shouldFail.reverting(this.proxy.setImplementation(tokenOwner));
    });

    it("Implementation is a contract.", async () => {
        await this.proxy.setImplementation(this.pet.address, { from: proxyOwner });
    });

    it("Implementation has been set.", async () => {
        await this.proxy.setImplementation(this.pet.address,  { from: proxyOwner });
        (await this.proxy.getImplementation()).should.equal(this.pet.address);
    });

    it("Old implementation does not have a new function.", async () => {
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

    it("New implementation does have a new function.", async () => {
        await this.proxy.setImplementation(this.petBreed.address, { from: proxyOwner });
        const currentPet = await PetBreed.at(await this.proxy.getImplementation());
        await currentPet.getBreed();
    });

});