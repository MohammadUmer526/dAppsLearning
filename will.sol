// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Will {
    address owner;
    uint256 fortune;
    bool deceased;

    constructor()  payable {
        owner = msg.sender;
        fortune = msg.value;
        deceased = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier mustBeDeceased() {
        require(deceased == true);
        _;
    }

    // create an array to store the address
    address payable[] familyWallets;

    // create a map
    mapping(address => uint256) inheritance;

    function setInheritance(address payable wallet, uint256 amount) public {
        familyWallets.push(wallet);
        inheritance[wallet] = amount;
    }

    function payout() private mustBeDeceased {
        for (uint256 i = 0; i < familyWallets.length; i++) {
            familyWallets[i].transfer(inheritance[familyWallets[i]]);
        }
    }

    function hasDeceased() public onlyOwner {
        deceased = true;
        payout();
    }

    function revertDeceased() public onlyOwner {
        deceased = false;
        payout();
    }

    function resetInheritance(address wallet) public onlyOwner {
        inheritance[wallet] = 0;
    }

    function viewInheritance(address wallet) public view returns (uint256) {
        return inheritance[wallet];
    }
}
