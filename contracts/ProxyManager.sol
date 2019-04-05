/**
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

import "./Ownable.sol";
import "./Proxy.sol";
import "./ProxyCallable.sol";

contract ProxyManager is Ownable {
    uint private _current;
    ProxyCallable[] private _callables;

    function add(ProxyCallable callable) public onlyOwner {
        _current = _callables.push(callable) - 1;
    }

    function setPrevious() public onlyOwner returns (ProxyCallable fromCallable, ProxyCallable toCallable) {
        fromCallable = getCurrent();
        toCallable = ProxyCallable(0);
        if (_current > 0) {
            toCallable = _callables[--_current];
        }
    }

    function setNext() public onlyOwner returns (ProxyCallable fromCallable, ProxyCallable toCallable) {
        fromCallable = getCurrent();
        toCallable = ProxyCallable(0);
        if (_current + 1 < _callables.length) {
            toCallable = _callables[++_current];
        }
    }

    function getCurrent() public onlyOwner view returns (ProxyCallable callable) {
        callable = ProxyCallable(0);
        if (_callables.length > 0) {
            callable = _callables[_current];
        }
    }

}
