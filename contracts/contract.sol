
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";

contract PixiuWalletContract is ERC20Pausable {
    // Address with the permission to pause, unpause, and mint tokens
    address private pauser;

    // Modifier to allow only the pauser to execute certain functions
    modifier onlyPauser() {
        require(msg.sender == pauser, "Not the pauser");
        _;
    }

    // Constructor to initialize the token with an initial supply and pauser
    constructor(uint256 initialSupply, address initialPauser) ERC20("Pixiu Wallet Token", "PXXU") {
        _mint(msg.sender, initialSupply);
        pauser = initialPauser;
    }

    /// @dev Mint new tokens. Only the pauser can call this function.
    /// @param to The address to which the newly minted tokens will be sent.
    /// @param amount The number of tokens to be minted.
    function mint(address to, uint256 amount) public onlyPauser {
        _mint(to, amount);
    }

    /// @dev Pause the contract. Only the pauser can call this function.
    function pause() public onlyPauser {
        _pause();
    }

    /// @dev Unpause the contract. Only the pauser can call this function.
    function unpause() public onlyPauser {
        _unpause();
    }

    /// @dev Override the _update function to include pausable functionality.
    function _update(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20Pausable) {
        super._update(from, to, amount); // Correctly calls parent implementations
    }

    /// @dev Function to change the pauser, callable only by the current pauser.
    /// @param newPauser The address of the new pauser.
    function setPauser(address newPauser) public onlyPauser {
        require(newPauser != address(0), "Pauser cannot be zero address");
        pauser = newPauser;
    }

    /// @dev Function to get the current pauser.
    /// @return The address of the current pauser.
    function getPauser() public view returns (address) {
        return pauser;
    }
}
