// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Twitter{

    struct Tweet{
        uint id;
        address author;
        string content;
        uint createdAt;
    }

    struct Message{
        uint id;
        string content;
        address from;
        address to;
        uint createdAt;
    }

    struct UserTweet{
        string content;
        uint createdAt;
    }

    mapping(uint => Tweet) public tweets;
    //mapping(address => uint[]) public tweetsOf; // issue
    mapping(address => Message[]) public conversations;
    mapping(address => mapping(address => bool)) public operators;
    mapping(address => address[]) public following;

    uint nextId;
    uint nextMessageId;

    function _tweet(address _from, string memory _content) internal {
        tweets[nextId] = Tweet(nextId, _from, _content, block.timestamp);
        nextId++;
    }

    function _sendMessage(address _from, address _to, string memory _content) internal {
        conversations[_from].push(Message(nextMessageId, _content, _from, _to, block.timestamp)); 
    }

    function tweet(string memory _content) public {
        _tweet(msg.sender, _content);
    }

    function Prtweet(address _from, string memory _content) public {
        _tweet(_from, _content);
    } 

    function sendMessage(address _to, string memory _content) public {
        _sendMessage(msg.sender, _to, _content);
    }

    function PrSendMessage(address _from, address _to, string memory _content) public {
        _sendMessage(_from, _to, _content);
    }

    function follow(address _followed) public {
        following[msg.sender].push(_followed);
    }

    function allow(address _operator) public{
        operators[msg.sender][_operator] = true;
    }

    function disallow(address _operator) public{
        operators[msg.sender][_operator] = false;
    }

    function getLatestTweets(uint _count) public view returns(Tweet[] memory) {
        require(_count > 0 && _count <= nextId, "Count is not proper");
        Tweet[] memory _tweets = new Tweet[](_count);
        uint j;

        for(uint i = nextId - _count; i < nextId; i++) {
            Tweet storage _structure = tweets[i];
            _tweets[j] = Tweet(_structure.id, _structure.author, _structure.content, _structure.createdAt);
            j++;
        }
        
        return _tweets;
    }

    // function getUsersLatestTweets(address _user, uint _count) public view returns(Tweet[] memory) {  // issue 
    //     Tweet[] memory _tweets = new Tweet[](_count);
    //     uint[] memory ids = tweetsOf[_user];
    //     require(_count > 0 && _count <= nextId, "Count is not proper");
    //     uint j;

    //     for(uint i = ids.length - _count; i < ids.length; i++) {
    //         Tweet storage _structure = tweets[ids[i]];
    //         _tweets[j] = Tweet(_structure.id, _structure.author, _structure.content, _structure.createdAt);
    //         j++;
    //     }
        
    //     return _tweets;
    // }

    function TweetCount(address _user) public view returns(uint){
        uint j;
        uint count;

        for(uint i=0; i < nextId; i++){
            Tweet memory _structure = tweets[j];
            if(_structure.author == _user){
                count++;
            }
            j++;
        }
        
        return count;

    } 

    function getUsersLatestTweets(address _user) public view returns(UserTweet[] memory) {
        uint j;
        uint k;
        uint count = TweetCount(_user);
        UserTweet[] memory _usertweets = new UserTweet[](count);      
        for(uint i=0; i < nextId; i++){
            Tweet memory _structure = tweets[j];
            if(_structure.author == _user){
            _usertweets[k] = UserTweet(_structure.content, _structure.createdAt);
            k++;
            j++;
            
            }else{
                j++;

            }
         
        }

        return _usertweets;
    }
       
}


