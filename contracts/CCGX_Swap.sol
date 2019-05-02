pragma solidity ^0.4.24;

interface token {
    function transfer(address receiver, uint amount) external;
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {

    address public owner;

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

contract CCGX_Swap is Ownable {

    token public tokenReward;
    address addressOfTokenUsedAsReward;
    trcToken TRC10_TOKENID = 1000292;

    constructor() public {

    }

    function SwapToTRC10(address toAddress, uint256 tokenValue, trcToken id) payable public    {
        toAddress.transferToken(tokenValue, id);
    }

    function SwapToTRC20(address TRC20_Address) public payable returns(trcToken, uint256){
        addressOfTokenUsedAsReward = TRC20_Address;
        tokenReward = token(addressOfTokenUsedAsReward);
        trcToken id = msg.tokenid;
        uint256 value = msg.tokenvalue;
        if (id == TRC10_TOKENID){
            tokenReward.transfer(msg.sender, value * 100000000 / 10);
        }
        return (id, value);
    }

    function getTRC10TokenBalance(trcToken id) public view returns (uint256){
        return address(this).tokenBalance(id);
    }


    // @dev Returns contract ETH balance
    function getBalance() public view returns (uint256)
    {
        return address(this).balance;
    }

    // @dev Transfers TRX from contract to specified address
    function withdrawTRX(address _address, uint256 _amount) onlyOwner public returns (uint256)
    {
        uint256 _value = _amount*(1 trx);

        // to prevent spamming
        require(_value > 1 trx, "Send at least 1 TRX");

        // transfer reward to account
        _address.transfer(_value);

    }

    // @dev Transfers TRX from specified address to contract
    function depositTRX() public payable onlyOwner returns (bool) {

        return true;
    }

}