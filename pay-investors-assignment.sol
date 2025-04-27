/* 
OK It is time for your first real deal coding from scratch DeFi assignment!
I hope you are ready - ready or not - it's time for us to dig in.

Your mission here is to build a smart contract given everything we've learnt up to this point that can 
add investor wallets to a decentralized bank and then allocate (pay) them funds. 

It may sound daunting, but if you go back through all the videos you will find all that you need to succeed in this.
(it's not as hard as it sounds - I promise)

Once you've completed the the smart contract, debugged, and compiled, go ahead and deploy the contract and test it out.
If it is successful you should be able to select different accounts from our test accounts and use the payInvestors functions
to send funds. Pay a few accounts some funds of your choose and when you're done run the checkInvestors testing function.
If your code is working not only should you have successful transaction, but the checkInvestors function should return to you how 
many investors wallets have been added to your bank! 

When you have completed the assignment post your code solution in the #smart-contracts channel in discord and share with the community.

If you get stuck take a break and ask the community for help! The more you ask questions and engage other coders the better you will become.

Exercise: 
1. Create a contract called AddressWallets which wraps around the function checkInvestors below.
2. Create an empty array of addresses which is payable called investorWallets
3. Write a libaray of keys and values nameed investors where the keys are addresses and the values are integers. 
4. Write a payable function called payInvestors which takes the parameters address and amount.
5. Write logic in the function so that it can add new wallets to investorWallets and fill them with amounts of your choosing. 
6. Combine the address link to the array and map to do this correctly.
7. Compile, deploy, and test your solution with the checkInvestors functions. 
8. Post your solution in the #smart-contracts channel in the discord.

Best of luck!!

Use the following steps as a guide.
*/
// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

library Investors {
    struct Map {
        address payable[] keys;
        mapping(address => uint256) data;
        mapping(address => bool) isAdded;
    }

    function addInvestors(
        Map storage self,
        address payable investor,
        uint256 amount
    ) internal {
        if (!self.isAdded[investor]) {
            require(amount > 0);
            self.keys.push(investor);
            self.isAdded[investor] = true;
        }

        self.data[investor] += amount;
    }

    function getAmount(Map storage self, address investor)
        internal
        view
        returns (uint256)
    {
        return self.data[investor];
    }

    function getInvestorCount(Map storage self)
        internal
        view
        returns (uint256)
    {
        return self.keys.length;
    }

    function getInvestorByIndex(Map storage self, uint256 index)
        public
        view
        returns (address payable)
    {
        require(index < self.keys.length, "Index out of bound");
        return self.keys[index];

    }
}

contract AddressWallets {
    using Investors for Investors.Map;
    Investors.Map private investors;

    constructor() payable {}

    address payable[] investorWallets;

    mapping(address => uint256) public investorAmounts;

    function payInvestors(address payable investor, uint256 amount)
        public
        payable
    {
        require(msg.value == amount, "Sent value must match the amount");
        require(investor != address(0), "Invalid investor address");

        investors.addInvestors(investor, amount);

        (bool success, ) = investor.call{value: amount}("");
        require(success, "Transfer failed");
    }

    function checkInvestors() public view returns (uint256) {
        return investors.getInvestorCount();
    }

    //     function getInvestor(unit index) public  view returns (address payable) {

    //                 return investors.getInvestorByIndex(index);

    // }
    function getInvestorAmount(address investor) public view returns (uint256) {
        return investors.getAmount(investor);
    }
}
