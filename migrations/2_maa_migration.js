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
// Implementation
var OwnedUnstructuredProxy = artifacts.require("./OwnedUnstructuredProxy.sol");
var UnstructuredProxy = artifacts.require("./UnstructuredProxy.sol");
// Test Implementation
var Pet = artifacts.require("./tests/Pet.sol");
var PetBreed = artifacts.require("./tests/PetBreed.sol");
var ParityHack = artifacts.require("./tests/ParityHack.sol");

module.exports = function(deployer) {
    // Library
    deployer.deploy(AddressUtil);
    // Link
    deployer.link(AddressUtil, UnstructuredProxy);
    deployer.link(AddressUtil, OwnedUnstructuredProxy);
    deployer.link(AddressUtil, ParityHack);
    // Link Test
    deployer.link(AddressUtil, Pet);
    deployer.link(AddressUtil, PetBreed);
    // Implementation
    deployer.deploy(UnstructuredProxy);
    deployer.deploy(OwnedUnstructuredProxy);
    deployer.deploy(ParityHack);
    // Test 
    deployer.deploy(Pet);
    deployer.deploy(PetBreed);
};