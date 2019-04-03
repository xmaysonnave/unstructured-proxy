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
const { constants, expectEvent, shouldFail } = require("openzeppelin-test-helpers");
const { ZERO_ADDRESS } = constants;
const { expect } = require("chai");

const UnstructuredProxy = artifacts.require("UnstructuredProxy");
const Pet = artifacts.require("Pet");
const PetBreed = artifacts.require("PetBreed");
const Version = artifacts.require("Version");

contract("UnstructuredProxy", function ([_, proxyOwner, owner]) {

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
  
    it("Proxy callable is an uninitialized address", async () => {
        await shouldFail.reverting(this.proxy.setProxyCallable(ZERO_ADDRESS, { from: proxyOwner }));
    });

    it("Proxy callable is a contract", async () => {
        await this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner });
    });

    it("Proxy callable has been set", async () => {
        const { logs } = await this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner });
        expectEvent.inLogs(logs, "UpgradedProxyCallable", {
            fromCallable: ZERO_ADDRESS,
            toCallable: this.petImpl.address,
        });
    });

    it("The new proxy callable can't be the current proxy callable", async () => {
        await this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner });
        await shouldFail.reverting(this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner }));
    });

    it("Proxy callable has been upgraded", async () => {
        await this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner });
        const { logs } = await this.proxy.setProxyCallable(this.petBreedImpl.address, { from: proxyOwner });
        expectEvent.inLogs(logs, "UpgradedProxyCallable", {
            fromCallable: this.petImpl.address,
            toCallable: this.petBreedImpl.address,
        });
    });

});