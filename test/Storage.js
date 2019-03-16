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
const encodeCall = require("./helpers/encodeCall")
const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy")
const Pet = artifacts.require("Pet")

contract("Storage", ([_, proxyOwner, petOwner ]) => {

    beforeEach(async () => {
        this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner })
        this.pet = await Pet.new("Dog", { from: petOwner })
        await this.proxy.setImplementation(this.pet.address, { from: proxyOwner })
    });

    it("Check position", async () => {
        const position = web3.utils.sha3("org.maatech.proxy.implementation.address");
        const storage = await web3.eth.getStorageAt(this.proxy.address, position);
        assert.equal(web3.utils.toChecksumAddress(storage), web3.utils.toChecksumAddress(this.pet.address));
    });

    it("Low level call", async () => {
        const initializeData = encodeCall("setColor", ["string"], ["Brown"])
        await proxy.lowLevelCall(initializeData, { from: proxyOwner })
    });

});