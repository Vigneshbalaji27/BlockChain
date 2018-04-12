pragma solidity ^0.4.20;
import "browser/Owner.sol";
interface Token{
    
    function balanceOf(address _to) public constant returns(uint256);
    function transferFrom(address _from,address _to,uint256 value) public returns(bool success);

}

contract ClaimToken {
    
    mapping(address => bool)checkPause;
    mapping(address => uint256) timing;
    mapping(address => uint256) totalValues;
    mapping(address => uint256) val;
    mapping(address => uint256 ) balances;
    address[] account;
    address multisig;
    Token t;
    mapping(address => uint256)counterAdd;
    mapping(address => bool)alreadyClaimed;
    mapping(address => bool)claimInAccount5;
    mapping(address => bool)inAccount;
    uint256 public min15; 
     function ClaimToken(address _token) public {
         t=Token(_token);
         multisig=msg.sender;
         account.push(multisig);
     }
    
    
    function transferFrom(address _from,address _to,uint256 value) public{
            require(checkPause[msg.sender]==false);
            if(multisig==msg.sender)
            {
            t.transferFrom(_from,_to,value);
            timing[_to]=getNow();
            val[_to]=value;
            account.push(_to);
            inAccount[_to]=true;
            }
            else{
                t.transferFrom(_from,_to,value);
                timing[_to]=getNow();
                val[_to]=value;
                account.push(_to);
                inAccount[_to]=true;
                counterAdd[msg.sender]++;
                totalValues[msg.sender]+=value;
            }
        
    }

    function balanceOf(address _add) public constant returns(uint256){
        return t.balanceOf(_add);
    }
    
    function pause()  public returns(bool){
        for(uint256 i=0;i<account.length;i++){
            checkPause[account[i]]=true;
        }
    }
    
    function resume() public returns(bool){
        for(uint256 i=0;i<account.length;i++){
            checkPause[account[i]]=false;
        }
    }
    
    function getNow() public constant returns(uint256){
        return (now*1000);
    }
    
    function tokenHolderClaim(address _beneficiary) public{
        
         require(timeBased(_beneficiary)==true);
         require(alreadyClaimed[_beneficiary]==false);
         require(counterAdd[_beneficiary]==0);
         require(t.balanceOf(multisig)>=t.balanceOf(_beneficiary));
         uint256 bonus=(t.balanceOf(_beneficiary)*10)/100;
         t.transferFrom(multisig,_beneficiary,bonus);
         alreadyClaimed[_beneficiary]=true;
}
    
    function timeBased(address _add) public constant returns(bool){
        
        require(inAccount[_add]==true);
        uint256 currentTime=timing[_add];
        min15=currentTime+(0.1 minutes *1000);
        if(getNow()>=min15){
            return true;
        }
        else{
            return false;
        }
    }
     function accountMoreThan5Claim(address _beneficiary) public returns(uint256){
        
      require(claimInAccount5[_beneficiary]==false);
      require(counterAdd[_beneficiary]>=3);
      uint256 bonus=(val[_beneficiary]*10)/100;
      require(totalValues[_beneficiary]>=bonus);
      require(t.balanceOf(multisig)>=t.balanceOf(_beneficiary));
      //require((val[_beneficiary]-t.balanceOf(_beneficiary))>bonus);
      t.transferFrom(multisig,_beneficiary,bonus);
       claimInAccount5[_beneficiary]=true;
        
    }
    
    function burnTokens() public constant returns(bool success){
        for(uint256 i=0;i<account.length;i++){
            balances[account[i]]=0;
        }
        
    }
    
    function listAccount() public constant returns(address[]){
        
        return account;
    }
    
    function addingValues(address _add) public constant returns(uint256){
        return totalValues[_add];
    }
    
}
