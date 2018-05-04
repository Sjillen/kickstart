pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns;

    function createCampaign(uint minimum) public {
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns(address[]) {
        return deployedCampaigns;
    }
}

contract Campaign {
    struct Request {
        // pupose of the request
        string description;
        // Ether to transfert
        uint value;
        // who gets the money
        address recipient;
        // whether the request is done
        bool complete;
        // track the number of approvals
        uint approvalCount;
        // track who has voted
        mapping(address => bool) approvals;
    }

    // list of requests that the manager has created
    Request[] public requests;
    //address of the person who is managing this campaign
    address public manager;
    //minimum donation required to be considered a contributor or approver
    uint public minimumContribution;
    // list of addresses for every person who has donated money
    mapping(address => bool) public approvers;
    // number of approvers
    uint public approversCounts;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function Campaign(uint minimum, address creator) public {
        manager =  creator;
        minimumContribution = minimum;
    }

    // called when someone wants to donate money to the campaign and become an 'approver'
    function contribute() public payable {
        require(msg.value > minimumContribution);

        approvers[msg.sender] = true;
        approversCounts++;
    }
    // called by the manager to create a new 'spending request'
    function createRequest(string description, uint value, address recipient)
    public restricted
    {
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });
        requests.push(newRequest);
    }

    function approveRequest(uint index) public {
        Request storage request = requests[index];
        // check that sender is an approver
        require(approvers[msg.sender]);
        //check that the approver hasn't already voted
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];
        require(!request.complete);
        require(request.approvalCount > approversCounts / 2);

        request.recipient.transfer(request.value);
        request.complete = true;

    }

}