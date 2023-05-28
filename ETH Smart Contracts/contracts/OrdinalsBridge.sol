//SPDX-License-Identifier: Unlicense

pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

interface AggregatorInterface{
    function latestAnswer() external view returns (uint256);
}

contract OrdinalsBridge is OwnableUpgradeable, IERC721Receiver {

    uint public fee;
    address public payment_account;
    uint public txCount;

    mapping(address => mapping(uint => uint)) public isNftLocked;

    AggregatorInterface chainlinkRef;

    function init(AggregatorInterface _chainlinkRef) external initializer {
        chainlinkRef = _chainlinkRef;
        payment_account = msg.sender;
        fee = 5e18;  // 5$
        __Ownable_init();
    }

    mapping(address => mapping(uint => uint)) public nonces;

    event Bridge2Ordinals(uint txId, address collection, uint tokenId, string dstAddress, bool takeFee, uint nonce);
    event SetFee(uint fee);
    event SetPaymentAccount(address paymentAccount);


    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes memory _data) public returns(bytes4) {
        // Your implementation here
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }

    function bridge2Ordinals(IERC721 collection, uint256 tokenId, bool takeFee, string memory dstAddress) external payable {
        uint eth_fee = 0;
        if(takeFee) {
            eth_fee = fee * 1e8 / AggregatorInterface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419).latestAnswer();
        }   
        require(msg.value >= eth_fee, "Must pay fee");
        if(msg.value > eth_fee)
            payable(msg.sender).transfer(msg.value - eth_fee);
        if(eth_fee > 0)
            payable(payment_account).transfer(eth_fee);
        collection.safeTransferFrom(msg.sender, address(this), tokenId);
        isNftLocked[address(collection)][tokenId] = ++txCount;
        emit Bridge2Ordinals(txCount, address(collection), tokenId, dstAddress, takeFee, nonces[address(collection)][tokenId] ++);
    }

    function setFee(uint fee_) external onlyOwner {
        fee = fee_;
        emit SetFee(fee_);
    }

    function set_payment_account(address payment_account_) external onlyOwner {
        payment_account = payment_account_;
        emit SetPaymentAccount(payment_account_);
    }
    
}