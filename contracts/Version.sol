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

contract Version {
    bytes32 private _id;
    string private _name;
    string private _tag;

    constructor (string memory name, string memory tag) public {
        require(bytes(name).length != 0, "Name is missing.");
        require(bytes(tag).length != 0, "Tag is missing.");
        _id = keccak256(abi.encode(name, tag));
        _name = name;
        _tag = tag;
    }

    function getId() public view returns (bytes32 id) {
        id = _id;
    }

    function getName() public view returns (string memory name) {
        name = _name;
    }

    function getTag() public view returns (string memory tag) {
        tag = _tag;
    }

}
