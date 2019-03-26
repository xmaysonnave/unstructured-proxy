const { expectEvent } = require('openzeppelin-test-helpers');

const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const Pet = artifacts.require("Pet");

contract("Pet", function ([_, proxyOwner, owner]) {

    beforeEach(async () => {
        this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
        this.petImpl = await Pet.new({ from: owner });
        this.pet = await Pet.at(this.proxy.address);
    });

    it("Pet implementation does not have the function getBreed()", async () => {
        await this.proxy.setImplementation(this.petImpl.address, { from: proxyOwner });
        try {
             await pet.getBreed();
        } catch (exception) {
            return;
        }
        should.fail();
    });

});