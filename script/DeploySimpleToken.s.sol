// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SimpleToken.sol";

/**
 * @title Deploy SimpleToken
 * @dev Deployment script for SimpleToken contract
 */
contract DeploySimpleToken is Script {
    function run() external {
        // Get private key from environment
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy with 1 million initial supply
        uint256 initialSupply = 1000000 * 10**18;
        SimpleToken token = new SimpleToken(initialSupply);
        
        console.log("SimpleToken deployed to:", address(token));
        console.log("Initial supply:", token.totalSupply());
        console.log("Owner:", token.owner());
        
        vm.stopBroadcast();
    }
}