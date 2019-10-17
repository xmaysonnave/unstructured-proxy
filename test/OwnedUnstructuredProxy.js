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
const { expect } = require('chai');

const OwnedUnstructuredProxy = artifacts.require("OwnedUnstructuredProxy");
const Pet = artifacts.require("Pet");
const PetBreed = artifacts.require("PetBreed");
const Version = artifacts.require("Version");

contract("OwnedUnstructuredProxy", function ([_, proxyOwner, owner, anotherProxyOwner, anyone]) {

    beforeEach(async () => {
        this.proxy = await OwnedUnstructuredProxy.new({ from: proxyOwner });
        this.petImpl = await Pet.new({ from: owner });
        this.petBreedImpl = await PetBreed.new({ from: owner });
        this.pet = await Pet.at(this.proxy.address);
        this.petBreed = await PetBreed.at(this.proxy.address);
    });

    it("Contract version", async () => {
        const version = await Version.at(await this.proxy.getVersion());
        expect(await version.getName()).to.equal("OwnedUnstructuredProxy");
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

    it("Only a proxy owner can set a callable", async () => {
        await expectRevert.unspecified(this.proxy.setCallable(this.petImpl.address, { from: anotherProxyOwner }));
    });

    it("New proxy owner is an uninitialized address", async () => {
        await expectRevert.unspecified(this.proxy.setTransferProxyOwnership(constants.ZERO_ADDRESS, { from: proxyOwner }));
    });

    it("New proxy owner can't be the current proxy owner", async () => {
        await expectRevert.unspecified(this.proxy.setTransferProxyOwnership(proxyOwner, { from: proxyOwner }));
    });

    it("Proxy ownership has been transferred", async () => {
        const { logs } = await this.proxy.setTransferProxyOwnership(anotherProxyOwner, { from: proxyOwner });
        expectEvent.inLogs(logs, "ProxyOwnershipTransferred", {
            previousOwner: proxyOwner,
            newOwner: anotherProxyOwner,
        });
        // const manager = await ProxyManager.at(await this.proxy.getProxyManager({ from: anotherProxyOwner }));
        // expect(web3.utils.toChecksumAddress(this.proxy.address)).to.equal(web3.utils.toChecksumAddress(await manager.owner()));
    });

    it("Callable has been set", async () => {
        const { logs } = await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        expectEvent.inLogs(logs, "UpgradedCallable", {
            fromCallable: constants.ZERO_ADDRESS,
            toCallable: this.petImpl.address,
        });
    });

    it("Callable has been upgraded", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        const { logs } = await this.proxy.setCallable(this.petBreedImpl.address, { from: proxyOwner });
        expectEvent.inLogs(logs, "UpgradedCallable", {
            fromCallable: this.petImpl.address,
            toCallable: this.petBreedImpl.address,
        });
    });

    it("Callable Change ownership", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        await this.proxy.setCallable(this.petBreedImpl.address, { from: proxyOwner });
        expect(web3.utils.toChecksumAddress(owner)).to.equal(web3.utils.toChecksumAddress(await this.pet.owner()));
        expect(web3.utils.toChecksumAddress(owner)).to.equal(web3.utils.toChecksumAddress(await this.petBreed.owner()));
    });

    it("Unknown current callable", async () => {
        const current = await this.proxy.getCallable({ from: proxyOwner });
        expect(web3.utils.toChecksumAddress(current)).to.equal(web3.utils.toChecksumAddress(constants.ZERO_ADDRESS));
    });

    it("Current callable", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        const current = await this.proxy.getCallable({ from: proxyOwner });
        expect(web3.utils.toChecksumAddress(current)).to.equal(web3.utils.toChecksumAddress(this.petImpl.address));
    });

    it("Set previous callable", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        await this.proxy.setCallable(this.petBreedImpl.address, { from: proxyOwner });
        const { logs } = await this.proxy.setPreviousCallable({ from: proxyOwner });
        expectEvent.inLogs(logs, "UpgradedCallable", {
            fromCallable: this.petBreedImpl.address,
            toCallable: this.petImpl.address,
        });
        const current = await this.proxy.getCallable({ from: proxyOwner });
        expect(web3.utils.toChecksumAddress(current)).to.equal(web3.utils.toChecksumAddress(this.petImpl.address));
    });

    it("Lower bound callable", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        await this.proxy.setCallable(this.petBreedImpl.address, { from: proxyOwner });
        await this.proxy.setPreviousCallable({ from: proxyOwner });
        const { logs } = await this.proxy.setPreviousCallable({ from: proxyOwner });
        expectEvent.inLogs(logs, "NotUpgradedCallable", {
            callable: this.petImpl.address,
        });
        const current = await this.proxy.getCallable({ from: proxyOwner });
        expect(web3.utils.toChecksumAddress(current)).to.equal(web3.utils.toChecksumAddress(this.petImpl.address));
    });

    it("Set next callable", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        await this.proxy.setCallable(this.petBreedImpl.address, { from: proxyOwner });
        await this.proxy.setPreviousCallable({ from: proxyOwner });
        const { logs } = await this.proxy.setNextCallable({ from: proxyOwner });
        expectEvent.inLogs(logs, "UpgradedCallable", {
            fromCallable: this.petImpl.address,
            toCallable: this.petBreedImpl.address,
        });
        const current = await this.proxy.getCallable({ from: proxyOwner });
        expect(web3.utils.toChecksumAddress(current)).to.equal(web3.utils.toChecksumAddress(this.petBreedImpl.address));
    });

    it("Upper bound callable", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        await this.proxy.setCallable(this.petBreedImpl.address, { from: proxyOwner });
        const { logs } = await this.proxy.setNextCallable({ from: proxyOwner });
        expectEvent.inLogs(logs, "NotUpgradedCallable", {
            callable: this.petBreedImpl.address,
        });
        const current = await this.proxy.getCallable({ from: proxyOwner });
        expect(web3.utils.toChecksumAddress(current)).to.equal(web3.utils.toChecksumAddress(this.petBreedImpl.address));
    });

    it("Set callable", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        await this.proxy.setCallable(this.petBreedImpl.address, { from: proxyOwner });
        const version = await Version.at(await this.petImpl.getVersion());
        const { logs } = await this.proxy.setCallableById(await version.getId(), { from: proxyOwner });
        expectEvent.inLogs(logs, "UpgradedCallable", {
            fromCallable: this.petBreedImpl.address,
            toCallable: this.petImpl.address, 
        });
        const current = await this.proxy.getCallable({ from: proxyOwner });
        expect(web3.utils.toChecksumAddress(current)).to.equal(web3.utils.toChecksumAddress(this.petImpl.address));
    });

    it("Set unknown callable", async () => {
        await this.proxy.setCallable(this.petImpl.address, { from: proxyOwner });
        await this.proxy.setCallable(this.petBreedImpl.address, { from: proxyOwner });
        const { logs } = await this.proxy.setCallableById(0, { from: proxyOwner });
        expectEvent.inLogs(logs, "NotUpgradedCallable", {
            callable: this.petBreedImpl.address,
        });
        const current = await this.proxy.getCallable({ from: proxyOwner });
        expect(web3.utils.toChecksumAddress(current)).to.equal(web3.utils.toChecksumAddress(this.petBreedImpl.address));
    });

});