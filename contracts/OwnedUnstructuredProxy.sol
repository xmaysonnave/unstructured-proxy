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
pragma solidity ^0.5.5<0.7.0;

import "./ProxyVersionManager.sol";
import "./UnstructuredProxy.sol";

contract OwnedUnstructuredProxy is UnstructuredProxy {
    /**
     *  Proxy Owner Storage position
     */
    bytes32 private constant _owner = keccak256("org.maatech.proxy.owner");

    event ProxyOwnershipTransferred(address indexed previousProxyOwner, address indexed newProxyOwner);

    /**
     *  Contract Manager position
     */
    bytes32 private constant _manager = keccak256("org.maatech.proxy.manager");

    /**
     * @dev Throws if called by any account other than the proxy owner.
     */
    modifier onlyProxyOwner() {
        require(_isProxyOwner(), "onlyProxyOwner");
        _;
    }

    constructor() public Proxy() {
        _setAddress(_manager, address(new ProxyVersionManager(this)));
        _setTransferProxyOwnership(msg.sender);
    }

    function _getVersion() internal returns (Version version) {
        version = new Version("OwnedUnstructuredProxy", "v0.0.1");
    }

    /**
     * @dev Tells the address of the current version
     * @return address of the current version
     */
    function getProxyVersionManager() public view returns (address manager) {
        manager = _getAddress(_manager);
    }

    /**
     * @dev Set the implementation
     * @param toCallable proxy delegate implemenation
     */
    function setProxyCallable(ProxyCallable toCallable) public onlyProxyOwner {
        super.setProxyCallable(toCallable);
        address proxyOwner = getProxyOwner();
        // call our fallback function to delegatecall initialize to set our owner
        (bool result, ) = address(this).call(abi.encodeWithSignature("initialize(address)", proxyOwner, proxyOwner));
        require(result, "Failed to initialize");
        ProxyVersionManager(getProxyVersionManager()).addCallable(toCallable);
    }

    /**
     * @dev Tells the address of the owner
     * @return the address of the owner
     */
    function getProxyOwner() public view returns (address proxyOwner) {
        proxyOwner = _getAddress(_owner);
    }

    /**
     * @dev Sets the address of the proxy owner
     */
    function setProxyOwner(address newProxyOwner) internal {
        _setTransferProxyOwnership(newProxyOwner);
    }

    /**
     * @return true if `msg.sender` is the proxy owner of the contract.
     */
    function _isProxyOwner() internal view returns (bool) {
        return msg.sender == _getAddress(_owner);
    }

    /**
     * @dev Allows the current proxy owner to transfer control of the contract to a newOwner.
     * @param newProxyOwner The address to transfer ownership to.
     */
    function setTransferProxyOwnership(address newProxyOwner) public onlyProxyOwner {
        _setTransferProxyOwnership(newProxyOwner);
    }

    /**
     * @dev Transfers control of the contract to a newProxyOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _setTransferProxyOwnership(address newOwner) internal {
        require(newOwner != address(0), "Uninitialized address");
        require(newOwner != getProxyOwner(), "The new proxy owner can't be the current proxy owner.");
        emit ProxyOwnershipTransferred(getProxyOwner(), newOwner);
        _setAddress(_owner, newOwner);
    }

}
