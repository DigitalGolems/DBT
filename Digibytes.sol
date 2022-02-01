// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
pragma solidity ^0.8.10;

import "./ERC20.sol";
import "../Utils/Owner.sol";
import "../Utils/SafeMath.sol";

contract Digibytes is ERC20, Owner {

    using SafeMath for uint256;

    address private presale;

    constructor() ERC20("Digibytes", "DBT"){
        _mint(msg.sender, 500000000 * 10**18);
    }

    function setPresaleAddress(address _presale) external isOwner {
        require(_presale != address(0), "0 address");
        presale = _presale;
    }

    //there is a notPausedAccounts for example - Game
    //we should have possibilty to buy game items
    function addNotPausedAddress(address address_) external isOwner {
        _notPausedAddresses[address_] = true;
    }

    //deleting not pausedAddress
    function deleteNotPausedAddress(address address_) external isOwner {
        _notPausedAddresses[address_] = false;
    }

    //ONLY FOR TEST
    function mockPaused(uint256 _time, address _mockPausedAddress) external isOwner{
        _timeWhenPaused[_mockPausedAddress] = _time;
    }

    //ONLY FOR TEST
    function pausedMonth(address sender, uint8 _month) external view isOwner returns(bool) {
        return _pausedMonth[sender][_month];
    }

    function getTimeWhenPaused(address account) external view returns (uint256) {
        return _timeWhenPaused[account];
    }

    //adding to paused user that bought on presale
    function addPaused(uint256 _amount, uint256 _time, address _sender) external onlyPresale {
        _pausedBalances[_sender] = _pausedBalances[_sender].add(_amount);
        _alwaysPausedBalances[_sender] = _alwaysPausedBalances[_sender].add(_amount);
        _timeWhenPaused[_sender] = _time;
    }

    //manually deleting paused user that bought on presale
    function deletePaused(address _sender) external isOwner {
        _pausedBalances[_sender] = 0;
        _alwaysPausedBalances[_sender] = 0;
        _timeWhenPaused[_sender] = 0;
    }

    function changeEndedMonth(uint8 _newMonth) external isOwner {
        endedMonth = _newMonth;
    }

    function changeUnblockPercent(uint8 _newPercent) external isOwner {
        percentUnblock = _newPercent;
    }

    function getSomeAlwaysAmount(address sender) public view returns(uint256)  {
        return _alwaysPausedBalances[sender];
    }

    modifier onlyPresale(){
        require(presale != address(0), "Presale is 0");
        require(msg.sender == presale, "Only Presale");
        _;
    }

}