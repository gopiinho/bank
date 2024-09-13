// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BankVault is Ownable {
    error Bank__TransferFailed();

    constructor() Ownable(msg.sender) { }

    function transferFromUser(address assetAddress, uint256 assetAmount, address user) public onlyOwner {
        bool success = IERC20(assetAddress).transferFrom(user, address(this), assetAmount);
        if (!success) {
            revert Bank__TransferFailed();
        }
    }

    function transferToUser(address assetAddress, uint256 assetAmount, address user) public onlyOwner {
        bool success = IERC20(assetAddress).transferFrom(address(this), user, assetAmount);
        if (!success) {
            revert Bank__TransferFailed();
        }
    }
}
