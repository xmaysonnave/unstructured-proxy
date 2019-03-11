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
pragma solidity ^0.5.5;

import "./IPetRace.sol";
import "./Pet.sol";

contract PetRace is Pet, IPetRace {
    string private constant version = "PetRace.0.0.1";

    string internal race;

    constructor(string memory _kind, string memory _race) public Pet(_kind) {
        require(bytes(_race).length != 0, "Race is missing.");
        race = _race;
    }

    function getRace() external view returns (string memory _race) {
        return race;
    }

}
