pragma solidity ^0.4.21;
interface Token{
    function balanceOf(address who)external constant returns(uint256);
    function transfer(address to,uint256 value)external;
    function transferFrom(address from,address to,uint256 value)external;
    function allowance(address owner,address spender)external constant returns(uint256);
}

contract AirDrop{
    Token obj;
    address own;
    address[] add;
    mapping(address => uint256) uservalue;
    mapping(address=>bool) alreadyExists;
    bool transfered;
    bool Pause;
    uint256 allowedTokens;
    address TokenOwner;
    bool claimtoken;
    bool reg;
    
    modifier onlyOwner{
        require(own==msg.sender);
        _;
    }
   
    function AirDrop()public{
        own=msg.sender;
     }
    uint256 totalValues;
    function UserRegistration(address _address,uint256 _Tokens)public{
        require(alreadyExists[_address]==false);
        require(Pause==false);
        add.push(_address);
        uservalue[_address]=_Tokens;
        totalValues+=_Tokens;
        alreadyExists[_address]=true;
        reg=true;
        
    }
    function balanceAllocated(address who)public constant returns(uint256){
        require(Pause==false);
        return uservalue[who];
    }
    function balanceTransfered(address who)public constant returns(uint256){
        return obj.balanceOf(who);
    }
    
    
     function TransferTokentoAllUsers()onlyOwner public{
         
        require(Pause==false);
        require(reg==true);
        require(transfered==false);
   
        for(uint256 i=0;i<add.length;i++){
            obj.transfer(add[i],uservalue[add[i]]);
        }
        transfered=true;
        claimtoken=true;
    }
   
    function AirdropStart(address Tokenaddress){
        obj=Token(Tokenaddress);
        uint256 val=obj.allowance(msg.sender,this);
        obj.transferFrom(msg.sender,this,val);
    }
    
    function listAllUsers()public constant returns(address[]){
        if(Pause==false){
        return add;
        }
    }
    
    function PauseAll()onlyOwner public{
        require(Pause==false);
        Pause=true;
    }
    function ResumeAll()onlyOwner public{
        require(Pause==true);
        Pause=false;
    }
    function claimRemainingToken()onlyOwner public{
        require(claimtoken==true);
        uint256 bal=obj.balanceOf(this);
        obj.transfer(msg.sender,bal);
    }
}
