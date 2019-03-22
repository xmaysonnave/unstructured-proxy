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

import "./ContractManager.sol";
import "./ProxyVersion.sol";
import "./Version.sol";

/**
 * @title Proxy
 * @dev Abstract Contract. Gives the possibility to delegate any call to a foreign implementation.
 */
contract Proxy is ProxyVersion {
    /** 
     *  Contract Manager position
     */
    bytes32 private constant _managerPosition = keccak256("org.maatech.proxy.implementation.manager");

    /**
     *  @dev Tells the address of the implementation where every call will be delegated.
     *  @return address of the implementation to which it will be delegated
     */
    function _getImplementation() internal view returns (address _implementation);

    /**
     * @dev Tells the address of the current version
     * @return address of the current version
     */
    function getManager() public view returns (address manager) {
        manager = _getAddress(_managerPosition);
    }

    /**
     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
     * This function will return whatever the implementation call returns
     */
    function() external payable {
        address implementation = _getImplementation();
        require(implementation != address(0), "Uninitialized address. Implementation cannot be called.");

        assembly {
            let pointer := mload(0x40)
            calldatacopy(pointer, 0, calldatasize)
            let result := delegatecall(gas, implementation, pointer, calldatasize, 0, 0)
            let size := returndatasize
            returndatacopy(pointer, 0, size)

            switch result
                case 0 {
                    revert(pointer, size)
                }
                default {
                    return(pointer, size)
                }
        }
    }

}
