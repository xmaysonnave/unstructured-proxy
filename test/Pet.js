const { constants, expectEvent, shouldFail } = require('openzeppelin-test-helpers');
const { ZERO_ADDRESS } = constants;

const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const Pet = artifacts.require("Pet");

contract("Pet", function ([_, proxyOwner, anyone]) {

    beforeEach(async () => {
        this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
        this.pet = await Pet.new("Dog", { from: anyone });
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

});