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
pragma solidity >=0.5.5 <0.6.0;

import "truffle/Assert.sol";

import "../contracts/utils/StringUtil.sol";

contract TestStringUtil {
    function testAppend() public {
        bytes32 test = keccak256(abi.encodePacked("aabbccddee"));
        Assert.equal(test == keccak256(StringUtil.append("aa", "bb", "cc", "dd", "ee")), true, "should be true");
    }

}
