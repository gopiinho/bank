// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Test } from "forge-std/Test.sol";
import { console } from "forge-std/console.sol";
import { DeployBank } from "../../script/DeployBank.sol";
import { Bank } from "../../src/Bank.sol";
import { BankVault } from "../../src/BankVault.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract BankTest is Test {
    DeployBank deployer;
    Bank bank;
    BankVault vault;

    ERC20Mock public token;
    address public user = makeAddr("user");
    uint256 public constant TOKEN_AMOUNT_TO_MINT = 1000e18;

    function setUp() public {
        deployer = new DeployBank();
        (bank, vault) = deployer.run();

        token = new ERC20Mock();
        token.mint(user, TOKEN_AMOUNT_TO_MINT);
    }

    /////////////////////
    //  Deposit Tests  //
    /////////////////////
    modifier depositTokens() {
        vm.startPrank(user);
        token.approve(address(vault), TOKEN_AMOUNT_TO_MINT);
        bank.deposit(address(token), TOKEN_AMOUNT_TO_MINT);
        vm.stopPrank();
        _;
    }

    function testCanDepositTokens() public {
        vm.startPrank(user);
        token.approve(address(vault), TOKEN_AMOUNT_TO_MINT);
        bank.deposit(address(token), TOKEN_AMOUNT_TO_MINT);
        vm.stopPrank();

        assertEq(token.balanceOf(address(vault)), TOKEN_AMOUNT_TO_MINT);
    }

    function testCanWithdrawTokens() public depositTokens {
        uint256 amountToWithdraw = 50e18;
        vm.startPrank(user);
        bank.withdraw(address(token), amountToWithdraw);
        vm.stopPrank();

        assertEq(token.balanceOf(address(user)), amountToWithdraw);
    }

    function testOnlyDepositerCanWithdrawTokens() public depositTokens {
        uint256 amountToWithdraw = 50e18;
        address user2 = makeAddr("user2");
        uint256 startingVaultBalance = token.balanceOf(address(vault));
        vm.startPrank(user2);
        vm.expectRevert();
        bank.withdraw(address(token), amountToWithdraw);
        vm.stopPrank();

        uint256 endingVaultBalance = token.balanceOf(address(vault));
        assertEq(startingVaultBalance, endingVaultBalance);
    }

    function testWillRevertIfAmountIsZero() public {
        vm.startPrank(user);
        token.approve(address(vault), TOKEN_AMOUNT_TO_MINT);
        vm.expectRevert(Bank.Bank__MustBeMoreThanZero.selector);
        bank.deposit(address(token), 0);
        vm.stopPrank();
    }
}
