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

library AddressUtil {
    /**
     *  Retrieve the size of the code on target address, assembly is needed.
     *  If bytecode exists then the _address is a contract.
     *  A contract does not have source code available during construction, its address return zero.
     */
    function isContract(address _address) public view returns (bool _isContract) {
        uint256 _size;
        assembly {
            _size := extcodesize(_address)
        }
        _isContract = _size > 0;
    }

    /*
     *  @dev Returns true if the function is running in the constructor
     */
    function isConstructor(address method) public view returns (bool result) {
        uint256 size;
        assembly {
            size := extcodesize(method)
        }
        result = size == 0;
    }

}
