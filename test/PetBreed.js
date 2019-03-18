const { constants, expectEvent, shouldFail } = require('openzeppelin-test-helpers');
const { ZERO_ADDRESS } = constants;

const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const Pet = artifacts.require("Pet");
const PetBreed = artifacts.require("PetBreed");

contract("PetBreed", function ([_, proxyOwner, petOwner]) {

    beforeEach(async () => {
      this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
      this.petImpl = await Pet.new("Dog", { from: petOwner });
      this.petBreedImpl = await PetBreed.new("Dog", "Labrador", { from: petOwner });
      this.pet = await Pet.at(this.proxy.address);
      this.petBreed = await PetBreed.at(this.proxy.address);
    });

    it("PetBreed implementation does have the function getBreed().", async () => {
        await this.proxy.setImplementation(this.petImpl.address, { from: proxyOwner });
        await this.proxy.setImplementation(this.petBreedImpl.address, { from: proxyOwner });
        const currentPet = await PetBreed.at(this.proxy.address);
        try {
            await currentPet.getBreed();
        } catch (exception) {
            should.fail();
        }
    });

    it("Storage alignment", async () => {
        await this.proxy.setImplementation(this.petImpl.address, { from: proxyOwner });
        await this.pet.setColor("Brown", { from: petOwner });
        await this.proxy.setImplementation(this.petBreedImpl.address, { from: proxyOwner });
        (await this.petBreed.getColor()).should.be.equal("Brown");
    });    

});