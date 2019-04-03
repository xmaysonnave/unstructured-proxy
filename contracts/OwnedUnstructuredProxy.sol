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

import "./ProxyManager.sol";
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
     * @dev Require if called by any account other than the proxy owner.
     */
    modifier onlyProxyOwner() {
        require(_isProxyOwner());
        _;
    }

    constructor() public {
        _setAddress(_manager, address(new ProxyManager()));
        _setTransferProxyOwnership(msg.sender);
    }

    function _getVersion() internal returns (Version version) {
        version = new Version("OwnedUnstructuredProxy", "v0.0.1");
    }

    function setPreviousProxyCallable() public onlyProxyOwner {
        (ProxyCallable fromCallable, ProxyCallable toCallable) = ProxyManager(getProxyManager()).setPrevious();
        if (toCallable != ProxyCallable(0)) {
            emit UpgradedProxyCallable(address(fromCallable), address(toCallable));
        }
    }

    function setNextProxyCallable() public onlyProxyOwner {
        (ProxyCallable fromCallable, ProxyCallable toCallable) = ProxyManager(getProxyManager()).setNext();
        if (toCallable != ProxyCallable(0)) {
            emit UpgradedProxyCallable(address(fromCallable), address(toCallable));
        }
    }

    function getCurrentProxyCallable() public view onlyProxyOwner returns (ProxyCallable callable) {
        callable = ProxyManager(getProxyManager()).getCurrent();
    }

    /**
     * @dev Tells the address of the current version
     * @return address of the current version
     */
    function getProxyManager() public view onlyProxyOwner returns (address manager) {
        manager = _getAddress(_manager);
    }

    /**
     * @dev Set the Proxy Callable
     * @param toCallable proxy callable delegate
     */
    function setProxyCallable(ProxyCallable toCallable) public onlyProxyOwner {
        super.setProxyCallable(toCallable);
        address proxyOwner = getProxyOwner();
        // call fallback to delegatecall initialize and set owner
        (bool success, ) = address(this).call(
            abi.encodeWithSignature("initialize(address)", proxyOwner, proxyOwner)
        );
        require(success);
        ProxyManager(getProxyManager()).add(toCallable);
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
     * @return true if msg.sender is the proxy owner of the contract.
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
        require(newOwner != address(0));
        require(newOwner != getProxyOwner());
        emit ProxyOwnershipTransferred(getProxyOwner(), newOwner);
        _setAddress(_owner, newOwner);
    }

}
