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

import "./UnstructuredProxy.sol";

contract OwnedUnstructuredProxy is UnstructuredProxy {
    /**
     * @dev Event to show ownership has been transferred
     * @param previousOwner representing the address of the previous owner
     * @param newOwner representing the address of the new owner
     */
    event ProxyOwnershipTransferred(address previousOwner, address newOwner);

    /** 
     *  Owner Storage position of the contract
     */
    bytes32 private constant _ownerposition = keccak256("org.maatech.proxy.implementation.owner");

    function _getVersion() internal returns (Version version) {
        version = new Version("OwnedUnstructuredProxy", "v0.0.1");
    }

    constructor () public {
        _setProxyOwnership(msg.sender);
    }

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyProxyOwner() {
        require(msg.sender == getProxyOwner(), "Sender is not a Proxy Owner.");
        _;
    }

    function initialize() public onlyProxyOwner {
        super.initialize();
    }

    /**
     * @dev Allows the current owner to transfer ownership
     * @param _newOwner The address to transfer ownership to
     */
    function setTransferProxyOwnership(address _newOwner) public onlyProxyOwner {
        require(_newOwner != address(0), "Uninitialized address. New owner can't be assigned.");
        address _owner = getProxyOwner();
        require(_owner != _newOwner, "The new proxy owner can't be the current proxy owner.");
        emit ProxyOwnershipTransferred(_owner, _newOwner);
        _setProxyOwnership(_newOwner);
    }

    /**
     * @dev Allows the proxy owner to set the implementation
     * @param _implementation address of the new implementation
     */
    function setImplementation(address _implementation) public onlyProxyOwner {
        super.setImplementation(_implementation);
    }

    /**
     * @dev Tells the address of the owner
     * @return the address of the owner
     */
    function getProxyOwner() public view returns (address _owner) {
        return _getAddress(_ownerposition);
    }

    /**
     * @dev Sets the address of the owner
     */
    function _setProxyOwnership(address _newProxyOwner) private {
        _setAddress(_ownerposition, _newProxyOwner);
    }

}
