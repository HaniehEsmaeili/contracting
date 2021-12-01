pragma solidity ^0.4.0;

contract contracting{
    
    uint256 public startDate;
    uint16 public day;
    uint256 public amount;
    uint256 public deposit;
    address employer;
    address contractor;
    address judger;
    
   enum status{nonStarted,paied,started,ended,suspended,failed}
    status currentStatus;
    
    
    constructor( address _employer,  address _contractor,  address _judger, uint256 _amount, uint256 _deposit,  uint16 _day) public{
        employer= _employer;
        contractor= _contractor;
        judger= _judger;
        amount= _amount;
        deposit= _deposit;
        day= _day;
        
    }
    
    function pay() public payable returns(string memory){
        require(currentStatus== status.nonStarted);
        require(msg.sender == employer);
        require(msg.value == amount);
        startDate= block.timestamp;
        currentStatus= status.paied;
        return "Success";
        
    }
    
    function Deposit() public payable returns (string memory){
        require(msg.sender==contractor);
        require(msg.value==deposit);
        require(currentStatus==status.paied);
        currentStatus=status.started;
        return "Success";
    }
    
    function Confirm(bool verify) public returns (string memory){
        require(msg.sender == employer);
        require(currentStatus==status.started);
        if (verify==true){
            currentStatus=status.ended;
            return "The Project Was Ended";
        }else{
            if(block.timestamp>(day*86400)+startDate){
                currentStatus=status.suspended;
                return "The Poject Was Suspended";
            }else{
                return "Deadline Has Not Overed Yet";
            }
        }
    }
    
    function Judgement(bool verify) public returns(string memory){
        require(currentStatus==status.suspended);
        require(msg.sender==judger);
        if(verify==true){
            currentStatus=status.ended;
            return "The Project Was Ended";
        }else{
            currentStatus=status.failed;
            return "The Project Was Failed";
        }
    }
    
    function WithdrawContractor() public payable returns(string memory){
        require(msg.sender==contractor);
        require(currentStatus==status.ended);
        contractor.transfer(amount+deposit);
        return "Transfering Was Done";
    }
    
    function WithdrawEmployer() public payable returns(string memory){
        require(msg.sender==employer);
        require(currentStatus==status.failed);
        employer.transfer(amount+deposit);
        return "Transfering Was Done";
    }
}