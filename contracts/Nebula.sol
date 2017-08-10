pragma solidity ^0.4.13;

import './minime/Minime.sol';

contract Nebula is Minime {

    function Nebula(address _controller,
                    address _tokenFactory)
        Minime(
            _tokenFactory,      // The token factory that can create new NEBs
            0x0,                // No parent
            0,                  // No parent snapshot
            "Nebula",           // Name - Nebula
            18,                 // Decimals - 18
            "NEB",              // Ticker - NEB
            false               // Transfers not enabled to start
        ) {
            changeController(_controller);
        }
}