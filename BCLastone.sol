// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract FamilyTips {
    address owner;
    FamilyMember[] familyMembers;

    constructor(){
        owner = msg.sender;
    }

    //1. Add funds to the smart contract
    function addFamilyFund() payable public {

    }

    //2. View contract balance
    function viewFamilyFund() public view returns(uint){
        return address(this).balance;
    }

    //3. Family member struct
    struct FamilyMember{
        address payable walletAddress;
        string name;
    }

    //4. Add family member
    function addFamilyMember(address payable walletAddress, string memory name) public {
        require(msg.sender == owner, "Only the owner can call this function");
        bool familyMemberExists = false;

        if (familyMembers.length >= 1) {
            for (uint i = 0; i < familyMembers.length; i++) {
                if (familyMembers[i].walletAddress == walletAddress) {
                    familyMemberExists = true;
                }
            }
        }
        if (familyMemberExists == false) {
            familyMembers.push(FamilyMember(walletAddress, name));
        }
    }

    //5. Remove family member
    function removeFamilyMember(address payable walletAddress) public {
        if (familyMembers.length > 0) {
            for (uint i = 0; i < familyMembers.length; i++) {
                if (familyMembers[i].walletAddress == walletAddress) {
                    for (uint j = i; j < familyMembers.length - 1; j++) {
                        familyMembers[j] = familyMembers[j + 1];
                    }
                    familyMembers.pop();
                    break;
                }
            }
        }
    }

    //6. View family members
    function viewFamilyMembers() public view returns(FamilyMember[] memory) {
        return familyMembers;
    }

    //7. Distribute family funds
    function distributeFamilyFunds() public {
        require(address(this).balance > 0, "Insufficient balance in the contract");
        if (familyMembers.length >= 1) {
            uint amount = address(this).balance / familyMembers.length;
            for (uint i = 0; i < familyMembers.length; i++) {
                transfer(familyMembers[i].walletAddress, amount);
            }
        }
    }

    //8. Transfer money
    function transfer(address payable walletAddress, uint amount) internal {
        walletAddress.transfer(amount);
    }
}
