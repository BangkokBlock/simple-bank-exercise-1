/*
 * This exercise has been updated to use Solidity version 0.8.5
 * See the latest Solidity updates at
 * https://solidity.readthedocs.io/en/latest/080-breaking-changes.html
 */
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.9.0;

contract SimpleBank {

     // State variables
     uint amount;

    // Fill in the visibility keyword. 
    // Hint: We want to protect our users balance from other contracts
    mapping (address => uint) private balances ;
    
    // Fill in the visibility keyword
    // Hint: We want to create a getter function and allow contracts to be able
    //       to see if a user is enrolled.
    mapping (address => bool) public enrolled;

    // Let's make sure everyone knows who owns the bank, yes, fill in the
    // appropriate visilibility keyword
    address public owner = msg.sender;
    
    //Modifiers
    modifier notYetEnrolled {
        require(
            enrolled[msg.sender] == false, "You are already enrolled."
        );
        _;
    }
    modifier onlyEnrolled {
        require(
            enrolled[msg.sender] == true, "Only enrolled accounts permitted."
        );
        _;
    }
    /* Events - publicize actions to external listeners
     */
    
    // Add an argument for this event, an accountAddress
    event LogEnrolled(address accountAddress);

    // Add 2 arguments for this event, an accountAddress and an amount
    event LogDepositMade(address accountAddress, uint amount);

    // Create an event called LogWithdrawal
    // Hint: it should take 3 arguments: an accountAddress, withdrawAmount and a newBalance 
    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    /* Functions
     */
     
    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public view returns (uint) {
         return balances[msg.sender];
    }
      // 1. A SPECIAL KEYWORD prevents function from editing state variables;
      //    allows function to run locally/off blockchain
      // 2. Get the balance of the sender of this transaction
   

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    // Emit the appropriate event
    function enroll() public notYetEnrolled returns (bool){
      // 1. enroll of the sender of this transaction
          enrolled[msg.sender] = true;
          emit LogEnrolled(msg.sender);
          return enrolled[msg.sender];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable onlyEnrolled returns (uint) {
          balances[msg.sender] += msg.value;
          emit LogDepositMade (msg.sender, balances[msg.sender]);
          return balances[msg.sender];
    }

    // 1. Add the appropriate keyword so that this function can receive ether
    // 2. Users should be enrolled before they can make deposits (modifier does this)
    // 3. Add the amount to the user's balance. Hint: the amount can be
    //    accessed from of the global variable `msg`
    // 4. Emit the appropriate event associated with this function
    // 5. return the balance of sndr of this transaction
    

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint) {
        require(balances[msg.sender]>= withdrawAmount);
        balances[msg.sender] -= withdrawAmount;
        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
        return balances[msg.sender];
        }
    function () external payable {
        revert();
    }
}
    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    
