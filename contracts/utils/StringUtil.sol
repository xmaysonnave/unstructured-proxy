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
pragma solidity ^0.5.5<0.6.0;

library StringUtil {
    function append(string memory a, string memory b, string memory c, string memory d, string memory e)
        public
        pure
        returns (string memory concat)
    {
        concat = string(abi.encodePacked(a, b, c, d, e));
    }

    function stringToAddress(string memory _a) public pure returns (address _address) {
        bytes memory tmp = bytes(_a);
        uint160 iaddr = 0;
        uint160 b1;
        uint160 b2;
        for (uint i = 2; i < 2 + 2 * 20; i += 2) {
            iaddr *= 256;
            b1 = uint160(uint8(tmp[i]));
            b2 = uint160(uint8(tmp[i + 1]));
            if ((b1 >= 97) && (b1 <= 102)) {
                b1 -= 87;
            } else if ((b1 >= 65) && (b1 <= 70)) {
                b1 -= 55;
            } else if ((b1 >= 48) && (b1 <= 57)) {
                b1 -= 48;
            }
            if ((b2 >= 97) && (b2 <= 102)) {
                b2 -= 87;
            } else if ((b2 >= 65) && (b2 <= 70)) {
                b2 -= 55;
            } else if ((b2 >= 48) && (b2 <= 57)) {
                b2 -= 48;
            }
            iaddr += (b1 * 16 + b2);
        }
        _address = address(iaddr);
    }

    /**
     * @dev Tells the address at the current position
     * @return contract address
     */
    function getAddress(bytes32 _position) public view returns (address _contract) {
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
    function setAddress(bytes32 _position, address _contract) public {
        require(_position != bytes32(0), "Uninitialized position");
        require(_contract != address(0), "Uninitialized contract");
        bytes32 position = _position;
        assembly {
            sstore(position, _contract)
        }
    }

}
