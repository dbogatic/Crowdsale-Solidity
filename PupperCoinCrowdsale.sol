pragma solidity ^0.5.0;

// Import OpenZeppelin contract libraries

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale, MintedCrowdsale {

    // Fill in the constructor parameters

    constructor(

        uint rate, // Rate in TKNbits
        address payable wallet, // Sale beneficiary
        PupperCoin token, // the PupperCoin itself that the PupperCoinSale will work with
        uint cap, // Total cap in wei
        uint openingTime, // OpeningTime in unix epoch seconds
        uint closingTime, // Closing time in unix epoch seconds
        uint goal // the minimum goal in wei

    )
        // Pass the constructor parameters to the crowdsale contracts.

        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime, closingTime)
        Crowdsale(rate, wallet, token)
        MintedCrowdsale() // Constructor can stay empty
        RefundableCrowdsale(goal) // This crowdsale will, if it doesn't hit `goal`, allow everyone to get their money back
        // by calling claimRefund(...)

        public
    {
        
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(

        //Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet // this address will receive all Ether raised by the sale
    )
        public
    {

        // Create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        // Create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale pupper_sale = new PupperCoinSale(1, wallet, token);
        pupper_sale_address = address(pupper_sale)

        // Make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}

