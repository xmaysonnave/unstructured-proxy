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

import "./Proxy.sol";
import "./ProxyCallable.sol";

contract UnstructuredProxy is Proxy {
    /** 
     *  Address storage position of the current proxy callable
     */
    bytes32 private constant _callable = keccak256("org.maatech.proxy.callable");

    /**
    * @dev This event will be emitted every time the proxy callable gets upgraded
    * @param fromCallable represents the address of the previous proxy callable
    * @param toCallable represents the address of the upgraded roy callable
    */
    event UpgradedProxyCallable(address indexed fromCallable, address indexed toCallable);

    function _getVersion() internal returns (Version version) {
        version = new Version("UnstructuredProxy", "v0.0.1");
    }

    /**
     *  @dev Tells the address of the callable where every call will be delegated.
     *  @return address of the callable to which it will be delegated
     */
    function _getCallable() internal view returns (address callable) {
        callable = _getAddress(_callable);
    }

    /**
     * @dev Set the implementation
     * @param toCallable proxy delegate callable
     */
    function setProxyCallable(ProxyCallable toCallable) public {
        address _toCallable = address(toCallable);
        require(_toCallable != address(0));
        address _fromCallable = _getCallable();
        require(_fromCallable != _toCallable);
        emit UpgradedProxyCallable(_fromCallable, _toCallable);
        _setAddress(_callable, _toCallable);
    }

}
