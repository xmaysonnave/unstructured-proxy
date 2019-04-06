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

import "truffle/Assert.sol";

import "../contracts/ProxyManager.sol";
import "../contracts/ProxyCallable.sol";
import "../contracts/tests/Pet.sol";
import "../contracts/tests/PetBreed.sol";

contract TestProxyManager {

    ProxyManager private manager;
    Pet private pet;
    PetBreed private petBreed;

    constructor() public {
        manager = new ProxyManager();
        pet = new Pet();
        petBreed = new PetBreed();
        manager.add(pet);
        manager.add(petBreed);
    }

    function testUnknownCurrent() public {
        ProxyManager emtpyManager = new ProxyManager();
        ProxyCallable callable = emtpyManager.getCurrent();
        Assert.equal(address(callable), address(0), "not matching");
    }

    function testCurrent() public {
        ProxyCallable callable = manager.getCurrent();
        Assert.equal(address(callable), address(petBreed), "not matching");
    }

    function testSetPrevious() public {
        (ProxyCallable fromCallable, ProxyCallable toCallable) = manager.setPrevious();
        Assert.equal(address(fromCallable), address(petBreed), "not matching");
        Assert.equal(address(toCallable), address(pet), "not matching");
        ProxyCallable callable = manager.getCurrent();
        Assert.equal(address(callable), address(pet), "not matching");
    }

    function testLowerBound() public {
        manager.setPrevious();
        (ProxyCallable fromCallable, ProxyCallable toCallable) = manager.setPrevious();
        Assert.equal(address(fromCallable), address(pet), "not matching");
        Assert.equal(address(toCallable), address(0), "expecting address(0)");
        ProxyCallable callable = manager.getCurrent();
        Assert.equal(address(callable), address(pet), "not matching");
    }

    function testSetNext() public {
        manager.setPrevious();
        (ProxyCallable fromCallable, ProxyCallable toCallable) = manager.setNext();
        Assert.equal(address(fromCallable), address(pet), "not matching");
        Assert.equal(address(toCallable), address(petBreed), "not matching");
        ProxyCallable callable = manager.getCurrent();
        Assert.equal(address(callable), address(petBreed), "not matching");
    }

    function testUpperBound() public {
        (ProxyCallable fromCallable, ProxyCallable toCallable) = manager.setNext();
        Assert.equal(address(fromCallable), address(petBreed), "not matching");
        Assert.equal(address(toCallable), address(0), "expecting address(0)");
        ProxyCallable callable = manager.getCurrent();
        Assert.equal(address(callable), address(petBreed), "not matching");
    }

    function testSet() public {
        (ProxyCallable fromCallable, ProxyCallable toCallable) = manager.set(pet.getVersion().getId());
        Assert.equal(address(fromCallable), address(petBreed), "not matching");
        Assert.equal(address(toCallable), address(pet), "not matching");
        ProxyCallable callable = manager.getCurrent();
        Assert.equal(address(callable), address(pet), "not matching");
    }

    function testSetUnknown() public {
        (ProxyCallable fromCallable, ProxyCallable toCallable) = manager.set(uint(uint256(keccak256(abi.encode(block.difficulty, now)))));
        Assert.equal(address(fromCallable), address(pet), "not matching");
        Assert.equal(address(toCallable), address(0), "not matching");
        ProxyCallable callable = manager.getCurrent();
        Assert.equal(address(callable), address(pet), "not matching");
    }

}