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
import "./utils/AddressUtil.sol";

contract UnstructuredProxy is Proxy {
    /** 
     *  Address storage position of the current proxy callable
     */
    bytes32 private constant _callable = keccak256("org.maatech.proxy.callable");

    /**
    * @dev This event will be emitted every time the callable gets upgraded
    * @param fromCallable represents the address of the previous proxy callable
    * @param toCallable represents the address of the upgraded callable
    */
    event UpgradedCallable(address indexed fromCallable, address indexed toCallable);

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
     * @dev Set the proxy callable
     * @param toCallable proxy delegate callable
     */
    function setCallable(ProxyCallable toCallable) public {
        address _toCallable = address(toCallable);
        require(_toCallable != address(0), "can't be address zero");
        address _fromCallable = _getCallable();
        require(_fromCallable != _toCallable,  "can't be the same callable");
        require(AddressUtil.isContract(_toCallable), "not a contract");
        _setAddress(_callable, _toCallable);
        emit UpgradedCallable(_fromCallable, _toCallable);
    }

}
