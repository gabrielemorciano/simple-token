// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SimpleToken
 * @author Gabriele Morciano
 * @dev ERC20 Token implementation with mint and burn functionality
 * @notice This is a learning project implementing the ERC20 standard from scratch
 * 
 * Features:
 * - Standard ERC20 functionality (transfer, approve, transferFrom)
 * - Minting: owner can create new tokens
 * - Burning: anyone can burn their own tokens
 * - Total supply tracking
 * 
 * Security considerations:
 * - No integer overflow (Solidity 0.8+ built-in protection)
 * - Allowance pattern implemented correctly
 * - Events emitted for all state changes
*/
contract SimpleToken {
// ============ State Variables ============
string public name = "SimpleToken";
string public symbol = "STK";
uint8 public decimals = 18;
uint256 public totalSupply;

address public owner;

// Mapping of address to token balance
mapping(address => uint256) public balanceOf;

// Mapping of owner to spender to allowance amount
// allowance[owner][spender] = amount spender can spend on behalf of owner
mapping(address => mapping(address => uint256)) public allowance;

// ============ Events ============

event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(address indexed owner, address indexed spender, uint256 value);
event Mint(address indexed to, uint256 value);
event Burn(address indexed from, uint256 value);

// ============ Modifiers ============

modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
}

// ============ Constructor ============

constructor(uint256 _initialSupply) {
    owner = msg.sender;
    _mint(msg.sender, _initialSupply);
}

// ============ Public Functions ============

/**
 * @dev Transfer tokens from caller to recipient
 * @param _to Recipient address
 * @param _value Amount to transfer
 * @return success True if transfer succeeded
 */
function transfer(address _to, uint256 _value) public returns (bool success) {
    require(_to != address(0), "Cannot transfer to zero address");
    require(balanceOf[msg.sender] >= _value, "Insufficient balance");
    
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    
    emit Transfer(msg.sender, _to, _value);
    return true;
}

/**
 * @dev Approve spender to spend tokens on your behalf
 * @param _spender Address authorized to spend
 * @param _value Amount authorized to spend
 * @return success True if approval succeeded
 */
function approve(address _spender, uint256 _value) public returns (bool success) {
    require(_spender != address(0), "Cannot approve zero address");
    
    allowance[msg.sender][_spender] = _value;
    
    emit Approval(msg.sender, _spender, _value);
    return true;
}

/**
 * @dev Transfer tokens on behalf of another address
 * @param _from Address to transfer from
 * @param _to Recipient address
 * @param _value Amount to transfer
 * @return success True if transfer succeeded
 */
function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    require(_from != address(0), "Cannot transfer from zero address");
    require(_to != address(0), "Cannot transfer to zero address");
    require(balanceOf[_from] >= _value, "Insufficient balance");
    require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");
    
    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    allowance[_from][msg.sender] -= _value;
    
    emit Transfer(_from, _to, _value);
    return true;
}

/**
 * @dev Mint new tokens (owner only)
 * @param _to Address to mint tokens to
 * @param _value Amount to mint
 */
function mint(address _to, uint256 _value) public onlyOwner {
    require(_to != address(0), "Cannot mint to zero address");
    
    _mint(_to, _value);
}

/**
 * @dev Burn tokens from caller's balance
 * @param _value Amount to burn
 */
function burn(uint256 _value) public {
    require(balanceOf[msg.sender] >= _value, "Insufficient balance to burn");
    
    balanceOf[msg.sender] -= _value;
    totalSupply -= _value;
    
    emit Burn(msg.sender, _value);
    emit Transfer(msg.sender, address(0), _value);
}

// ============ Internal Functions ============

/**
 * @dev Internal mint function
 * @param _to Address to mint to
 * @param _value Amount to mint
 */
function _mint(address _to, uint256 _value) internal {
    totalSupply += _value;
    balanceOf[_to] += _value;
    
    emit Mint(_to, _value);
    emit Transfer(address(0), _to, _value);
}
}