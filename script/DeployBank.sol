// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Script } from "forge-std/Script.sol";
import { Bank } from "../src/Bank.sol";
import { BankVault } from "../src/BankVault.sol";

contract DeployBank is Script {
    function run() external returns (Bank, BankVault) {
        vm.startBroadcast();
        Bank bank = new Bank();
        BankVault vault = bank.getBankVault();
        vm.stopBroadcast();

        return (bank, vault);
    }
}
