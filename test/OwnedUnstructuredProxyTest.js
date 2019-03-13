const { constants, expectEvent, shouldFail } = require('openzeppelin-test-helpers');
const { ZERO_ADDRESS } = constants;

const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const Pet = artifacts.require("Pet");

contract("OwnedUnstructuredProxy", function ([_, proxyOwner, tokenOwner]) {

    beforeEach(async function () {
      this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
      this.pet = await Pet.new("Dog", {from: proxyOwner});
    });
  
    it("Implementation is an uninitialized address.", async function () {
        await shouldFail.reverting(this.proxy.setImplementation(ZERO_ADDRESS));
    });

    it("Implementation is not a contract.", async function () {
        await shouldFail.reverting(this.proxy.setImplementation(proxyOwner));
    });    

    it("Only a proxy owner can set an implementation.", async function () {
        await shouldFail.reverting(this.proxy.setImplementation(this.pet.address));
    });

    it("Implementation is successfully set.", async function () {
        await this.proxy.setImplementation(this.pet.address,  {from: proxyOwner});
        (await this.proxy.getImplementation()).should.equal(this.pet.address);
    });    

});