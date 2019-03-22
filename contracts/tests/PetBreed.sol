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

import "./Pet.sol";

contract PetBreed is Pet {
    string internal _breed = "Undefined";

    constructor(string memory kind, string memory breed) public Pet(kind) {
        require(bytes(breed).length != 0, "Breed is missing.");
        _breed = breed;
    }

    function getBreed() external view returns (string memory breed) {
        breed = _breed;
    }

    function setBreed(string memory breed) public {
        require(bytes(breed).length != 0, "Breed is missing.");
        _breed = breed;
    }

}
