pragma solidity ^0.4.20;
interface Token{
    function balanceOf(address who)public constant returns(uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
 }
contract operations {
    Token obj;
    mapping (address=>uint256) time;
    mapping(address=>bool) add;
    mapping (address=>uint256) values1;
    mapping(address=>uint256)public count;
    mapping(address=> uint256) allow;
    mapping(address=>uint256) values2;
    mapping(address=> bool) claimed;
    mapping(address=>bool) claimed1;
 
    bool check;
    address owner;
    //mapping(address=>uint256) valuescount;
    function operations(address tokenaddress)public{
        obj=Token(tokenaddress);
        owner=msg.sender;

    }
     modifier onlyOwner{
        require(msg.sender==owner);
        _;
    }
    function transferFrom(address from,address to,uint256 value)public{
      
       require(check==false);
       if(owner==msg.sender){
        obj.transferFrom(from,to,value);
        time[to]=getnow();
        values1[to]=value;
    
        add[to]=true;
       }
       else{
           obj.transferFrom(from,to,value);
           values2[to]=value;
           count[msg.sender]++;
       }
    }
    
    function PauseTransfer()onlyOwner public {
        check=true;
    }
    function ResumeTransfer()onlyOwner public {
        check=false;
       
    }
    function getnow()internal constant returns(uint256){
        return now*1000;
    }
    function balanceOf(address who)public constant returns(uint256){
       return  obj.balanceOf(who);
    }
    function timebased(address beneficiary)public constant returns(bool){
        uint256 m15=time[beneficiary]+(1 minutes*1000);
             if(getnow()>m15){
                return true;              
             }
             else{
                 return false;
             }
    }
    
    function claim(address beneficiary)public{
        require(claimed[beneficiary]==false);
        require(add[beneficiary]==true);
        require(timebased(beneficiary)==true);
        require(count[beneficiary]==0);
        obj.transferFrom(owner,beneficiary,(values1[beneficiary]*10)/100);
        values1[beneficiary]=0;
        claimed[beneficiary]=true;
         
    }
    
   
    function claimAfer5Transactions(address beneficiary) public{
        require(claimed1[beneficiary]==false);
        require(count[msg.sender]>=3);
        uint256 val=(values1[beneficiary]*10)/100;
        require((values1[beneficiary]-obj.balanceOf(beneficiary))>=val);
        obj.transferFrom(owner,beneficiary,val);
        claimed1[beneficiary]=true;
    }
    
}
