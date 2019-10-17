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
const { constants, expectEvent, expectRevert } = require("@openzeppelin/test-helpers");
const { expect } = require("chai");

const UnstructuredProxy = artifacts.require("UnstructuredProxy");
const Pet = artifacts.require("Pet");
const PetBreed = artifacts.require("PetBreed");
const Version = artifacts.require("Version");

contract("UnstructuredProxy", function ([_, proxyOwner, owner, anyone]) {

    beforeEach(async () => {
      this.proxy = await UnstructuredProxy.new({ from: proxyOwner });
      this.petImpl = await Pet.new({ from: owner });
      this.petBreedImpl = await PetBreed.new({ from: owner });
    });

    it("ContractVersion", async () => {
        const version = await Version.at(await this.proxy.getVersion());
        expect(await version.getName()).to.equal("UnstructuredProxy");
        expect(await version.getTag()).to.equal("v0.0.1");
    });
  
    it("Callable is an uninitialized address", async () => {
        await expectRevert.unspecified(this.proxy.setCallable(constants.ZERO_ADDRESS, { from: proxyOwner }));
    });

    it("Callable is a contract", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
    });

    it("Callable is not a contract", async () => {
        await expectRevert.unspecified(this.proxy.setCallable(anyone, { from: proxyOwner }));
    });

    it("Callable has been set", async () => {
        const { logs } = await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        expectEvent.inLogs(logs, "UpgradedCallable", {
            fromCallable: constants.ZERO_ADDRESS,
            toCallable: this.petImpl.address,
        });
    });

    it("The new callable can't be the current callable", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        await expectRevert.unspecified(this.proxy.setCallable(this.petImpl.address, { from: proxyOwner }));
    });

    it("Callable has been upgraded", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        const { logs } = await this.proxy.setCallable(this.petBreedImpl.address, { from: proxyOwner });
        expectEvent.inLogs(logs, "UpgradedCallable", {
            fromCallable: this.petImpl.address,
            toCallable: this.petBreedImpl.address,
        });
    });

});