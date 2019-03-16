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
import "./utils/Address.sol";

contract UnstructuredProxy is Proxy {
    // Address storage position of the current implementation
    bytes32 private constant implementationPosition = keccak256("org.maatech.proxy.implementation.address");

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

    function getVersion() internal pure returns (Version memory _version) {
        _version = Version({name: "UnstructuredProxy", tag: "v0.0.1"});
    }

    /**
     * @dev Set the implementation
     * @param _implementation address of the new implementation
     */
    function setImplementation(address _implementation) public {
        require(_implementation != address(0), "Uninitialized address. Implementation can't be assigned.");
        require(
            Address.isContract(_implementation) == true,
            "Not a contract but an Externally Owned Address (EOA). Implementation can't be assigned."
        );
        if (getImplementation() == address(0)) {
            _setImplementation(_implementation);
            emit InitialImplementation(_implementation);
        } else {
            _upgradeImplementation(_implementation);
        }
    }

    /**
     * @dev Tells the address of the current implementation
     * @return address of the current implementation
     */
    function getImplementation() public view returns (address _implementation) {
        bytes32 position = implementationPosition;
        assembly {
            _implementation := sload(position)
        }
    }

    /**
     * @dev Sets the address of the current implementation
     * @param _toImplementation address of the implementation
     */
    function _setImplementation(address _toImplementation) internal {
        bytes32 position = implementationPosition;
        assembly {
            sstore(position, _toImplementation)
        }
    }

    /**
     * @dev Upgrades the implementation
     * @param _toImplementation address of the upgraded implementation
     */
    function _upgradeImplementation(address _toImplementation) internal {
        address _fromImplementation = getImplementation();
        require(
            _fromImplementation != _toImplementation,
            "The new implementation can't be the current implementation."
        );
        _setImplementation(_toImplementation);
        emit UpgradedImplementation(_fromImplementation, _toImplementation);
    }

    /**
     * @dev Allows the proxy owner to call the implementation through a low level call.
     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
     * signature of the implementation to be called with the needed payload
     */
    function lowLevelCall(bytes memory data) public payable {
        require(getImplementation() != address(0), "Uninitialized implementation. Unable to low level call.");
        (bool result, ) = address(this).call(data);
        require(result, "Low level call failure.");
    }        

}
