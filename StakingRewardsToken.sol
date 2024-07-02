// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract StakingRewardsToken is ERC20, Ownable {
    using SafeMath for uint256;

    uint256 public rewardRate = 5; // 5% annual reward rate
    uint256 public stakingDuration = 30 days;
    
    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public stakingStartTime;
    mapping(address => uint256) public lastClaimedTime;
    mapping(address => uint256) public earnedRewards;

    event Staked(address indexed staker, uint256 amount);
    event Unstaked(address indexed staker, uint256 amount);
    event RewardClaimed(address indexed staker, uint256 amount);
    event RewardRateChanged(uint256 newRewardRate);
    event StakingDurationChanged(uint256 newStakingDuration);

    constructor(uint256 initialSupply) ERC20("StakingRewardsToken", "SRT") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply);
    }

    function stake(uint256 amount) public {
        require(amount > 0, "Staking amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Staking amount exceeds balance");

        _burn(msg.sender, amount);
        stakedBalance[msg.sender] = stakedBalance[msg.sender].add(amount);
        stakingStartTime[msg.sender] = block.timestamp;

        emit Staked(msg.sender, amount);
    }

    function unstake() public {
        require(stakedBalance[msg.sender] > 0, "No tokens staked");
        require(block.timestamp >= stakingStartTime[msg.sender].add(stakingDuration), "Staking period not yet over");

        uint256 amount = stakedBalance[msg.sender];
        uint256 reward = _pendingReward(msg.sender);

        stakedBalance[msg.sender] = 0;
        earnedRewards[msg.sender] = 0;
        _mint(msg.sender, amount.add(reward));

        emit Unstaked(msg.sender, amount);
    }

    function claimReward() public {
        uint256 reward = _pendingReward(msg.sender);
        earnedRewards[msg.sender] = 0;
        lastClaimedTime[msg.sender] = block.timestamp;

        _mint(msg.sender, reward);

        emit RewardClaimed(msg.sender, reward);
    }

    function _pendingReward(address _user) internal view returns (uint256) {
        if (stakedBalance[_user] == 0) {
            return 0;
        }

        uint256 timeDiff = block.timestamp.sub(lastClaimedTime[_user]);
        uint256 reward = stakedBalance[_user].mul(rewardRate).mul(timeDiff).div(365 days).div(100);

        return reward;
    }

    function setRewardRate(uint256 newRewardRate) external onlyOwner {
        require(newRewardRate > 0, "Reward rate must be greater than 0");
        rewardRate = newRewardRate;
        emit RewardRateChanged(newRewardRate);
    }

    function setStakingDuration(uint256 newStakingDuration) external onlyOwner {
        require(newStakingDuration > 0, "Staking duration must be greater than 0");
        stakingDuration = newStakingDuration;
        emit StakingDurationChanged(newStakingDuration);
    }
}
