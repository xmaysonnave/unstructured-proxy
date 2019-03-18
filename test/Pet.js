const { expectEvent } = require('openzeppelin-test-helpers');

const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const Pet = artifacts.require("Pet");

contract("Pet", function ([_, proxyOwner, petOwner]) {

    beforeEach(async () => {
        this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
        this.petImpl = await Pet.new("Dog", { from: petOwner });
    });

    it("Pet implementation does not have the function getBreed()", async () => {
        await this.proxy.setImplementation(this.petImpl.address, { from: proxyOwner });
        const currentPet = await Pet.at(this.proxy.address);
        try {
             await currentPet.getBreed();
        } catch (exception) {
            return;
        }
        should.fail();
    });

});