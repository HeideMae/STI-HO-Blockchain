pragma solidity ^0.5.0;

contract CPD {
	//The smart contract contains the complete process and flow: checking of balance, sending of unit requests, and transferring of units. Transfer of units removes the current request. 
	//Things to improve on: The getrequest function should not need the input of the requestor address and should display multiple senders and their request unit value. Looking into either array, multiple returns, or tables.
	//For the web3js and UI, we are able to establish a connection between web3 and the smart contract. Looking into using React for the UI and then establishing its conenction with web3
	//We are now able to run the smart contract using metamask(Ropsten test network), remix, and web3.

     uint private constant __totalSupply = 1000000000;        /// Total CPD Units in circulation. 
    
     mapping(address => RequestOfinsti) public RequestofInstitution; ///This is where the institution submits a request for CPD units to PRC
     mapping(address => RequestOfTeach) public RequestofTeacher; ///This is where teachers submit a request for CPD units to Institution
     mapping(address => uint256) balances;
     
    struct RequestOfinsti{
        
        address _requestingInstitution; //address of the institution sending the request
        uint256 _requestedCPDunitsofInstiution; //Indicates the number of CPD units that the institution is requesting
        address _addressofPRC;  //PRC indicates the address of PRC
    }
    
        struct RequestOfTeach{
        
        address _requestingTeacher;
        uint256 requestedCPDunitsofTeacher;
        address _addressofInstitution;
    }

        /// Function returns the balance of the indicated address. Can be either PRC, Institution, or Teacher
        function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
    
    function StoreRequestInstitution(address _requestingInstitution, uint256 _requestedCPDunitsofInstiution, address _addressofPRC) public  { //stores the request of the institution. To be called later
    RequestofInstitution[_requestingInstitution] = RequestOfinsti(_requestingInstitution,_requestedCPDunitsofInstiution,_addressofPRC);
    }
    
    function StoreRequestTeacher(address _requestingTeacher, uint256 requestedCPDunitsofTeacher, address _addressofInstitution) public  {
    RequestofTeacher[_requestingTeacher] = RequestOfTeach(_requestingTeacher,requestedCPDunitsofTeacher,_addressofInstitution);
    }
    
    function SetTotalSupply() public { //initiating function that gives PRC the value of the total supply of CPD Units in circulation
    balances[msg.sender] = __totalSupply;
    }
    
     /// Function facilitates transfer of CPD units from own address to another actor's address.
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(
            balances[msg.sender] >= _value          /// Requirement 1 states that the current address' balance must be greater than the value it will send.
            && _value > 0                           /// Requirement 2 states that the value to send MUST NOT be zero.
        );
        balances[msg.sender] -= _value;             /// Deducts specificed unit value from balance of own address
        balances[_to] += _value;                    /// Adds specified unit value to specified recipient address.
        emit Transfer(msg.sender, _to, _value);     /// Emits the Transfer() event to faciiltate transfer.
        return true;                                /// Confirms if transaction is successful.
    }
     event Transfer(address indexed _from, address indexed _to, uint256 _value);
     
}