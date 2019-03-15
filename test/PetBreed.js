const { constants, expectEvent, shouldFail } = require('openzeppelin-test-helpers');
const { ZERO_ADDRESS } = constants;

const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const Pet = artifacts.require("Pet");
const PetBreed = artifacts.require("PetBreed");

contract("PetBreed", function ([_, proxyOwner, anyone]) {

    beforeEach(async () => {
      this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
      this.pet = await Pet.new("Dog", { from: anyone });
      this.petBreed = await PetBreed.new("Dog", "Labrador", { from: anyone });
    });

    it("PetBreed implementation does have the function getBreed().", async () => {
        await this.proxy.setImplementation(this.pet.address, { from: proxyOwner });
        await this.proxy.setImplementation(this.petBreed.address, { from: proxyOwner });
        const currentPet = await PetBreed.at(await this.proxy.getImplementation());
        try {
            await currentPet.getBreed();
        } catch (exception) {
            should.fail();
        }
    });

});