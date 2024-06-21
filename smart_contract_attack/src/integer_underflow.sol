pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

contract Vault {
    mapping (address => uint256) private userBalances;

    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }

    function deposit() external payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) external noReentrant {
        uint256 balance = getUserBalance(msg.sender);
        require(balance - _amount >= 0, "Insufficient balance");

        userBalances[msg.sender] -= _amount;
        
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }

    function getUserBalance(address _user) public view returns (uint256) {
        return userBalances[_user];
    }

    function getEthBalance () public view returns (uint256) {
        return address(this).balance;
    }
}