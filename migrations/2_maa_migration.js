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
var Proxy = artifacts.require("./Proxy.sol");
var StringUtils = artifacts.require("./StringUtils.sol");
var userRecords = artifacts.require("./userRecords.sol");

module.exports = function(deployer) {
    deployer.deploy(Proxy);
    deployer.deploy(StringUtils);
    deployer.link(StringUtils, userRecords);
    deployer.deploy(userRecords);
};