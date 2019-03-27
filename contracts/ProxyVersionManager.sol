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
pragma solidity ^0.5.5<0.7.0;

import "./Proxy.sol";
import "./Version.sol";

contract ProxyVersionManager {

    Version private _current;
    Version[] private _versions;
    Proxy private _proxy;

    mapping(uint => address) public versionToImplementation;

    constructor (Proxy proxy) public {
        _proxy = proxy;
    }

    function _addContractVersion(Version _version) internal {
        _versions.push(_version) - 1;
    }

    function getProxy() public view returns (Proxy proxy) {
        proxy = _proxy;
    }

}
