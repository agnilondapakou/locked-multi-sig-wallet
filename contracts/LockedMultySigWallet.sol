// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

contract LockedMultySigWallet {

    
    mapping(address => bool) public owners;
    uint256 public transactionsCount;

    struct Transaction {
        address owner;
        uint256 lockTime;
        uint256 amount;
        bool isValidated;
        uint8 totalApprove;
        // mapping(address => bool) approvals;
    }

    mapping(uint256 => Transaction) public transactions;

    error NotOwner();
    error InvalidAddress();
    error InvalidAmount();
    error AlreadyApproved();
    error InsufficientApprovements();
    error UnactivatedOwner();
    error InvalidOwner();
    error TransactionIsLocked();

    modifier OnlyOwners() {
        require(owners[msg.sender] = true, "Only valid owner can performe this action.");
        _;
    }

    constructor() {
        owners[msg.sender] = true;
    }
    
    function deposit(uint256 amount) external OnlyOwners returns (bool) {
        if(msg.sender == address(0)) revert InvalidAddress();
        if(amount <= 0) revert InvalidAmount();
        if(owners[msg.sender] == false) revert UnactivatedOwner();

        Transaction memory transaction = Transaction(msg.sender, block.timestamp + 120, amount, false, 0);
        transactionsCount += 1;

        transactions[transactionsCount] = transaction;

        return true;
    }

    function approveTransaction(uint256 transactionId) external OnlyOwners returns (bool) {
        if(msg.sender == address(0)) revert InvalidOwner();
        if(transactions[transactionId].lockTime <= block.timestamp) revert TransactionIsLocked();
        
        transactions[transactionId].isValidated = true;

        return true;
    }

    function rejectTransaction(uint256 transactionId) external OnlyOwners returns (bool) {
        if(msg.sender == address(0)) revert InvalidOwner();
        if(transactions[transactionId].lockTime <= block.timestamp) revert TransactionIsLocked();
        
        transactions[transactionId].isValidated = false;
        
        return true;
    }

    function approveApproval(uint256 transactionId) external OnlyOwners returns (bool) {
        if(msg.sender == address(0)) revert InvalidOwner();
        if(transactions[transactionId].lockTime <= block.timestamp) revert TransactionIsLocked();
        if(owners[msg.sender] != true) revert InvalidOwner();

        transactions[transactionId].totalApprove++;

        return true;
    }

    function addOwner(address owner) external OnlyOwners returns (bool) {
        if(msg.sender == address(0)) revert InvalidAddress();

        owners[owner] = true;
        return true;
    }

    function removeOwner(address owner) external OnlyOwners returns (bool) {
        if(msg.sender == address(0)) revert InvalidAddress();

        owners[owner] = false;
        return true;
    }
}