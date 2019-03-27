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
pragma solidity ^0.5.5<0.7.0;

import "../ProxyCallable.sol";

contract Pet is ProxyCallable {

    Version private _version = new Version("Pet", "v0.0.1");
    string private _kind = "Undefined";
    string private _color = "Undefined";

    function getVersion() public returns (Version version) {
        version = _version;
    }

    function getKind() public view returns (string memory kind) {
        kind = _kind;
    }

    function setKind(string memory kind) public onlyOwner {
        require(bytes(kind).length != 0, "Kind is missing.");
        _kind = kind;
    }

    function getColor() public view returns (string memory color) {
        color = _color;
    }

    function setColor(string memory color) public onlyOwner {
        require(bytes(color).length != 0, "Color is missing.");
        _color = color;
    }

}
