// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract EtherStock{
    struct shares {
        address sender;
        uint amount;
        bool isWithDraw;
        uint timeStamp;
    }

    mapping(address => shares) shareHolders;

    uint withDrawCount = 0;

    function inverstEthers() public payable returns(string memory){
        require(msg.value >= 1 ether, "Minimum 1 ether required");
        shareHolders[msg.sender] = shares(msg.sender, msg.value, false, block.timestamp);
        return "Ether Transfer Successfully";
    }

    function withdrawEthers() public returns(string memory){
        uint oneMonthTime = 20;
        uint twoMonthTime = 30;
        uint transferBalance = 0;

        require(shareHolders[msg.sender].amount != 0, "No amount to withdraw");
        require(!shareHolders[msg.sender].isWithDraw, "Amount is already withdrawed");
        uint amountPer = shareHolders[msg.sender].amount / 100;

        if(block.timestamp - shareHolders[msg.sender].timeStamp <= oneMonthTime){
            transferBalance = shareHolders[msg.sender].amount + amountPer * 10;
        }
        else if(block.timestamp - shareHolders[msg.sender].timeStamp <= twoMonthTime){
            transferBalance = shareHolders[msg.sender].amount + amountPer * 20;
        }
        else{
            transferBalance = shareHolders[msg.sender].amount;
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