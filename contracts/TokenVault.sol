pragma solidity ^0.4.20;

import "./ERC20Interface.sol";

contract TokenValault {

    ERC20Interface public Contract;
    address beneficiary;

    modifier atStage(Stages _stage) {
        if(stage == _stage) _;
    }

    Stages public stage = Stages.initClaim;

    enum Stages {
        initClaim,
        firstRelease,
        secondRelease,
        thirdRelease,
        fourthRelease
    }

    function TokenValault(address _contractAddress) public {
        require(_contractAddress != address(0));
        Contract = ERC20Interface(_contractAddress); // what is this doing??????????????/
        beneficiary = msg.sender;
    }

    function checkBalance() public constant returns (uint256 tokenBalance) {
        return Contract.balanceOf(this);
    }

    function claim() external {
        require(msg.sender == beneficiary);
        //require(block.number > fundingEndBlock);
        uint256 balance = Contract.balanceOf(this);
        // in reverse order so stages changes don't carry within one claim
        //fourth_release(balance);
        //third_release(balance);
        //second_release(balance);
        //first_release(balance);
        init_claim(balance);
    }

    function init_claim(uint256 balance) private atStage(Stages.initClaim) {
        //firstRelease = now + 26 weeks; // assign 4 claiming times
        //secondRelease = firstRelease + 26 weeks;
        //thirdRelease = secondRelease + 26 weeks;
        //fourthRelease = thirdRelease + 26 weeks;
        uint256 amountToTransfer = safeMul(balance, 53846153846) / 100000000000;
        Contract.transfer(beneficiary, amountToTransfer); // now 46.153846154% tokens left
        //nextStage();
    }

    function safeMul(uint a, uint b) internal returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }
}