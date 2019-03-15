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
// Implementation
var OwnedUnstructuredProxy = artifacts.require("./OwnedUnstructuredProxy.sol");
var UnstructuredProxy = artifacts.require("./UnstructuredProxy.sol");
// Library
var AddressUtils = artifacts.require("./utils/Address.sol");
// Test Implementation
var Pet = artifacts.require("./tests/Pet.sol");
var PetBreed = artifacts.require("./tests/PetBreed.sol");

module.exports = function(deployer) {
    // Library
    deployer.deploy(AddressUtils);
    // Implementation
    deployer.link(AddressUtils, UnstructuredProxy);
    deployer.deploy(UnstructuredProxy);
    deployer.link(AddressUtils, OwnedUnstructuredProxy);
    deployer.deploy(OwnedUnstructuredProxy);
    // Test Implementation 
    deployer.deploy(Pet, "Dog");
    deployer.deploy(Pet, "Cat");
    deployer.deploy(PetBreed, "Dog", "Labrador");
    deployer.deploy(PetBreed, "Cat", "Chartreux");
};