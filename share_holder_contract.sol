// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract EtherStock{
    struct shares {
        address sender;
        uint amount;
        bool isWithDraw;
    }

    mapping(address => shares) shareHolders;

    uint withDrawCount = 0;

    function inverstEthers() public payable returns(string memory){
        require(msg.value >= 1 ether, "Minimum 1 ether required");
        shareHolders[msg.sender] = shares(msg.sender, msg.value, false);
        return "Ether Transfer Successfully";
    }

    function withdrawEthers() public returns(string memory){
        require(shareHolders[msg.sender].amount != 0, "No amount to withdraw");
        require(withDrawCount < 3 , "Not allowed to withdraw now");
        require(!shareHolders[msg.sender].isWithDraw, "Amount is already withdrawed");

        uint amountPer = shareHolders[msg.sender].amount / 100;
        uint transferBalance = 0;
        if(withDrawCount == 0){
            transferBalance = amountPer * 90;
        }
        else if(withDrawCount == 1){
            transferBalance = amountPer * 80;
        }
        else if(withDrawCount == 2){
            transferBalance = amountPer * 70;
        }

        payable(msg.sender).transfer(transferBalance);
        shareHolders[msg.sender].isWithDraw = true;
        shareHolders[msg.sender].amount = 0;
        withDrawCount++;
        return "Ether Transfer Successfully";
    }

    function getBalance() public view returns(shares memory){
        return shareHolders[msg.sender];
    }

}