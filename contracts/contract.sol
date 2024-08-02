// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PixiuWalletContract is ERC20, ERC20Pausable, Ownable {
    constructor(address initialOwner)
        ERC20("Pixiu Wallet Token", "PXXU")
        Ownable(initialOwner)
    {
        // Mint 1 million tokens to the initialOwner
        uint256 initialSupply = 1_000_000 * (10 ** decimals());
        _mint(initialOwner, initialSupply);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }
}
