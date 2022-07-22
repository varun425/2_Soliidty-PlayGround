//SPDX-License-Identifier: NONE
// @author: varunarya
// contact: varunp.b832@gmail.com

pragma solidity ^0.8.0;

contract Eternal_Storage {
    mapping(bytes32 => uint[]) uintArrStorage;

    function setUintArr(bytes32 _selector, uint256[] memory arr) public {
        uintArrStorage[_selector] = arr;
    }

    function getUintArr(bytes32 _selector) public view returns (uint[] memory) {
        return uintArrStorage[_selector];
    }
}

library _fibonaci {
    function setUintArrForEternal(address _eternalStorage, uint[] memory _arr)
        external
    {
        Eternal_Storage(_eternalStorage).setUintArr(keccak256("FIBO"), _arr);
    }

    function getUintArrForEternal(address _eternalStorage)
        external
        view
        returns (uint[] memory)
    {
        return Eternal_Storage(_eternalStorage).getUintArr(keccak256("FIBO"));
    }

    function delUintArrForEternal(address _eternalStorage)
        external
        view
        returns (uint[] memory)
    {
        return Eternal_Storage(_eternalStorage).getUintArr(keccak256("FIBO"));
    }
}

contract fibonaci {
    using _fibonaci for address;
    address eternalStorage;

    constructor(address _eternalStorage) {
        eternalStorage = _eternalStorage;
    }

    uint[] getFibo = [0, 1];

    function callFibo(uint _len) external {
        //0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144,....
        for (uint i = 0; i < _len; i++) {
            uint first = getFibo[i];
            uint second = getFibo[i + 1];
            uint third = first + second;
            getFibo.push(third);
        }

        _fibonaci.setUintArrForEternal(eternalStorage, getFibo);
    }

    function get() public view returns (uint[] memory) {
        return _fibonaci.getUintArrForEternal(eternalStorage);
    }

    function cleanFibo() public view {
        _fibonaci.delUintArrForEternal(eternalStorage);
    }
}
