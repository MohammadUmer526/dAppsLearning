// SPDX-License-Identifier: MIT
pragma solidity  >0.7.0 < 0.9.0;


contract multiplier {

    uint result;


    function set(uint x) public {
        result = x*5; 

    }

    function get() public view returns(uint) {
            return  result;
    }
}