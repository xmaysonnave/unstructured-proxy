const { expectEvent } = require('openzeppelin-test-helpers');

const encodedMethod = require("./helpers/encodedMethod");
const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const Pet = artifacts.require("Pet");

contract("Pet", function ([_, proxyOwner, petOwner]) {

    beforeEach(async () => {
        this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
        await this.proxy.initialize({ from: proxyOwner });
        this.petImpl = await Pet.new("Dog", { from: petOwner });
        await this.petImpl.setColor("Blue");
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