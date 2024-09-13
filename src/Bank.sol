// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { BankVault } from "./BankVault.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title Bank
 * @author https://github.com/gopiinho
 * @notice Main contract which controls the asset flows and internal accountings.
 * @notice This contract lets user deposits, lock, withdraw their ERC20 tokens, which are then sent to BankVault
 * contract. Only the original depositer of the assets is allowed to withdraw them.
 */
contract Bank is ReentrancyGuard {
    ///////////////
    /// Errors  ///
    ///////////////
    error Bank__MustBeMoreThanZero();
    error Bank__TransferFailed();

    ///////////////
    ///  Events ///
    ///////////////
    event AssetDeposited(address indexed user, address indexed assetAddress, uint256 indexed assetAmount);
    event AssetWithdrawn(address indexed user, address indexed assetAddress, uint256 indexed assetAmount);

    ///////////////////////
    /// State Variables ///
    ///////////////////////
    mapping(address user => mapping(address asset => uint256 amount)) public s_assetsDeposited;

    BankVault private immutable i_bankVault;

    ///////////////
    //  Modifier //
    ///////////////
    modifier moreThanZero(uint256 amount) {
        if (amount <= 0) {
            revert Bank__MustBeMoreThanZero();
        }
        _;
    }

    ///////////////
    // Functions //
    ///////////////
    constructor() {
        i_bankVault = new BankVault();
    }

    function deposit(address assetAddress, uint256 assetAmount) public moreThanZero(assetAmount) nonReentrant {
        s_assetsDeposited[msg.sender][assetAddress] += assetAmount;
        emit AssetDeposited(msg.sender, assetAddress, assetAmount);
        i_bankVault.transferFromUser(assetAddress, assetAmount, msg.sender);
    }

    function withdraw(address assetAddress, uint256 assetAmount) public moreThanZero(assetAmount) nonReentrant {
        s_assetsDeposited[msg.sender][assetAddress] -= assetAmount;
        emit AssetWithdrawn(msg.sender, assetAddress, assetAmount);
        i_bankVault.transferToUser(assetAddress, assetAmount, msg.sender);
    }

    function getBankVault() public view returns (BankVault) {
        return i_bankVault;
    }
}
