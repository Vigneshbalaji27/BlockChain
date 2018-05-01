pragma solidity ^0.4.21;
interface Token{
    function balanceOf(address who)external constant returns(uint256);
    function transfer(address to,uint256 value)external;
    function transferFrom(address from,address to,uint256 value)external;
    function allowance(address owner,address spender)external constant returns(uint256);
}
contract AirDropToken{
     struct user{
        address userAddress;
        Token tokenAddress;
        uint256 tokens;
        uint256 totaltokens;
    }
    Token[] obj1;
    mapping(address =>user) uservalue;
    mapping(address => bool) alreadyExists;
    mapping(address=> bool) registeredToken;
    mapping(address=> uint256) maxvalue;
    address[] add;
    bool register;
    address owner;
    bool transfered;
    address[] tokenowners;
    mapping(address=>uint256)max;
    modifier onlyOwner{
        require(owner==msg.sender);
        _;
    }
    event Userdetails(address user,address tokenAddress,uint256 tokens);
    function AirDropToken() public{
        owner=msg.sender;
    }
    function tokenOwnerRegistration(address _owner,Token _tokenAddress)public{
        require(registeredToken[_tokenAddress]==false);
        obj1.push(Token(_tokenAddress));
        maxvalue[_tokenAddress]=(_tokenAddress.allowance(owner,this)*70)/100;
        _tokenAddress.transferFrom(_owner,this,_tokenAddress.allowance(owner,this));
        registeredToken[_tokenAddress]=true;
    }
    function UserRegistration(address _address,Token tokenAddress,uint256 _Tokens)public{
        require(_address!=address(0));
        require(alreadyExists[_address]==false);
        require(registeredToken[tokenAddress]==true);
        max[tokenAddress]+=_Tokens;
        if(max[tokenAddress]<=maxvalue[tokenAddress]){
        add.push(_address);
        uservalue[_address].userAddress=_address;
        uservalue[_address].tokens=_Tokens;
        uservalue[_address].tokenAddress=tokenAddress;
        alreadyExists[_address]=true;
        register=true;
        }
        else{
            max[tokenAddress]-=_Tokens;
            throw;
        }
        
    }
    function TransferTokentoAllUsers()onlyOwner public{
        require(transfered==false);
        require(register==true);
        for(uint256 i=0;i<add.length;i++){
            uservalue[add[i]].tokenAddress.transfer((uservalue[add[i]].userAddress),(uservalue[add[i]].tokens));
        }
        transfered=true;
    }
    
    function showTokens()public constant returns(Token[]){
        return obj1;
    }
   
    function claim(address _address)public{
        require(transfered==true);
        for(uint256 i=0;i<add.length;i++){
            require(uservalue[add[i]].userAddress==_address);
            require(uservalue[add[i]].tokens < uservalue[add[i]].tokenAddress.balanceOf(_address));
            uservalue[add[i]].tokenAddress.transfer(_address,uservalue[add[i]].tokens);
        }
    }
    function userDetails()public onlyOwner{
        for(uint256 i=0;i<add.length;i++){
            emit Userdetails(add[i],uservalue[add[i]].tokenAddress,uservalue[add[i]].tokens);
        }
    }
}
