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

    /**
     * @dev Tells the address at the current position
     * @return contract address
     */
    function getAddress(bytes32 _position) public view returns (address _contract) {
        bytes32 position = _position;
        assembly {
            _contract := sload(position)
        }
    }

    /**
     * @dev Sets the address of the current implementation
     * @param _position storage position
     * @param _contract contract address
     */
    function setAddress(bytes32 _position, address _contract) public {
        require(_position != bytes32(0), "Uninitialized position");
        require(_contract != address(0), "Uninitialized contract");
        bytes32 position = _position;
        assembly {
            sstore(position, _contract)
        }
    }

}
