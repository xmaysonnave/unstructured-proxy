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

/* interface */
contract IUnstructuredProxy {

    function getVersion() external pure returns (string memory _version);

    /**
     * @dev Allows the current owner to transfer ownership
     * @param _newOwner The address to transfer ownership to
     */
    function setTransferProxyOwnership(address _newOwner) public;

    /**
     * @dev Allows the proxy owner to set the implementation
     * @param _implementation address of the new implementation
     */
    function setImplementation(address _implementation) public;

    /**
     * @dev Tells the address of the current implementation
     * @return address of the current implementation
     */
    function getImplementation() public view returns (address implementation);

    /**
     * @dev Tells the address of the owner
     * @return the address of the owner
     */
    function getProxyOwner() public view returns (address owner);

    /**
     * @dev Sets the address of the current implementation
     * @param _newImplementation address of the new implementation
     */
    function _setImplementation(address _newImplementation) internal;

    /**
     * @dev Upgrades the implementation address
     * @param _newImplementation address of the new implementation
     */
    function _upgradeImplementation(address _newImplementation) internal;

    /**
     * @dev Sets the address of the owner
     */
    function _setTransferProxyOwnership(address _newProxyOwner) internal;

}
