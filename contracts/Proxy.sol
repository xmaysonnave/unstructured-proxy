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

import "./ContractVersion.sol";

/**
 * @title Proxy
 * @dev Abstract Contract. Gives the possibility to delegate any call to a foreign implementation.
 */
contract Proxy is ContractVersion {

    /**
     * @dev Tells the Version name of the current contract
     * @return string the current version name
     */
    function getVersionName() public pure returns (string memory name) {
        name = getVersion().name;
    }

    /**
     * @dev Tells the Version tag of the current contract
     * @return string the current version tag
     */
    function getVersionTag() public pure returns (string memory tag) {
        tag = getVersion().tag;
    }

    /**
     *  @dev Tells the address of the implementation where every call will be delegated.
     *  @return address of the implementation to which it will be delegated
     */
    function getImplementation() public view returns (address _implementation);    

    /**
     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
     * This function will return whatever the implementation call returns
     */
    function() external payable {
        address _implementation = getImplementation();
        require(_implementation != address(0), "Uninitialized address. New owner can't be assigned.");

        assembly {
            let pointer := mload(0x40)
            calldatacopy(pointer, 0, calldatasize)
            let result := delegatecall(gas, _implementation, pointer, calldatasize, 0, 0)
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
