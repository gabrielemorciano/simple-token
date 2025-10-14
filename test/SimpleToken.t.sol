// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol"; // Imports Foundry’s test utilities
import "../src/SimpleToken.sol";

/**
 * @title SimpleToken Test Suite
 * @dev Comprehensive tests for SimpleToken contract
 */
contract SimpleTokenTest is Test {
    SimpleToken public token;
    
    address public owner;
    address public alice;
    address public bob;
    
    uint256 constant INITIAL_SUPPLY = 1000000 * 10**18; // 1 million tokens
    
    // ============ Setup ============
    
    // Foundry function that runs before each test, giving a clean environment every time
    function setUp() public {
        owner = address(this);
        alice = address(0x1);
        bob = address(0x2);
        
        token = new SimpleToken(INITIAL_SUPPLY);
    }
    
    // ============ Constructor Tests ============
    
    function testInitialSupply() view public {
        assertEq(token.totalSupply(), INITIAL_SUPPLY);  // Throws if a != b
    }
    
    function testOwnerBalance() view public {
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY);
    }
    
    function testTokenMetadata() view public {
        assertEq(token.name(), "SimpleToken");
        assertEq(token.symbol(), "STK");
        assertEq(token.decimals(), 18);
    }
    
    // ============ Transfer Tests ============
    
    function testTransfer() public {
        uint256 amount = 100 * 10**18;
        
        bool success = token.transfer(alice, amount);
        
        assertTrue(success);
        assertEq(token.balanceOf(alice), amount);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - amount);
    }
    
    function testTransferEmitsEvent() public {
        uint256 amount = 100 * 10**18;
        
        vm.expectEmit(true, true, false, true);
        emit SimpleToken.Transfer(owner, alice, amount);
        
        token.transfer(alice, amount);
    }
    
    function testTransferFailsInsufficientBalance() public {
        vm.prank(alice); // Next call from alice's address
        
        vm.expectRevert("Insufficient balance");
        token.transfer(bob, 1);
    }
    
    function testTransferFailsZeroAddress() public {
        vm.expectRevert("Cannot transfer to zero address");
        token.transfer(address(0), 100);
    }
    
    // ============ Approve Tests ============
    
    function testApprove() public {
        uint256 amount = 100 * 10**18;
        
        bool success = token.approve(alice, amount);
        
        assertTrue(success);
        assertEq(token.allowance(owner, alice), amount);
    }
    
    function testApproveEmitsEvent() public {
        uint256 amount = 100 * 10**18;
        
        vm.expectEmit(true, true, false, true);
        emit SimpleToken.Approval(owner, alice, amount);
        
        token.approve(alice, amount);
    }
    
    function testApproveFailsZeroAddress() public {
        vm.expectRevert("Cannot approve zero address");
        token.approve(address(0), 100);
    }
    
    // ============ TransferFrom Tests ============
    
    function testTransferFrom() public {
        uint256 amount = 100 * 10**18;
        
        // Owner approves alice to spend
        token.approve(alice, amount);
        
        // Alice transfers from owner to bob
        vm.prank(alice);
        bool success = token.transferFrom(owner, bob, amount);
        
        assertTrue(success);
        assertEq(token.balanceOf(bob), amount);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - amount);
        assertEq(token.allowance(owner, alice), 0);
    }
    
    function testTransferFromFailsInsufficientAllowance() public {
        uint256 amount = 100 * 10**18;
        
        // Owner approves only 50
        token.approve(alice, amount / 2);
        
        // Alice tries to transfer 100 (should fail)
        vm.prank(alice);
        vm.expectRevert("Insufficient allowance");
        token.transferFrom(owner, bob, amount);
    }
    
    function testTransferFromFailsInsufficientBalance() public {
        // Alice approves bob to spend (but alice has 0 balance)
        vm.prank(alice);
        token.approve(bob, 100);
        
        // Bob tries to transfer 
        vm.prank(bob);
        vm.expectRevert("Insufficient balance");
        token.transferFrom(alice, owner, 100);
    }
    
    // ============ Mint Tests ============
    
    function testMint() public {
        uint256 amount = 500 * 10**18;
        uint256 supplyBefore = token.totalSupply();
        
        token.mint(alice, amount);
        
        assertEq(token.balanceOf(alice), amount);
        assertEq(token.totalSupply(), supplyBefore + amount);
    }
    
    function testMintEmitsEvents() public {
        uint256 amount = 500 * 10**18;
        
        vm.expectEmit(true, false, false, true);
        emit SimpleToken.Mint(alice, amount);
        
        vm.expectEmit(true, true, false, true);
        emit SimpleToken.Transfer(address(0), alice, amount);
        
        token.mint(alice, amount);
    }
    
    function testMintFailsNotOwner() public {
        vm.prank(alice);
        vm.expectRevert("Only owner can call this function");
        token.mint(bob, 100);
    }
    
    function testMintFailsZeroAddress() public {
        vm.expectRevert("Cannot mint to zero address");
        token.mint(address(0), 100);
    }
    
    // ============ Burn Tests ============
    
    function testBurn() public {
        uint256 amount = 100 * 10**18;
        uint256 balanceBefore = token.balanceOf(owner);
        uint256 supplyBefore = token.totalSupply();
        
        token.burn(amount);
        
        assertEq(token.balanceOf(owner), balanceBefore - amount);
        assertEq(token.totalSupply(), supplyBefore - amount);
    }
    
    function testBurnEmitsEvents() public {
        uint256 amount = 100 * 10**18;
        
        vm.expectEmit(true, false, false, true);
        emit SimpleToken.Burn(owner, amount);
        
        vm.expectEmit(true, true, false, true);
        emit SimpleToken.Transfer(owner, address(0), amount);
        
        token.burn(amount);
    }
    
    function testBurnFailsInsufficientBalance() public {
        vm.prank(alice); // Alice has 0 balance
        
        vm.expectRevert("Insufficient balance to burn");
        token.burn(1);
    }
    
    // ============ Fuzz Tests ============
    
    function testFuzzTransfer(address to, uint256 amount) public {
        // Bound inputs to valid range
        vm.assume(to != address(0));    // Discards invalid test cases
        vm.assume(amount <= INITIAL_SUPPLY);
        
        token.transfer(to, amount);
        
        assertEq(token.balanceOf(to), amount);
    }
    
    function testFuzzMint(address to, uint256 amount) public {
        vm.assume(to != address(0));
        vm.assume(amount < type(uint256).max - token.totalSupply());
        
        uint256 supplyBefore = token.totalSupply();
        token.mint(to, amount);
        
        assertEq(token.totalSupply(), supplyBefore + amount);
    }
}