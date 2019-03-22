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

/**
 * @title ParityHack
 * @dev delegateCall to make a ParityHack attemtp
 */
contract ParityHack {

    address private _target;

    modifier isValid() {
        require(_target != address(0), "Uninitialized address. target cannot be called.");
        require(
            isContract(_target) == true,
            "Not a contract but an Externally Owned Address (EOA). Target cannot be assigned."
        );  
        _;
    }

    //Retrieve the size of the code on target address, assembly is needed.
    //If bytecode exists then the _address is a contract.
    //A contract does not have source code available during construction, its address return zero.
    function isContract(address _address) internal view returns (bool _isContract) {
        uint256 _size;
        assembly {
            _size := extcodesize(_address)
        }
        _isContract = _size > 0;
    }    

    function setTarget(address target) public {
        _target = target;
    }

    function getTarget() public returns (address target) {
        target = _target;
    }

    /**
     * @dev Fallback function allowing to perform a delegatecall to the given target.
     * This function will return whatever the target call returns
     */
    function() external payable isValid {
        address target = _target;
        assembly {
            let pointer := mload(0x40)
            calldatacopy(pointer, 0, calldatasize)
            let result := delegatecall(gas, target, pointer, calldatasize, 0, 0)
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
