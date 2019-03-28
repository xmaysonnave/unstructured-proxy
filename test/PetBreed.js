/**
 *   Copyright (c) 2019 Xavier Maysonnave.
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 */
const { expect } = require('chai');

const encodedMethod = require("./helpers/encodedMethod");
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
        expect(web3.utils.toChecksumAddress(await this.petBreedImpl.owner())).to.equal(web3.utils.toChecksumAddress(owner));
        expect(web3.utils.toChecksumAddress(proxyOwner)).to.equal(web3.utils.toChecksumAddress(await this.pet.owner()));
        expect(web3.utils.toChecksumAddress(proxyOwner)) .to.equal(web3.utils.toChecksumAddress(await this.petBreed.owner()));
    });

    it("Pet Storage alignment", async () => {
        await this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner });
        await this.petImpl.setColor("Brown", { from: owner });
        await this.pet.setColor("Blue", { from: proxyOwner });
        expect(await this.pet.getColor()).to.equal("Blue");
    });

    it("PetBreed Storage alignment", async () => {
        await this.proxy.setProxyCallable(this.petBreedImpl.address, { from: proxyOwner });
        await this.petBreedImpl.setColor("Brown", { from: owner });
        await this.pet.setColor("Blue", { from: proxyOwner });
        expect(await this.petBreed.getColor()).to.equal("Blue");
    });

});