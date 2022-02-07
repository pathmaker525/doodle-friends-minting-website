// SPDX-License-Identifier: MIT

/**
 * ██████╗  ██████╗  ██████╗ ██████╗ ██╗     ███████╗    ███████╗██████╗ ██╗███████╗███╗   ██╗██████╗ ███████╗
 * ██╔══██╗██╔═══██╗██╔═══██╗██╔══██╗██║     ██╔════╝    ██╔════╝██╔══██╗██║██╔════╝████╗  ██║██╔══██╗██╔════╝
 * ██║  ██║██║   ██║██║   ██║██║  ██║██║     █████╗      █████╗  ██████╔╝██║█████╗  ██╔██╗ ██║██║  ██║███████╗
 * ██║  ██║██║   ██║██║   ██║██║  ██║██║     ██╔══╝      ██╔══╝  ██╔══██╗██║██╔══╝  ██║╚██╗██║██║  ██║╚════██║
 * ██████╔╝╚██████╔╝╚██████╔╝██████╔╝███████╗███████╗    ██║     ██║  ██║██║███████╗██║ ╚████║██████╔╝███████║
 * ╚═════╝  ╚═════╝  ╚═════╝ ╚═════╝ ╚══════╝╚══════╝    ╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═══╝╚═════╝ ╚══════╝
 *
 * This amazing collection consists of 3,353 NFTs, combining a mixture of curated 2D and 3D beautiful characters! 
 * From this 3,353, 2D collection, there will be limited numbers of rare 1 to 1 "3D" Friends available! 
 * As a project, our goal is to be much different by way of choosing a "community first" approach and offering more value than anyone else!
 */

pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./ERC721Pausable.sol";

contract DoodleFriends is ERC721Enumerable, Ownable, ERC721Burnable, ERC721Pausable {

    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdTracker;

    bool public SALE_OPEN = false;

    uint256 private constant MAX_SUPPLY = 3353; // 3353 Doodle Friends
    uint256 private constant MAX_MINT_LIMITED = 3; // 3 batch mint max
    uint256 private constant MAX_MINT_UNLIMITED = 3353; // unlimited batch mint

    uint256 private constant PRICE_WHITELIST_ONE = 0.065 ether; // Stage One for Whitelist
    uint256 private constant PRICE_WHITELIST_TWO = 0.075 ether; // Stage Two for Whitelist
    uint256 private constant PRICE_PUBLIC = 0.085 ether; // Public Sale Price

    uint256 private _price;
    uint256 private _maxMint;

    mapping(uint256 => bool) private _isOccupiedId;
    uint256[] private _occupiedList;

    string private baseTokenURI;

    address private devWallet = payable(0xb1F0F285EA991361e38f4e9e2078BC50237eda76); // Developer Wallet Address
    address private fundWallet = payable(0x269D13DaF86aec35e9bD12684B027CbA597360f1); // Owner Fund Wallet Address

    event DoodleFriendSummoned(address to, uint256 indexed id);

    modifier saleIsOpen {
        if (_msgSender() != owner()) {
            require(SALE_OPEN == true, "SALES: Please wait a big longer before buying Doodle Friends ;)");
        }
        require(_totalSupply() <= MAX_SUPPLY, "SALES: Sale end");

        if (_msgSender() != owner()) {
            require(!paused(), "PAUSABLE: Paused");
        }
        _;
    }

    constructor () ERC721("Doodle Friends", "DoodleFriends") {
    // constructor (string memory baseURI) ERC721("Doodle Friends", "DoodleFriends") {
        // setBaseURI(baseURI);
    }

    function mint(address payable _to, uint256[] memory _ids) public payable saleIsOpen {
        uint256 total = _totalSupply();
        uint256 maxSupply = MAX_SUPPLY;
        uint256 maxMintCount = _maxMint;
        uint256 price = _price;

        require(total + _ids.length <= maxSupply, "MINT: Current count exceeds maximum element count.");
        require(total <= maxSupply, "MINT: Please go to the Opensea to buy Doodle Friends.");
        require(_ids.length <= maxMintCount, "MINT: Current count exceeds maximum mint count.");
        require(msg.value >= price * _ids.length, "MINT: Current value is below the sales price of Doodle Friends");

        for (uint256 i = 0; i < _ids.length; i++) {
            require(_isOccupiedId[_ids[i]] == false, "MINT: Those ids already have been used for other customers");
        }

        for (uint256 i = 0; i < _ids.length; i++) {
            _mintAnElement(_to, _ids[i]);
        }
    }

    function _mintAnElement(address payable _to, uint256 _id) private {
        _tokenIdTracker.increment();
        _safeMint(_to, _id);
        _isOccupiedId[_id] = true;
        _occupiedList.push(_id);

        emit DoodleFriendSummoned(_to, _id);
    }

    function startWhitelistOne() public onlyOwner {
        SALE_OPEN = true;

        _price = PRICE_WHITELIST_ONE;
        _maxMint = MAX_MINT_LIMITED;
    }

    function startWhitelistTwo() public onlyOwner {
        SALE_OPEN = true;

        _price = PRICE_WHITELIST_TWO;
        _maxMint = MAX_MINT_UNLIMITED;
    }

    function startPublicSale() public onlyOwner {
        SALE_OPEN = true;

        _price = PRICE_PUBLIC;
        _maxMint = MAX_MINT_UNLIMITED;
    }

    function flipSaleState() public onlyOwner {
        SALE_OPEN = !SALE_OPEN;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        baseTokenURI = baseURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function _totalSupply() internal view returns (uint256) {
        return _tokenIdTracker.current();
    }

    function getPrice() public view returns (uint256) {
        return _price;
    }

    function maxSupply() public view returns (uint256) {
        return MAX_SUPPLY;
    }

    function occupiedList() public view returns (uint256[] memory) {
        return _occupiedList;
    }

    function maxMint() public view returns (uint256) {
        return _maxMint;
    }

    function raised() public view returns (uint256) {
        return address(this).balance;
    }

    function getTokenIdsOfWallet(address _owner) external view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);

        uint256[] memory tokensId = new uint256[](tokenCount);

        for (uint256 i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }

        return tokensId;
    }

    function withdrawAll() public payable onlyOwner {
        uint256 totalBalance = address(this).balance;
        require(totalBalance > 0, "WITHDRAW: No balance in contract");

        uint256 devBalance = totalBalance / 10; // 10% of total sale
        uint256 ownerBalance = totalBalance - devBalance; // 90% of total sale

        _widthdraw(devWallet, devBalance);
        _widthdraw(fundWallet, ownerBalance);
    }

    function _widthdraw(address _address, uint256 _amount) private {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "WITHDRAW: Transfer failed.");
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}