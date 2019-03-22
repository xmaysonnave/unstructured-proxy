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
pragma solidity ^0.5.5<0.6.0;

import "./Version.sol";
import "./utils/AddressUtil.sol";

contract ProxyVersion {
    /** 
     *  Proxy Version
     */
    bytes32 private constant _versionPosition = keccak256("org.maatech.proxy.version");

    function _getVersion() internal returns (Version version);

    function initialize() public {
        if (getVersion() == address(0)) {
            AddressUtil.setAddress(_versionPosition, address(_getVersion()));
        }
    }

    /**
     * @dev Tells the address of the current version
     * @return address of the current version
     */
    function getVersion() public view returns (address version) {
        version = AddressUtil.getAddress(_versionPosition);
    }

}
