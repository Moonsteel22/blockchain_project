pragma solidity ^0.8.14;

contract Test{
    address public owner;

    struct AucUser{
        address user;
        uint32 value;
    }

    struct ActiveAuc {
      string auc_name;
      AucUser[] user;
      uint32 max_value;
   }

    mapping(string=> uint32) public auctions;

    mapping(string => ActiveAuc) public active_aucs;

    mapping(string => ) public auc_users;

    mapping(address => string[]) public users;

    mapping(address=> uint) public payments;

    constructor(){
        owner = msg.sender;
    }
    function get_auc_info(string auction) public returns(ActiveAuc){
        return active_aucs[auction];
    }

    function get_aucs(address user) public returns(string[]){
        return users[user];
    }

    function participate_auction(string auc_name) public payable {
        
        users[msg.sender].push(auc_name);
    }

    function get_eths() public payable {
        payments[msg.sender] = msg.value;
    }
    function create_auction(string name, uint32 min_cost){
        auctions[name] = min_cost;
    }

    function withdrawAll() public{
        address payable _to = payable(owner);
        address _this_contract = address(this);
        _to.transfer(_this_contract.balance);
    }
}