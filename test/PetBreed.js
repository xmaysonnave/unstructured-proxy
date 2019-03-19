const { constants, expectEvent } = require("openzeppelin-test-helpers");
const { ZERO_ADDRESS } = constants;

const encodedMethod = require("./helpers/encodedMethod");
const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const Pet = artifacts.require("Pet");
const PetBreed = artifacts.require("PetBreed");

contract("PetBreed", function ([_, proxyOwner, petOwner, anotherPetOwner]) {

    beforeEach(async () => {
      this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
      this.petImpl = await Pet.new("Dog", { from: petOwner });
      this.petBreedImpl = await PetBreed.new("Dog", "Labrador", { from: petOwner });
      this.pet = await Pet.at(this.proxy.address);
      this.petBreed = await PetBreed.at(this.proxy.address);
    });

    it("Pet at proxy address getBreed() fail to call", async () => {
        await this.proxy.setImplementation(this.petBreedImpl.address, { from: proxyOwner });
        try {
            await this.pet.getBreed();
        } catch (exception) {
            return;
        }
        should.fail();
    });

    it("PetBreed at proxy address getBreed() call", async () => {
        await this.proxy.setImplementation(this.petBreedImpl.address, { from: proxyOwner });
        try {
            await this.petBreed.getBreed();
        } catch (exception) {
            should.fail();
        }
    });

    it("Change ownership", async () => {
        await this.proxy.setImplementation(this.petBreedImpl.address, { from: proxyOwner });
        const data = encodedMethod.call("initialize", ["address"], [anotherPetOwner]);
        await web3.eth.sendTransaction({ from: petOwner, to: this.proxy.address, data: data });
        assert.equal(web3.utils.toChecksumAddress(anotherPetOwner), web3.utils.toChecksumAddress(await this.pet.owner()));
        assert.equal(web3.utils.toChecksumAddress(anotherPetOwner), web3.utils.toChecksumAddress(await this.petBreed.owner()));
    });

    it("Storage alignment", async () => {
        await this.proxy.setImplementation(this.petImpl.address, { from: proxyOwner });
        await this.pet.setColor("Brown", { from: petOwner });
        await this.proxy.setImplementation(this.petBreedImpl.address, { from: proxyOwner });
        (await this.petBreed.getColor()).should.be.equal("Brown");
    });

});