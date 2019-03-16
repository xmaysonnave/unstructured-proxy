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
const { shouldFail } = require('openzeppelin-test-helpers');

const encodeCall = require("./helpers/encodeCall")
const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy")
const Pet = artifacts.require("Pet")

contract("StoragePosition", ([_, proxyOwner, petOwner ]) => {

    beforeEach(async () => {
        this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner })
        this.pet = await Pet.new("Dog", { from: petOwner })
        await this.proxy.setImplementation(this.pet.address, { from: proxyOwner })
    });

    it("Implementation storage position", async () => {
        const position = web3.utils.sha3("org.maatech.proxy.implementation.address");
        const storage = await web3.eth.getStorageAt(this.proxy.address, position);
        assert.equal(web3.utils.toChecksumAddress(storage), web3.utils.toChecksumAddress(this.pet.address));
    });

    it("Value implementation storage position fallback call is mandatory", async () => {
        const data = encodeCall("setColor", ["string"], [""])
        await shouldFail.reverting(web3.eth.sendTransaction({ from: petOwner, to: this.proxy.address, data: data }));
    });

    it("Value implementation storage position fallback call", async () => {
        const data = encodeCall("setColor", ["string"], ["Brown"])
        await web3.eth.sendTransaction({ from: petOwner, to: this.proxy.address, data: data });
    });    

});