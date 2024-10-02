// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

contract BankContract {

        struct AccountOwner {
        string name;
        uint256 balance;
        bool isCreated;
        }

    // The owner of the contract
    address public owner;

    // Mapping to keep track of both wehther the account exist and its user balances
    mapping(address => AccountOwner) private accounts;

    // Event to log deposits, withdrawals and transfer
    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    constructor() {
        // Set the transaction sender as the owner of the contract.
       owner = msg.sender;
    }

    // Modifier to check if the account exists
    modifier accountExists() {
        require(accounts[msg.sender].isCreated, "Account does not exist.");
        _;
    }

    // Function to create an account
    function createAccount(string memory _name) public {
        require(!accounts[msg.sender].isCreated, "Account already exists.");
        accounts[msg.sender] = AccountOwner (_name, 0, true);
    }

    // Payable function to deposit Ether into the account
    function deposit() public payable accountExists {
        require(msg.value > 0, "Deposit amount must be greater than zero.");
        accounts[msg.sender].balance += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Function to withdraw Ether from the account
    function withdraw(uint256 amount) public accountExists {
        require(amount <= accounts[msg.sender].balance, "Insufficient balance.");
        accounts[msg.sender].balance -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    // Function to transfer Ether to another address
    function transfer(address to, uint256 amount) public accountExists {
        require(accounts[to].isCreated, "Recipient account does not exist.");
        require(amount <= accounts[msg.sender].balance, "Insufficient balance.");
        require(to != msg.sender, "Cannot transfer to yourself.");

        accounts[msg.sender].balance -= amount;
        accounts[to].balance += amount;

        emit Transfer(msg.sender, to, amount);
    }

    // Function to check the balance of the caller's account
    function getBalance() public view accountExists returns (uint256) {
        return accounts[msg.sender].balance;
    }
}
