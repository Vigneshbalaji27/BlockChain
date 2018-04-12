
pragma solidity ^0.4.20;
import "browser/ERC20.sol";

contract Token is ERC20{
    
    string public name;
    string public symbol;
    uint256 public decimals;
    using SafeMath for uint256;
    address multisig;
    uint256 public initialToken;
    mapping(address => uint256 ) balances;
    mapping(address => mapping (address => uint256)) allowed;
    
    function Token(){
        name="VIGNESH";
        symbol="KVB";
        decimals=18;
        initialToken=10000e18;
        balances[msg.sender]=initialToken;
        multisig=msg.sender;
    }
    
    function totalSupply() public constant returns (uint256){
        return initialToken;
    }
    function balanceOf(address _add) public constant returns(uint256){
        return balances[_add];
    }
    
     function transfer(address _to,uint256 value) public returns(bool success){
        require(balances[msg.sender]>=value && value >=0);
        balances[msg.sender]=balances[msg.sender].sub(value);
        balances[_to]=balances[_to].add(value);
        Transfer(msg.sender,_to,value);
        return true;
    }
    function transferFrom(address _from,address _to,uint256 value) public returns(bool success){
        require(allowed[_from][msg.sender]>=value && balances[_from]>=value && value> 0);
        balances[_from]=balances[_from].sub(value);
        balances[_to]=balances[_to].add(value);
        allowed[_from][msg.sender]=allowed[_from][msg.sender].sub(value);
        Transfer(_from,_to,value);
        return true;
    }
    function approve(address spender,uint256 value) public returns (bool success){
        require(balances[msg.sender]>=value);
        allowed[msg.sender][spender]=value;
    }
    function allowance(address owner,address spender)public constant returns(uint256){
        return allowed[owner][spender];
    }
}
