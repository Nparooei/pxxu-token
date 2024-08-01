// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PXXUToken is ERC20, ERC20Pausable, Ownable {
    constructor(uint256 initialSupply) ERC20("Pixiu", "PXXU") {
        _mint(msg.sender, initialSupply);
    }

    /// @dev Mint new tokens. Only the contract owner can call this function.
    /// @param to The address to which the newly minted tokens will be sent.
    /// @param amount The number of tokens to be minted.
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /// @dev Pause the contract. Only the contract owner can call this function.
    function pause() public onlyOwner {
        _pause();
    }

    /// @dev Unpause the contract. Only the contract owner can call this function.
    function unpause() public onlyOwner {
        _unpause();
    }

    /// @dev Override the _beforeTokenTransfer to include pausable functionality.
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }
}
