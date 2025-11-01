// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/access/AccessControl.sol';

contract Hoops is ERC20, AccessControl {
    // Role identifier for accounts that can mint new tokens
    bytes32 public constant MINTER_ROLE = keccak256('MINTER_ROLE');
    // Contract owner address
    address public owner;

    // Emitted when new tokens are minted
    event TokensMinted(address indexed to, uint256 amount);

    constructor() ERC20('HOOPS', 'HPS') {
        owner = msg.sender;
        // Mint initial supply of 10 billion tokens to the deployer
        _mint(owner, 10000000000 * (10 ** uint256(decimals())));
        // Grant admin and minter roles to the deployer
        _grantRole(DEFAULT_ADMIN_ROLE, owner);
        _grantRole(MINTER_ROLE, owner);
    }

    // Mints new tokens to the specified address
    // Only callable by accounts with MINTER_ROLE
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }
}