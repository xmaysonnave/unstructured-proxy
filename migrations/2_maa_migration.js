/*
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/
// Library
var AddressUtil = artifacts.require("./utils/AddressUtil.sol");
var StringUtil = artifacts.require("./utils/StringUtil.sol");
// Contract
var OwnedUnstructuredProxy = artifacts.require("./OwnedUnstructuredProxy.sol");
var UnstructuredProxy = artifacts.require("./UnstructuredProxy.sol");
var ProxyManager = artifacts.require("./ProxyManager.sol");
// Test Contract
var Pet = artifacts.require("./tests/Pet.sol");
var PetBreed = artifacts.require("./tests/PetBreed.sol");
var ParityHack = artifacts.require("./tests/ParityHack.sol");

module.exports = function(deployer) {
    // Library
    deployer.deploy(AddressUtil);
    deployer.deploy(StringUtil);
    // Link Test
    deployer.link(AddressUtil, ParityHack);
    deployer.link(AddressUtil, UnstructuredProxy);
    deployer.link(AddressUtil, OwnedUnstructuredProxy);
    // Contract
    deployer.deploy(UnstructuredProxy);
    deployer.deploy(OwnedUnstructuredProxy);
    deployer.deploy(ProxyManager);
    // Test Contract
    deployer.deploy(Pet);
    deployer.deploy(PetBreed);
    deployer.deploy(ParityHack);
};