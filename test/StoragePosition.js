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
const { shouldFail } = require("openzeppelin-test-helpers");
const { expect } = require("chai");

const encodedMethod = require("./helpers/encodedMethod")
const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy")
const Pet = artifacts.require("Pet")

contract("StoragePosition", ([_, proxyOwner, owner]) => {

    beforeEach(async () => {
        this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
        this.petImpl = await Pet.new({ from: owner });
        this.pet = await Pet.at(this.proxy.address);
    });

    it("Proxy callable storage position", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        const position = web3.utils.sha3("org.maatech.proxy.callable");
        const storage = await web3.eth.getStorageAt(this.proxy.address, position);
        expect(web3.utils.toChecksumAddress(storage)).to.equal(web3.utils.toChecksumAddress(this.petImpl.address));
    });

    it("Only owner proxy callable storage position fallback call", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        const data = encodedMethod.call("setColor", ["string"], ["Brown"]);
        await shouldFail.reverting(web3.eth.sendTransaction({ from: proxyOwner, to: this.proxy.address, data: data }));
    });

    it("Mandatory Value proxy callable storage position fallback call", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        const data = encodedMethod.call("setColor", ["string"], [""]);
        await shouldFail.reverting(web3.eth.sendTransaction({ from: proxyOwner, to: this.proxy.address, data: data }));
    });    

    it("Value proxy callable storage position fallback call", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        const data = encodedMethod.call("setColor", ["string"], ["Blue"]);
        await web3.eth.sendTransaction({ from: owner, to: this.proxy.address, data: data });
        expect(await this.pet.getColor()).to.equal("Blue");
    });

});