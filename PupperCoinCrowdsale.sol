pragma solidity ^0.5.0;

// Import OpenZeppelin contract libraries

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale, MintedCrowdsale {
    

    // Fill in the constructor parameters

    constructor(

        uint rate, // Rate in TKNbits
        address payable wallet, // Sale beneficiary
        PupperCoin token, // the PupperCoin itself that the PupperCoinSale will work with
        uint goal, // the minimum goal in wei
        uint cap,
        uint close // close = now + 15 min
        // uint fakenow // for test purposes

    )
        // Pass the constructor parameters to the crowdsale contracts.
        
        CappedCrowdsale(cap)
        TimedCrowdsale(now, now + 15 minutes)
        Crowdsale(rate, wallet, token)
        MintedCrowdsale() // Constructor can stay empty
        RefundableCrowdsale(goal) // This crowdsale will, if it doesn't hit `goal`, allow everyone to get their money back
        // by calling claimRefund(...)

        public
    {
        
    }
}

contract PupperCoinSaleDeployer {

    address public pupper_sale_address;
    address public token_address;

    constructor(

        //Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet, // this address will receive all Ether raised by the sale
        uint goal
        // uint fakenow for test purposes
        
    )
        public
    {

        // Create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        // Create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
         PupperCoinSale pupper_sale = new PupperCoinSale(
                            1, // 1 wei
                            wallet, // address collecting the tokens
                            token, // token sales
                            goal, // maximum supply of tokens 
                            300,
                            now + 15 minutes);
        //replace now by fakenow to get a test function
        
        pupper_sale_address = address(pupper_sale);

        // Make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(pupper_sale_address);
        token.renounceMinter();
    }
}

