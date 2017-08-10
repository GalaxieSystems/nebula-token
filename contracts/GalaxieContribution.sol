pragma solidity ^0.4.13;

import './utils/SafeMath.sol';
import './Nebula.sol';

contract GalaxieContribution {
    using SafeMath for uint;

    Nebula public nebula;           /// Address of the Nebula Coin

    address public galaxie;         /// Galaxie Multisig Wallet
    address public founder1;        /// CTO of Galaxie Systems
    address public founder2;        /// CEO of Galaxie Systems
    address public coldStorage;     /// Timelocked storage of 20% of NEBs
    address public earlyAdopter;    /// 2% allocated to early community

    uint public constant FOUNDER_STAKE1 = 0;
    uint public constant FOUNDER_STAKE2 = 0;
    uint public constant EARLY_CONTRIBUTOR_STAKE = 0;
    uint public constant COMMUNITY_STAKE = 0;
    uint public constant CONTRIBUTION_STAKE = 0;

    uint public minContributionAmount = 0.01 ether;
    uint public maxGasPrice = 50000000000;      // 50 GWei

    uint public constant VESTING_PERIOD = 24 weeks;

    bool public tokenTransfersEnabled = false;

    struct Contributor {
        uint amount;
        bool isCompensated;
    }

    uint public startTime;
    uint public endTime;

    uint public capAmount;
    bool public capReached;
    bool public isEnabled;
    uint public totalContributed;

    address[] public contributorKeys;
    mapping (address => Contributor) contributors;

    function GalaxieContribution(address _galaxie,
                                 address _founder1,
                                 address _founder2,
                                 address _coldStorage,
                                 address _earlyAdopter)
    {
        galaxie = _galaxie;
        founder1 = _founder1;
        founder2 = _founder2;
        coldStorage = _coldStorage;
        earlyAdopter = _earlyAdopter;
    }

    function isContributionRunning()
        constant returns (bool)
    {
        assert(!capReached 
               && isEnabled
               && startTime <= now
               && endTime > now);
        return true;
    }

    function contribute()
        payable
        frozenInEmergency
        public 
    {
        contributeWithAddress(msg.sender);
    }

    function contributeWithAddress(address _contributor)
        payable
        frozenInEmergency
        public
    {
        require(tx.gasPrice <= maxGasPrice);
        require(msg.value >= minContributionAmount);
        require(isContributionRunning());

        uint contribution = msg.value;
        uint excess = 0;

        uint oldTotalContributed = totalContributed;

        totalContributed = oldTotalContributed.add(contribution);
        uint newTotalContributed = totalContributed;

        if (newTotalContributed >= capAmount) {
            capReached = true;
            endTime = now;

            excess = totalContributed.sub(capAmount);
            contribution = contribution.sub(excess);

            totalContributed = capAmount;
        }

        if (contributors[_contributor] == 0x0) {
            contributorKeys.push(_contributor);
        }

        contributors[_contributor].amount = contributors[_contributor].amount.add(contribution);

        galaxie.transfer(contribution);
        if (excess > 0) {
            msg.sender.transfer(excess);
        }
        ContributionReceived(newTotalContributed, _contributor, contribution, contributorKeys.length);
    }

    function distributeNebula(uint _offset, uint _limit)
        requireSender(galaxie)
    {
        require(isEnabled);
        require(endTime < now);

        uint i = _offset;
        uint compensateCount = 0;
    }

    modifier requireSender(address _who)
    {
        require(msg.sender == _who);
        _;
    }
}