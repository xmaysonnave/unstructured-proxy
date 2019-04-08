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
pragma solidity >=0.5.5 <0.6.0;

import "./Pet.sol";

contract PetBreed is Pet {
    Version private _version = new Version("PetBreed", "v0.0.1");
    string internal _breed = "undefined";

    function getVersion() public view returns (Version version) {
        version = _version;
    }

    function getBreed() public view returns (string memory breed) {
        breed = _breed;
    }

    function setBreed(string memory breed) public onlyOwner {
        require(bytes(breed).length != 0, "undefined breed");
        _breed = breed;
    }

}
