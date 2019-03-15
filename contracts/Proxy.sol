/**
 *   Copyright (c) 2018 zOS Global Limited.
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

import "./ContractVersion.sol";

/**
 * @title Proxy
 * @dev Abstract Contract. Gives the possibility to delegate any call to a foreign implementation.
 */
contract Proxy is ContractVersion {
    /**
     *  @dev Tells the address of the implementation where every call will be delegated.
     *  @return address of the implementation to which it will be delegated
     */
    function getImplementation() public view returns (address _implementation);

    /**
     * @dev Tells the Version name of the current contract
     * @return string the current version name
     */
    function getVersionName() public pure returns (string memory name) {
        name = getVersion().name;
    }

    /**
     * @dev Tells the Version tag of the current contract
     * @return string the current version tag
     */
    function getVersionTag() public pure returns (string memory tag) {
        tag = getVersion().tag;
    }

}
