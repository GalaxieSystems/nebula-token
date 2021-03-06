pragma solidity ^0.4.13;

contract Controlled {

    address public controller;

    function Controlled()
    {
        controller = msg.sender;
    }

    /// @notice Changes the controller of the contract
    /// @param _newController The new controller of the contract
    function changeController(address _newController)
        onlyController
    {
        controller = _newController;
    }

    /// @notice The address of the controller is the only address that can call
    ///  a function with this modifier
    modifier onlyController
    {
        require(msg.sender == controller);
        _;
    }
}