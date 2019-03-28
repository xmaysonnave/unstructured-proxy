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

const encodedMethod = require("./helpers/encodedMethod");
const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const ParityHack = artifacts.require("ParityHack");
const PetBreed = artifacts.require("PetBreed");

contract("ParityHack", function ([_, proxyOwner, hackerOwner, owner]) {

    beforeEach(async () => {
      this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
      this.petBreedImpl = await PetBreed.new({ from: owner });
      this.petBreed = await PetBreed.at(this.proxy.address);
      this.hacker = await ParityHack.new({ from: hackerOwner });
    });

    it("Implementation is not set", async () => {
        await this.hacker.setTarget(this.proxy.address);
        const data = encodedMethod.call("initialize", ["address"], [hackerOwner]);
        await shouldFail.reverting(web3.eth.sendTransaction({ from: hackerOwner, to: this.hacker.address, data: data }));
        await shouldFail.reverting(web3.eth.sendTransaction({ from: hackerOwner, to: this.petBreed.address, data: data }));
    });

    it("Cannot change owner", async () => {
        await this.hacker.setTarget(this.petBreedImpl.address); 
        const dataInit = encodedMethod.call("initialize", ["address"], [hackerOwner]);
        await shouldFail.reverting(web3.eth.sendTransaction({ from: hackerOwner, to: this.hacker.address, data: dataInit }));
        const dataTransfer = encodedMethod.call("transferOwnership", ["address"], [hackerOwner]);
        await shouldFail.reverting(web3.eth.sendTransaction({ from: hackerOwner, to: this.hacker.address, data: dataTransfer }));
    });

});