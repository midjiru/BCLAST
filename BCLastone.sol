// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract FamilyTips {
    address owner;
    FamilyMember[] familyMembers;
    uint256 lastActive;  // Timestamp of the last keep-alive
    uint256 constant ACTIVE_THRESHOLD = 5 minutes;  // Time limit for keep-alive (5 minutes for testing)

    constructor() {
        owner = msg.sender;
        lastActive = block.timestamp;  // Set initial activity timestamp
    }

    // Modifier to allow only the owner to call specific functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Modifier to ensure the owner is still active
    modifier keepAlive() {
        require(block.timestamp - lastActive < ACTIVE_THRESHOLD, "Owner has not been active for 5 minutes");
        _;
    }

    // 1. Add funds to the smart contract
    function addFamilyFund() public payable onlyOwner {
        // Owner can add funds to the contract
    }

    // 2. View contract balance
    function viewFamilyFund() public view returns (uint256) {
        return address(this).balance;
    }

    // 3. Family member struct
    struct FamilyMember {
        address payable walletAddress;
        string name;
    }

    // 4. Add family member
    function addFamilyMember(address payable walletAddress, string memory name) public onlyOwner {
        bool familyMemberExists = false;

        if (familyMembers.length >= 1) {
            for (uint256 i = 0; i < familyMembers.length; i++) {
                if (familyMembers[i].walletAddress == walletAddress) {
                    familyMemberExists = true;
                }
            }
        }
        if (!familyMemberExists) {
            familyMembers.push(FamilyMember(walletAddress, name));
        }
    }

    // 5. Remove family member
    function removeFamilyMember(address payable walletAddress) public onlyOwner {
        if (familyMembers.length > 0) {
            for (uint256 i = 0; i < familyMembers.length; i++) {
                if (familyMembers[i].walletAddress == walletAddress) {
                    for (uint256 j = i; j < familyMembers.length - 1; j++) {
                        familyMembers[j] = familyMembers[j + 1];
                    }
                    familyMembers.pop();
                    break;
                }
            }
        }
    }

    // 6. View family members
    function viewFamilyMembers() public view returns (FamilyMember[] memory) {
        return familyMembers;
    }

    // 7. Distribute family funds (Only the owner can call this function)
    function distributeFamilyFunds() public onlyOwner keepAlive {
        require(address(this).balance > 0, "Insufficient balance in the contract");
        if (familyMembers.length >= 1) {
            uint256 amount = address(this).balance / familyMembers.length;
            for (uint256 i = 0; i < familyMembers.length; i++) {
                transfer(familyMembers[i].walletAddress, amount);
            }
        }
    }

    // 8. Keep the contract alive by resetting the lastActive timestamp
    function keepAliveFunction() public onlyOwner {
        lastActive = block.timestamp;  // Reset the last activity timestamp
    }

    // 9. Distribute funds if the owner has been inactive for over 5 minutes
    function distributeIfInactive() public {
        require(block.timestamp - lastActive >= ACTIVE_THRESHOLD, "Owner is still active");
        require(address(this).balance > 0, "Insufficient balance in the contract");
        if (familyMembers.length >= 1) {
            uint256 amount = address(this).balance / familyMembers.length;
            for (uint256 i = 0; i < familyMembers.length; i++) {
                transfer(familyMembers[i].walletAddress, amount);
            }
        }
    }

    // Transfer money
    function transfer(address payable walletAddress, uint256 amount) internal {
        walletAddress.transfer(amount);
    }
}
