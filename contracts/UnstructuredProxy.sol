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

import "./IUnstructuredProxy.sol";
import "./AddressUtils.sol";

contract UnstructuredProxy is IUnstructuredProxy {
    string private constant version = "UnstructuredProxy.0.0.1";

    // Address storage position of the current implementation
    bytes32 private constant implementationPosition = keccak256(
        "org.proxy.implementation.address"
    );

    /**
     * @dev Set the implementation
     * @param _implementation address of the new implementation
     */
    function setImplementation(address _implementation) public {
        require(
            _implementation != address(0),
            "Uninitialized address. Implementation can't be assigned."
        );
        require(
            AddressUtils.isContract(_implementation) == false,
            "Not a contract but an Externally Owned Address (EOA). Implementation can't be assigned."
        );
        if (getImplementation() == address(0)) {
            _setImplementation(_implementation);
        } else {
            _upgradeImplementation(_implementation);
        }
    }

    /**
     * @dev Tells the address of the current implementation
     * @return address of the current implementation
     */
    function getImplementation() public view returns (address implementation) {
        bytes32 position = implementationPosition;
        assembly {
            implementation := sload(position)
        }
    }

    /**
     * @dev Sets the address of the current implementation
     * @param _newImplementation address of the new implementation
     */
    function _setImplementation(address _newImplementation) internal {
        bytes32 position = implementationPosition;
        assembly {
            sstore(position, _newImplementation)
        }
    }

    /**
     * @dev Upgrades the implementation address
     * @param _newImplementation address of the new implementation
     */
    function _upgradeImplementation(address _newImplementation) internal {
        address currentImplementation = getImplementation();
        require(
            currentImplementation != _newImplementation,
            "The new implementation can't be the current implementation."
        );
        _setImplementation(_newImplementation);
        emit Upgraded(_newImplementation);
    }

}
