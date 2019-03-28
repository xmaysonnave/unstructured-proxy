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
const { constants, expectEvent, shouldFail } = require('openzeppelin-test-helpers');
const { ZERO_ADDRESS } = constants;
const { expect } = require('chai');

const encodedMethod = require("./helpers/encodedMethod");
const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const Pet = artifacts.require("Pet");
const PetBreed = artifacts.require("PetBreed");
const Version = artifacts.require("Version");

contract("OwnedUnstructuredProxy", function ([_, proxyOwner, owner, anotherProxyOwner]) {

    beforeEach(async () => {
        this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
        this.petImpl = await Pet.new({ from: owner });
        this.petBreedImpl = await PetBreed.new({ from: owner })
    });

    it("ContractVersion", async () => {
        const version = await Version.at(await this.proxy.getVersion());
        expect(await version.getName()).to.equal("OwnedUnstructuredProxy");
        expect(await version.getTag()).to.equal("v0.0.1");
    });

    it("Proxy callable is an uninitialized address", async () => {
        await shouldFail.reverting(this.proxy.setProxyCallable(ZERO_ADDRESS, { from: proxyOwner }));
    });

    it("Proxy callable is a contract", async () => {
        await this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner });
    });    
  
    it("Only a proxy owner can set an proxy callable", async () => {
        await shouldFail.reverting(this.proxy.setProxyCallable(this.petImpl.address, { from: anotherProxyOwner }));
    });

    it("Proxy callable is initialized once", async () => {
        await this.proxy.setProxyCallable(this.petImpl.address, { from: proxyOwner });
        const data = encodedMethod.call("initialize", ["address"], [proxyOwner]);
        await shouldFail.reverting(web3.eth.sendTransaction({ from: proxyOwner, to: this.proxy.address, data: data }));
    });

    it("New proxy owner is an uninitialized address", async () => {
        await shouldFail.reverting(this.proxy.setTransferProxyOwnership(ZERO_ADDRESS, { from: proxyOwner }));
    });    

    it("New proxy owner can't be the current proxy owner", async () => {
        await shouldFail.reverting(this.proxy.setTransferProxyOwnership(proxyOwner, { from: proxyOwner }));
    });    

    it("Proxy ownership has been transferred", async () => {
        const { logs } = await this.proxy.setTransferProxyOwnership(anotherProxyOwner, { from: proxyOwner });
        expectEvent.inLogs(logs, "ProxyOwnershipTransferred", {
            previousProxyOwner: proxyOwner,
            newProxyOwner: anotherProxyOwner,
        });
    });

});