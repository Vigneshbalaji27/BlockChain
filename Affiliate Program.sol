// contract  0x4834E384b3701bB56B75752672b9DF9Ddd50a879
 
 pragma solidity ^0.4.21;
interface Token{
    function transfer(address from,uint256 value)external;
  
   
}
contract affiliator{
    struct user{
        address userAddress;
        uint256 amount;
        bytes32 code;
        bool exists;
        uint256 tokens;
    }
    modifier onlyowner{
        require(owner==msg.sender);
        _;
    }
    
    address owner;
    mapping(address => user) users;
    mapping(address => bool) AlreadyExists;
    mapping(address=> uint256) tokenvalue;
    Token public obj;
    address[] storeadd;
    bytes32[] storeref;
    uint256 time;
    uint256 public fundRaised;
    uint256 public tokensfor1ether;
    uint256 public maxGoal;
    bool AlreadyTransfered;
   
    
    function affiliator(address TokenAddress,uint256 _tokensfor1ether,uint256 durationinmin,uint256 _maxGoal)public{
        
        obj=Token(TokenAddress);
        time=now *1000 + durationinmin *60000;
        tokensfor1ether=_tokensfor1ether;
        maxGoal=_maxGoal*1e18;
        owner=msg.sender;
    }
    
    function BuyTokens(address _userAddress,bytes32 ReferalCode)payable public returns(bytes32){
        require(AlreadyExists[_userAddress]==false);
        require((now*1000)<time && fundRaised < maxGoal); 
        if(ReferalCode=="0"){
            fundRaised+=msg.value;
            reg(_userAddress,ReferalCode);
            AlreadyExists[_userAddress]=true;
            return(users[_userAddress].code);
        }
        else{
           fundRaised+=msg.value;
            for(uint256 i=0;i<storeadd.length;i++){
              if(users[storeadd[i]].code==ReferalCode){
                   reg(_userAddress,ReferalCode);
               tokenvalue[storeadd[i]]+=users[storeadd[i]].tokens/10;
              }  
            }
            AlreadyExists[_userAddress]=true;
            return users[_userAddress].code;
        }
      
    }
    
    function reg(address _userAddress,bytes32 ReferalCode)internal{
         var u=users[_userAddress] ;
        u.userAddress=_userAddress;
        u.amount=msg.value;
        storeadd.push(_userAddress);
        u.code=keccak256(_userAddress);
        storeref.push(u.code);
        u.tokens=u.amount * tokensfor1ether;
        obj.transfer(_userAddress,u.tokens);
       
        
    }
    function kill()public{
        selfdestruct(msg.sender);
    }
    
     function timecheck()public constant returns(bool){
         if((now*1000)>time){
             return true;
         }
         else
         {
             return false;
         }
     }
    function getExtraTokens(bytes32 ReferalCode)public{
        for(uint256 i=0;i<storeadd.length;i++){
            if(users[storeadd[i]].code==ReferalCode){
                obj.transfer(users[storeadd[i]].userAddress,tokenvalue[storeadd[i]]);
                  tokenvalue[storeadd[i]]-=tokenvalue[storeadd[i]];
            }
             
            
        }
        
    }
    
    function ethers()public{
        if(((now*1000)>=time||(now*1000)<time) && fundRaised>=maxGoal){
            getEtherfromContract();
        }
        else if(now*1000>=time && fundRaised <maxGoal){
            RefundEthertoUsers();
        }
    }
    function getEtherfromContract()internal{
      
        owner.transfer(this.balance);
    }
    function RefundEthertoUsers()internal{
        require(AlreadyTransfered==false);
        for(uint256 i=0;i<storeadd.length;i++){
            storeadd[i].transfer(users[storeadd[i]].amount);
        }
        AlreadyTransfered=true;
        
    }
    
    function showExtraToken(bytes32 ReferalCode)public constant returns(uint256){
        for(uint256 i=0;i<storeadd.length;i++){
            if(users[storeadd[i]].code==ReferalCode){
                return (tokenvalue[storeadd[i]]);
            }
        }
    }
    function showusers()public constant returns(address[],bytes32[]){
        return (storeadd,storeref);
    }
    
    function Burn()onlyowner public{
        selfdestruct(msg.sender);
        
    }
    
    
    
}
 
