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

import "./Proxy.sol";
import "./utils/AddressUtil.sol";

contract UnstructuredProxy is Proxy {
    /** 
     *  Address storage position of the current implementation
     */
    bytes32 private constant _implementationPosition = keccak256("org.maatech.proxy.implementation");

    /**
    * @dev This event will be emitted the first time the implementation has been setup.
    * @param implementation represents the address of the first implementation
    */
    event InitialImplementation(address indexed implementation);

    /**
    * @dev This event will be emitted every time the implementation gets upgraded
    * @param fromImplementation represents the address of the previous implementation
    * @param toImplementation represents the address of the upgraded implementation
    */
    event UpgradedImplementation(address indexed fromImplementation, address indexed toImplementation);

    function _getVersion() internal returns (Version version) {
        version = new Version("UnstructuredProxy", "v0.0.1");
    }

    /**
     *  @dev Tells the address of the implementation where every call will be delegated.
     *  @return address of the implementation to which it will be delegated
     */
    function _getImplementation() internal view returns (address _implementation) {
        return _getAddress(_implementationPosition);
    }

    /**
     * @dev Set the implementation
     * @param _implementation address of the new implementation
     */
    function setImplementation(address _implementation) public {
        require(_implementation != address(0), "Uninitialized address. Implementation can't be assigned.");
        require(
            AddressUtil.isContract(_implementation) == true,
            "Not a contract but an Externally Owned Address (EOA). Contract can't be assigned."
        );        
        if (_getImplementation() == address(0)) {
            _setAddress(_implementationPosition, _implementation);
            emit InitialImplementation(_implementation);
        } else {
            _upgradeImplementation(_implementation);
        }
    }

    /**
     * @dev Upgrades the implementation
     * @param _toImplementation address of the upgraded implementation
     */
    function _upgradeImplementation(address _toImplementation) internal {
        address _fromImplementation = _getImplementation();
        require(
            _fromImplementation != _toImplementation,
            "The new implementation can't be the current implementation."
        );
        _setAddress(_implementationPosition, _toImplementation);
        emit UpgradedImplementation(_fromImplementation, _toImplementation);
    }

}
