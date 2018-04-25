pragma solidity ^0.4.21;
import "browser/ERC20.sol";
contract Token is ERC20{
    string public name="shoban";
    string public symbol="MRS";
    uint256 public decimals=18;
    uint256 public totalsupply=100000e18;
    address public owner;
    using SafeMath for uint256;
    mapping (address => uint256)public balances;
    mapping (address => mapping(address => uint256)) allowed;
   
    function Token()public{
        balances[msg.sender]=totalsupply;
        owner=msg.sender;
       
    }
    
    function totalSupply()public view returns(uint256){
        return totalsupply;
    }
  
    function balanceOf(address who) public view returns(uint256){
        return balances[who];
    }
    
    function transfer(address to,uint256 value)public returns(bool){
        require(value>0);
        require(balances[msg.sender]>=value);
        balances[msg.sender]=balances[msg.sender].sub(value);
        balances[to] =balances[to].add(value);
        Transfer(msg.sender,to,value);
        return true;
    }
     function transferFrom(address from,address to,uint256 value)public returns(bool){
        require(value<=allowed[from][msg.sender] && value>0);
        balances[from]=balances[from].sub(value);
        allowed[from][msg.sender]=allowed[from][msg.sender].sub(value);
        balances[to]=balances[to].add(value);
        Transfer(from,to,value);
        return true;
    }
    function approve(address spender,uint256 value)public returns(bool){
        require(balances[msg.sender]>=value && value>0);
        allowed[msg.sender][spender]=value;
        Approval(msg.sender,spender,value);
        return true;
    }
    function allowance(address owner,address spender)public constant returns(uint256){
          return allowed[owner][spender];
      }
      
    function buyTokens(address to)payable public{
        uint256 val=msg.value*100;
        transfer(to,val);
    }
    function kill()public{
        selfdestruct(msg.sender);
    }
}
