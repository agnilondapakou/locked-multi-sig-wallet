// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

contract LockedMultySigWallet {

    uint8 public totalApprove;
    mapping(address => uint256) public funds;
    mapping(address => bool) public approvals;
    mapping(address => bool) public owners;

    error NotOwner();
    error InvalidAddress();
    error InvalidAmount();
    error AlreadyApproved();
    error InsufficientApprovements();
    error UnactivatedOwner();

    modifier OnlyOwners {
        if(!owners[msg.sender]) revert NotOwner();
    }
    
    function deposit(uint256 amount) external returns (bool) OnlyOwners() {
        if(msg.sender == address(0)) revert InvalidAddress();
        if(amount <= 0) revert InvalidAmount();
        if(totalApprove < 3) revert InsufficientApprovements();
        if(owners[msg.sneder] == false) revert UnactivatedOwner();

        funds[msg.sender] += amount;
        return true
    }

    function approve() external returns (bool) OnlyOwners() {
        if(msg.sender == address(0)) revert InvalidAddress();
        if(approvals[msg.sender] == true) revert AlreadyApproved();
        if(owners[msg.sneder] == false) revert UnactivatedOwner();

        totalApprove++;
        approvals[msg.sender] = true;
        return true
    }

    function addOwner(address owner) external returns (bool) OnlyOwners() {
        if(msg.sender == address(0)) revert InvalidAddress();

        owners[owner] = true;
        return true;
    }

    function removeOwner(address owner) external returns (bool) OnlyOwners() {
        if(msg.sender == address(0)) revert InvalidAddress();

        owners[owner] = false;
        return true;
    }
}