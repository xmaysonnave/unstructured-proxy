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
pragma solidity ^0.5.5 <0.6.0;

import "./IUnstructuredProxy.sol";

/* interface */
contract IOwnedUnstructuredProxy is IUnstructuredProxy {
    string private constant version = "IOwnedUnstructuredProxy.0.0.1";

    /**
     * @dev Event to show ownership has been transferred
     * @param _previousOwner representing the address of the previous owner
     * @param _newOwner representing the address of the new owner
     */
    event ProxyOwnershipTransferred(address _previousOwner, address _newOwner);

    /**
     * @dev Allows the current owner to transfer ownership
     * @param _newOwner The address to transfer ownership to
     */
    function setTransferProxyOwnership(address _newOwner) public;

    /**
     * @dev Tells the address of the owner
     * @return the address of the owner
     */
    function getProxyOwner() public view returns (address _owner);

    /**
     * @dev Sets the address of the owner
     */
    function _setProxyOwnership(address _newProxyOwner) internal;

}
