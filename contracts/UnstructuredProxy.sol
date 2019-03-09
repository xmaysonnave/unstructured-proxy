/*
    Copyright 2019 Auroville Foundation, https://aurovillefoundation.org.in/

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/
pragma solidity ^0.5.5;

import "./IUnstructuredProxy.sol";
import "./AddressUtils.sol";

contract UnstructuredProxy is IUnstructuredProxy {
    string private constant version = "UnstructuredProxy.0.0.1";

    function getVersion() external pure returns (string memory _version) {
        return version;
    }

    // Address storage position of the current implementation
    bytes32 private constant implementationPosition = keccak256(
        "org.proxy.implementation.address"
    );

    // Owner Storage position of the contract
    bytes32 private constant proxyOwnerPosition = keccak256(
        "org.proxy.implementation.owner"
    );

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyProxyOwner() {
        require(msg.sender == getProxyOwner(), "Sender is not a Proxy Owner.");
        _;
    }

    /**
    * @dev the constructor sets owner
    */
    constructor() public {
        _setTransferProxyOwnership(msg.sender);
    }

    /**
     * @dev Allows the current owner to transfer ownership
     * @param _newOwner The address to transfer ownership to
     */
    function setTransferProxyOwnership(address _newOwner)
        public
        onlyProxyOwner
    {
        require(
            _newOwner != address(0),
            "Uninitialized address. New owner can't be assigned."
        );
        _setTransferProxyOwnership(_newOwner);
    }

    /**
     * @dev Allows the proxy owner to set the implementation
     * @param _implementation address of the new implementation
     */
    function setImplementation(address _implementation) public onlyProxyOwner {
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
     * @dev Tells the address of the owner
     * @return the address of the owner
     */
    function getProxyOwner() public view returns (address owner) {
        bytes32 position = proxyOwnerPosition;
        assembly {
            owner := sload(position)
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
    }

    /**
     * @dev Sets the address of the owner
     */
    function _setTransferProxyOwnership(address _newProxyOwner) internal {
        bytes32 position = proxyOwnerPosition;
        assembly {
            sstore(position, _newProxyOwner)
        }
    }
}
