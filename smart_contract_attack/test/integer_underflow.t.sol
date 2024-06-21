// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/integer_underflow";

contract VaultTest is Test {
    Vault public vault;

    address public user;

    function setUp() public {
        vault = new Vault();
        user = address(1);
    }

    function test_withdraw() public {
        vault.withdraw();
        assertEq(counter.number(), 1);
    }

    
}
