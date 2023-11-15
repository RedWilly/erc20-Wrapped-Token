// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/token/ERC20/utils/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/token/ERC20/IERC20.sol";

contract WrappedToken is ERC20 {
    using SafeERC20 for IERC20;

    IERC20 public immutable token;

    event Deposited(address indexed account, uint256 amount);
    event Withdrawn(address indexed account, uint256 amount);

    constructor(IERC20 underlyingToken) ERC20("Wrapped Token", "WTOKEN") {
        token = underlyingToken;
    }

    function deposit(uint256 amount) external {
        // Transfer tokens from the user to this contract
        token.safeTransferFrom(msg.sender, address(this), amount);

        // Mint WrappedToken to the user
        _mint(msg.sender, amount);

        // Emit a deposit event
        emit Deposited(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        // Burn WrappedToken from the user
        _burn(msg.sender, amount);

        // Transfer equivalent tokens to the user
        token.safeTransfer(msg.sender, amount);

        // Emit a withdrawal event
        emit Withdrawn(msg.sender, amount);
    }
}
