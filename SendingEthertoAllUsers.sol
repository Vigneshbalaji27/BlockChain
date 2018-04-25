pragma solidity ^0.4.20;
contract mycontract{
    struct details{
       address id;
       uint amount;
       bool exists;
       uint code;
    }
    function mycontract(){
        owner=msg.sender;
    }
    modifier onlyowner{
       if(msg.sender==owner){
           _;
       } 
       else
       throw;
    }
    mapping(address=>details) add;
    address owner;
    uint ReferenceCode;
    uint[] store;
    address[] storeadd;
    uint[] storeval;
    function ()payable onlyowner{
        
    }
    function kill()public onlyowner{
        selfdestruct(msg.sender);
    }
    function register(address _address,uint _ReferenceCode )payable public returns(uint){
        if(_ReferenceCode==0){
             if(add[_address].exists==false){
        add[_address].id=_address;
        add[_address].amount=msg.value;
        ReferenceCode++;
        store.push(ReferenceCode);
        storeadd.push(_address);
        storeval.push(add[_address].amount);
         userexists(_address);
        return ReferenceCode;
        }
            else
            throw;
        }
        else if(_ReferenceCode>0){
             if(add[_address].exists==false){
         for(uint i=0;i<storeadd.length;i++){
            if(_ReferenceCode==store[i]){
            add[_address].id=_address;
            add[_address].amount=msg.value;
            add[storeadd[i]].amount+=add[storeadd[i]].amount/10;
            storeval[i]=add[storeadd[i]].amount;
            }}
            ReferenceCode++;
            store.push(ReferenceCode);
            storeadd.push(_address);
            storeval.push(add[_address].amount);
            userexists(_address);
           }
             else
             throw;
        }
        
    }
    function userexists(address _address)internal{
     add[_address].exists=true;
     }
    function ethersending()public {
        
        for(uint i=0;i<store.length;i++){
            storeadd[i].transfer(storeval[i]);
            
        }
    }
        
}
