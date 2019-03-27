const encodedMethod = require("./helpers/encodedMethod");
const { constants } = require("openzeppelin-test-helpers");
const { ZERO_ADDRESS } = constants;

const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const Pet = artifacts.require("Pet");
const PetBreed = artifacts.require("PetBreed");

contract("PetBreed", function ([_, proxyOwner, owner]) {

    beforeEach(async () => {
      this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
      this.petImpl = await Pet.new({ from: owner });
      this.petBreedImpl = await PetBreed.new({ from: owner });
      this.pet = await Pet.at(this.proxy.address);
      this.petBreed = await PetBreed.at(this.proxy.address);
    });

    it("Pet at proxy address getBreed() fail to call", async () => {
        await this.proxy.setProxyCallable(this.petBreedImpl.address, { from: proxyOwner });
        try {
            await this.pet.getBreed();
        } catch (exception) {
            return;
        }
        should.fail();
    });

    it("PetBreed at proxy address getBreed() call", async () => {
        await this.proxy.setProxyCallable(this.petBreedImpl.address, { from: proxyOwner });
        try {
            await this.petBreed.getBreed();
        } catch (exception) {
            should.fail();
        }
    });

    it("Change ownership", async () => {        
        await this.proxy.setProxyCallable(this.petBreedImpl.address, { from: proxyOwner });
        assert.equal(web3.utils.toChecksumAddress(await this.petBreedImpl.owner()), web3.utils.toChecksumAddress(owner));
        assert.equal(web3.utils.toChecksumAddress(proxyOwner), web3.utils.toChecksumAddress(await this.pet.owner()));
        assert.equal(web3.utils.toChecksumAddress(proxyOwner), web3.utils.toChecksumAddress(await this.petBreed.owner()));
    });

    it("Pet Storage alignment", async () => {
        await this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner });
        await this.petImpl.setColor("Brown", { from: owner });
        await this.pet.setColor("Blue", { from: proxyOwner });
        (await this.pet.getColor()).should.be.equal("Blue");
    });

    it("PetBreed Storage alignment", async () => {
        await this.proxy.setProxyCallable(this.petBreedImpl.address, { from: proxyOwner });
        await this.petBreedImpl.setColor("Brown", { from: owner });
        await this.pet.setColor("Blue", { from: proxyOwner });
        (await this.petBreed.getColor()).should.be.equal("Blue");
    });

});