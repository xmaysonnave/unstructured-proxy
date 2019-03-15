const { constants, expectEvent, shouldFail } = require('openzeppelin-test-helpers');
const { ZERO_ADDRESS } = constants;

const UnstructuredProxy = artifacts.require("UnstructuredProxy");
const Pet = artifacts.require("Pet");
const PetBreed = artifacts.require("PetBreed");

contract("UnstructuredProxy", function ([_, anyone]) {

    beforeEach(async () => {
      this.proxy = await UnstructuredProxy.new({ from: anyone });
      this.pet = await Pet.new("Dog", { from: anyone });
      this.petBreed = await PetBreed.new("Dog", "Labrador", { from: anyone });
    });

    it("ContractVersionName", async () => {
        (await this.proxy.getVersionName()).should.be.equal("UnstructuredProxy");
    });    

    it("ContractVersionTag", async () => {
        (await this.proxy.getVersionTag()).should.be.equal("v0.0.1");
    });    
  
    it("Implementation is an uninitialized address.", async () => {
        await shouldFail.reverting(this.proxy.setImplementation(ZERO_ADDRESS));
    });

    it("Implementation is not a contract.", async () => {
        await shouldFail.reverting(this.proxy.setImplementation(anyone));
    });

    it("Implementation is a contract.", async () => {
        await this.proxy.setImplementation(this.pet.address);
    });

    it("Implementation has been set.", async () => {
        const { logs } = await this.proxy.setImplementation(this.pet.address);
        expectEvent.inLogs(logs, "InitialImplementation", {
            implementation : this.pet.address,
        });
    });    

    it("The new implementation can't be the current implementation.", async () => {
        await this.proxy.setImplementation(this.pet.address);
        await shouldFail.reverting(this.proxy.setImplementation(this.pet.address));
    });

    it("Implementation has been upgraded.", async () => {
        await this.proxy.setImplementation(this.pet.address);
        const { logs } = await this.proxy.setImplementation(this.petBreed.address);
        expectEvent.inLogs(logs, "UpgradedImplementation", {
            fromImplementation : this.pet.address,
            toImplementation: this.petBreed.address,
        });
    });

});