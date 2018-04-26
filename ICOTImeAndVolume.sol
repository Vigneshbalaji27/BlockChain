pragma solidity ^0.4.20;
interface Token{
    
    function balanceOf(address _to) public constant returns(uint256);
    function transfer(address _to,uint256 _value)external returns(bool success);
}
contract ICO{
      
      address owner;
      struct userDetails{
          address userAddress;
          uint256 amount;
          uint256 tokens;
      }
      
      event Transfer(address indexed from,address indexed to,uint256 value);
      
      mapping(address => userDetails) users;
      mapping(address => uint256) tokenValue;
      mapping(address => uint256) storeTime;
      mapping(address => uint256) bonus;
      enum Stage{START,FINISH}
      Stage public stages;
      Token public t;
      
      uint256 public tokensFor1Ether;
      uint256 public maxGoal;
      uint256 public totalEther;
      address[] storeAdd;
      uint256 time;
      bool alreadyRefund;
      
    function ICO(address _tokenAddress) public{
        t=Token(_tokenAddress);
        time=getNow()+(5 minutes*1000);
        tokensFor1Ether=1000;
        maxGoal=1e18;
        owner=msg.sender;
        stages=Stage.START;
    }
    
    function returnStage() public constant returns(Stage){
        return stages;
    }
    
     function checkBalance(address _add) public constant returns(uint256){
         return t.balanceOf(_add);
     }
     
     function buyTokens(address _beneficiary) public payable{
         require(_beneficiary!=0x0);
         require(stages==Stage.START);
         register(_beneficiary);
     }
     
     function register(address _beneficiary)internal{
         storeTime[_beneficiary]=getNow();
         totalEther+=msg.value;
         var u=users[_beneficiary];
         u.userAddress=_beneficiary;
         u.amount=msg.value;
         storeAdd.push(_beneficiary);
         u.tokens=u.amount*tokensFor1Ether;
         if(u.amount>=0.5e18)
         {
             t.transfer(_beneficiary,u.tokens);
             uint256 extra=u.tokens*10/100;
             u.tokens+=extra;
             t.transfer(_beneficiary,extra);
         }
         else
         t.transfer(_beneficiary,u.tokens);
     }
    
    function requireTimeBasedBonus(address _beneficiary)public {
        
          require(stages==Stage.START);
          for(uint256 i=0;i<storeAdd.length;i++){
          if(storeAdd[i]==_beneficiary){
          bonus[_beneficiary]=(users[_beneficiary].tokens*requireTimeBasedBonusRate(_beneficiary))/100;
          t.transfer(_beneficiary,bonus[_beneficiary]);
          }
           
      }    
      
    }
    
    function requireTimeBasedBonusRate(address _beneficiary)internal constant returns(uint256){
        uint256 bonusRate=0;
        if(checkRequiredTime(_beneficiary) && (users[_beneficiary].tokens==t.balanceOf(_beneficiary)))
        {
            return 50;
        }
        return bonusRate;
        
    }
    function checkRequiredTime(address _beneficiary) public constant returns(bool success){
      require(stages==Stage.START);
      uint256 bonus2=storeTime[_beneficiary]+(2 minutes*1000);
      if(getNow()>bonus2){
          return true;
      }
      else
      return false;
    }
    
    function kill() public{
        selfdestruct(msg.sender);
    }
    
    function checkTime() public constant returns(bool){
        
        if(getNow()>time)
        return true;
        
        else
        return false;
    }
    
    function returningEthers() public{
        require(stages==Stage.START);
        
        if(getNow()>=time && totalEther>= maxGoal){
            getEtherFromContract();
             stages=Stage.FINISH;
        }
        else
        {
            refundEtherToUsers();
             stages=Stage.FINISH;
        }
       
    }   
    
    function getEtherFromContract() internal{
        owner.transfer(this.balance);
        Transfer(this,owner,this.balance);
    }
    
    function refundEtherToUsers() internal{
        require(alreadyRefund==false);
        for(uint256 i=0;i<storeAdd.length;i++){
            storeAdd[i].transfer(users[storeAdd[i]].amount);
            Transfer(this,storeAdd[i],users[storeAdd[i]].amount);
        }
        alreadyRefund=true;
    }
    function getNow() public constant returns(uint256){
         return (now*1000);
     }
}
