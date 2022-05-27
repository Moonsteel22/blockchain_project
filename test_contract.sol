pragma solidity ^0.8.14;

contract Test{
    address public owner;

    struct Auction{
        string auc_name;
        uint min_value;
    }

    struct ActiveAuc {
      string auc_name;
      address max_user;
      uint max_value;
   }

    mapping(string=> Auction) public auctions;

    mapping(string => ActiveAuc) public active_aucs;

    mapping(address => Auction[]) public users;

    constructor(){
        owner = msg.sender;
    }

    function get_auc_info(string memory auction) public returns(ActiveAuc memory){
        return active_aucs[auction];
    }

    function get_aucs(address user) public view returns(Auction[] memory){
        return users[user];
    }

    function participate_auction(string memory auc_name) public payable{
        users[msg.sender].push(auctions[auc_name]);
        if (active_aucs[auc_name].max_value>0){
            if (active_aucs[auc_name].max_value > msg.value)
                active_aucs[auc_name].max_value = msg.value;
                active_aucs[auc_name].max_user = address(msg.sender);
        }
        else{
            active_aucs[auc_name] = ActiveAuc(auc_name, msg.sender, msg.value);
        }
        
    }

    function auc_lider(string memory auc_name) public returns(address){
        if(active_aucs[auc_name].max_value>0){
            return active_aucs[auc_name].max_user;
        }
    }

    function end_auction(string memory name) public{
        if(msg.sender == owner){
            address payable _to = payable(owner);
            if(active_aucs[name].max_value>0){
                _to.transfer(active_aucs[name].max_value);
            }
        }

    }

    function create_auction(string memory name, uint min_val) public{
        Auction memory _buf = Auction(name,min_val);
        auctions[name] = _buf;
    }

}