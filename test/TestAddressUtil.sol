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

import "truffle/build/Assert.sol";

import "../contracts/utils/AddressUtil.sol";

contract TestAddressUtil {

    constructor() public {
        Assert.equal(AddressUtil.isConstructor(address(this)), true, "should be true");
    }

    function testIsContract() public {
        Assert.equal(AddressUtil.isContract(address(this)), true, "should be true");
    }

    function testIsNotContract() public {
        Assert.equal(AddressUtil.isContract(msg.sender), false, "should be false");
    }

    function testNotInConstructor() public {
        Assert.equal(AddressUtil.isConstructor(address(this)), false, "should be false");
    }

}
