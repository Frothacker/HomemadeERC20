pragma solidity ^0.4.24;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;

  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}



/**
 * @dev my attempt at creating an erc20 token from scratch
 */ 
contract Token is Ownable {
    using SafeMath for uint256;
    
  mapping(address => uint256) public balance;
  uint256 public totalSupply;
  uint256 public contractBalance;
  uint256 public tokenPrice; // in wei

  constructor() public {
   
    tokenPrice = 10 wei;  
    balance[owner] = 100;
    contractBalance = 900;
    totalSupply = contractBalance.add(balance[owner]); // must be same as initial amount given to deployer
    
  }
  
  function totalSupply() public view returns(uint256){
      return totalSupply;
  }
  
  /**
   *  @dev Allows anyone to buy tokens
   */
  function buyTokens() public payable returns(uint256){
      uint256 buyAmount = tokenPrice.div(msg.value);
      require(contractBalance > buyAmount);
      balance[msg.sender] = balance[msg.sender].add(buyAmount);
      contractBalance = contractBalance.sub(buyAmount);
      return balance[msg.sender];
  }
  
  /**
   *  @dev Allows anyone to transfer tokens to another address
   */
  function transfer( address _to, uint256 _amount) public returns(bool){
      require(_to != address(0) );
      require(balance[msg.sender] >= _amount);
      balance[msg.sender] = balance[msg.sender].sub(_amount);
      balance[_to] = balance[_to].add(_amount);
      return true; 
  }
  
  /**
   *  @dev Allows an owner to sell their tokens back
   */
  function sellTokens(uint256 _amount) public {
      require(balance[msg.sender] > _amount);
      contractBalance = contractBalance.add(_amount);
      balance[msg.sender] = balance[msg.sender].sub(_amount);
      msg.sender.transfer(_amount.div(tokenPrice));
  }
  
  /**
   *  @dev Allows anyone to check balance of an address
   */
  function balanceOf(address _holder) public view returns(uint256) {
      return balance[_holder];
  }
  
}
