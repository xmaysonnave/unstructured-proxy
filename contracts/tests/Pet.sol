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
pragma solidity ^0.5.5 <0.6.0;

import "../../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract Pet is Ownable {

    bool internal _initialized;
    string internal _kind;
    string internal _color = "Undefined";

    constructor(string memory kind) public {
        require(bytes(kind).length != 0, "Kind is missing.");
        _kind = kind;
    }

    function getKind() public view returns (string memory kind) {
        kind = _kind;
    }

    function getColor() public view returns (string memory color) {
        color = _color;
    }    

    function setColor(string memory color) public {
        require(bytes(color).length != 0, "Color is missing.");
        _color = color;
    }    

}
