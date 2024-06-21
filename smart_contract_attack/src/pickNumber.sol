// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract PickNumber {
    error numberPicked();
    error youAreNotTheOwner();

    address public owner; 
    address public winner;
    address[] public players;
    uint256[] public pickednumbers;

    uint256 public setNumber;

    mapping (address => uint256) public playersNumber;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function enterGame() public returns (bool) {
        require(msg.sender != address(0), "Invalid address");

        uint256 randomHash = uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp)));
        uint256 playerNumber = (randomHash % 10) + 1; // Range from 1 to 10

        for (uint256 i = 0; i < pickednumbers.length; i++) {
            if (playerNumber == pickednumbers[i]) {
                revert numberPicked();
            }
        }

        playersNumber[msg.sender] = playerNumber;
        pickednumbers.push(playerNumber);
        players.push(msg.sender);

        return true;
    }

    function setScreateNumber() public onlyOwner returns (bool) {
        uint256 randomHash = uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp)));
        // Range from 1 to 10 (adjust to 1 to 100)
        uint256 secretNumber = (randomHash % 100) + 1;

        setNumber = secretNumber;
        return true;
    }

    function pickWinner() public onlyOwner returns (address) {
        setScreateNumber(); // Set a new secret number
        for (uint256 i = 0; i < players.length; i++) {
            if (playersNumber[players[i]] == setNumber) {
                winner = players[i];
                return winner; // Return the winner immediately after finding them
            }
        }
        revert("No winner found"); // Revert if no winner is found
    }
}
