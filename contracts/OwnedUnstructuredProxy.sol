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

import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./UnstructuredProxy.sol";

contract OwnedUnstructuredProxy is UnstructuredProxy {

    /**
     *  Proxy Owner Storage position
     */
    bytes32 private constant _proxyOwnerPosition = keccak256("org.maatech.proxy.owner");

    event ProxyOwnershipTransferred(address indexed previousProxyOwner, address indexed newProxyOwner);

    /**
     * @dev Throws if called by any account other than the proxy owner.
     */
    modifier onlyProxyOwner() {
        require(isProxyOwner(), "onlyProxyOwner");
        _;
    }

    constructor() public {
        _setTransferProxyOwnership(msg.sender);
    }    

    function _getVersion() internal returns (Version version) {
        version = new Version("OwnedUnstructuredProxy", "v0.0.1");
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
    function getProxyOwner() public view returns (address proxyOwner) {
        proxyOwner = AddressUtil.getAddress(_proxyOwnerPosition);
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
    function isProxyOwner() public view returns (bool) {
        return msg.sender == AddressUtil.getAddress(_proxyOwnerPosition);
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
     * @param newProxyOwner The address to transfer ownership to.
     */
    function _setTransferProxyOwnership(address newProxyOwner) internal {
        require(newProxyOwner != address(0), "Uninitialized address");
        require(newProxyOwner != getProxyOwner(), "The new proxy owner can't be the current proxy owner.");
        emit ProxyOwnershipTransferred(getProxyOwner(), newProxyOwner);
        AddressUtil.setAddress(_proxyOwnerPosition, newProxyOwner);
    }    

}
