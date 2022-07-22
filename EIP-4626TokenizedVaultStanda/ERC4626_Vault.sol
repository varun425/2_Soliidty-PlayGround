// SPDX-License-Identifier: UNLICENSED
// @author: varunarya
// contact: varunp.b832@gmail.com

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC4626_Vault is ERC20 {
    IERC20 public depositToken;
    IERC20 public rewardToken;
    uint256 public totalShares;

    mapping(address => uint256) public depositAmout;

    constructor(IERC20 _depositToken, IERC20 _rewardToken)
        ERC20("rewardtoken", "rrt")
    {
        depositToken = _depositToken; // should only deposit this token
        rewardToken = _rewardToken;
    }

    function mintShares(uint256 shares) internal {
        totalShares += shares;
        _mint(msg.sender, shares);
    }

    function burnShares(uint256 shares) internal {
        totalShares -= shares;
        _burn(msg.sender, shares);
    }

    function deposit(uint amount) external {
        require(amount > 0, "zero value");
        depositAmout[msg.sender] += amount;
        IERC20(depositToken).transferFrom(msg.sender, address(this), amount);
        uint256 shares;
        if (totalShares == 0) {
            shares = amount;
        } else {
            shares = ((amount * totalShares) / getTotalVaultBal());
        }
        mintShares(shares);
    }

    function redeem(uint256 shares) external {
        require(shares > 0, "zero value");
        uint reward;
        if (totalShares == 0) {
            reward = shares;
        } else {
            reward = ((shares * getTotalVaultBal()) / totalShares);
        }
        depositAmout[msg.sender] = 0;
        burnShares(shares);
        IERC20(rewardToken).transfer(msg.sender, reward);
    }

    function withdraw(uint amount) external {
        require(amount <= depositAmout[msg.sender], "exceed");
        uint256 shares;
        if (totalShares == 0) {
            shares = amount;
        } else {
            shares = ((amount * totalShares) / getTotalVaultBal());
        }
        depositAmout[msg.sender] -= amount;
        burnShares(shares);
        IERC20(depositToken).transfer(msg.sender, amount);
    }

    function getTotalVaultBal() public view returns (uint256) {
        return IERC20(rewardToken).balanceOf(address(this));
    }
}
