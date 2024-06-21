// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/integer_underflow.sol";

contract VaultTest is Test {
    Vault public vault;

    address public user1;
    address public user2;

    function setUp() public {
        vault = new Vault();
        user1 = address(1);
        user2 = address(2);

        vm.deal(user1, 10 ether);
        vm.deal(user2, 20 ether);
    }

    function test_Deposit() public {
        vm.startPrank(user1);

        uint256 depositAmount = 5 ether;
        
        vault.deposit{value: depositAmount}();

        assertEq(vault.getUserBalance(user1), depositAmount);
        assertEq(vault.getEthBalance(), depositAmount);

        vm.stopPrank();
    }
    
    function test_withdraw() public {

        vm.startPrank(user1);
        uint256 depositAmount = 5 ether;
        
        vault.deposit{value: depositAmount}();


        uint256 withDrawAmount = 3 ether;
        (bool success,) = address(vault).call(abi.encodeWithSignature("withdraw(uint256)", withDrawAmount));
        
        assertTrue(success, "withdrawal should succeed");

        assertEq(vault.getUserBalance(user1), depositAmount - withDrawAmount);
        assertEq(vault.getEthBalance(), depositAmount - withDrawAmount);

        vm.stopPrank();
    }

    function test_checkUnderFlow() public {

        vm.startPrank(user1);
        uint256 depositAmount1 = 5 ether;
        vault.deposit{value: depositAmount1}();

        vm.stopPrank();

        vm.startPrank(user2);
        uint256 depositAmount2 = 8 ether;
        vault.deposit{value: depositAmount2}();

        vm.stopPrank();

        vm.startPrank(user1);
        uint256 withDrawAmount = 13 ether;
        (bool success,) = address(vault).call(abi.encodeWithSignature("withdraw(uint256)", withDrawAmount));
        
        assertTrue(success, "underderflow");

        assertEq(vault.getUserBalance(user1), withDrawAmount);
        assertEq(vault.getEthBalance(), withDrawAmount);

        vm.stopPrank();
    }


    
}
