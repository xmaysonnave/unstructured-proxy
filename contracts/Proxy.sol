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
pragma solidity >=0.5.5 <0.6.0;

import "./Version.sol";

/**
 * @title Proxy
 * @dev Abstract Contract. Gives the possibility to delegate any call to a foreign callable contract.
 */
contract Proxy {
    /** 
     *  Proxy Version
     */
    bytes32 private constant _version = keccak256("org.maatech.proxy.version");

    /**
     *  @dev Tells the address of the callable where every call will be delegated.
     *  @return address of the callable to which it will be delegated
     */
    function _getCallable() internal view returns (address callable);

    function _getVersion() internal returns (Version version);

    constructor() public {
        _setAddress(_version, address(_getVersion()));
    }

    /**
     * @dev Tells the address at the current position
     * @return contract address
     */
    function _getAddress(bytes32 _position) internal view returns (address _contract) {
        bytes32 position = _position;
        assembly {
            _contract := sload(position)
        }
    }

    /**
     * @dev Sets the address of the current implementation
     * @param _position storage position
     * @param _contract contract address
     */
    function _setAddress(bytes32 _position, address _contract) internal {
        require(_position != bytes32(0), "undefined position");
        require(_contract != address(0), "can't be address zero");
        bytes32 position = _position;
        assembly {
            sstore(position, _contract)
        }
    }

    /**
     * @dev Tells the address of the current version
     * @return address of the current version
     */
    function getVersion() public view returns (address version) {
        version = _getAddress(_version);
    }

    /**
     * @dev Fallback function.
     * Implemented entirely in _fallback.
     */
    function() external payable {
        _fallback();
    }

    /**
    * @dev fallback implementation.
    * Extracted to enable manual triggering.
    */
    function _fallback() internal {
        _delegate(_getCallable());
    }

    /**
     * @dev Fallback function allowing to perform a delegatecall to the given callable.
     * This function will return whatever the callable call returns
     */
    function _delegate(address callable) internal {
        require(callable != address(0), "can't be address zero");
        assembly { // solium-disable-line
            calldatacopy(0x0, 0x0, calldatasize)
            let result := delegatecall(sub(gas, 10000), callable, 0x0, calldatasize, 0, 0)
            let size := returndatasize
            returndatacopy(0, 0, size)
            switch result
                case 0 {
                    revert(0, size)
                }
                default {
                    return(0, size)
                }
        }
    }

}
