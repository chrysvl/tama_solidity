// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

contract Tama {
    struct TamaData {
        address owner;
        string name;
        uint256 level;
        uint256 totalExp;
        uint256 lastFeed;
        uint256 lastTrained;
        string[] historyLog;
        bool isListed;
        uint256 listedPrice;
        uint256 marketIndex;
    }

    struct MarketData {
        string name;
        uint256 price;
    }

    mapping(string => TamaData) tamaMap;
    mapping(uint256 => MarketData) marketMap;

    string[] tamaList;

    uint256 marketCounter = 0;

    address initiatorAddress;

    modifier onlyInitiator() {
        require(
            msg.sender == initiatorAddress,
            "Only initiator can execute this action!"
        );
        _;
    }
    modifier onlyOwner(string memory tamaName) {
        require(
            msg.sender == tamaMap[tamaName].owner,
            "Only owner can execute this action!"
        );
        _;
    }

    constructor() {
        initiatorAddress = msg.sender;
    }

    function createTama(string memory tamaName) public {
        bool isExist = isNameExist(tamaName);
        require(
            isExist == false,
            "Name is already taken, please choose another name"
        );
        tamaMap[tamaName].owner = msg.sender;
        tamaMap[tamaName].name = tamaName;
        tamaMap[tamaName].level = 1;
        tamaMap[tamaName].totalExp = 0;
        tamaMap[tamaName].lastFeed = 0;
        tamaMap[tamaName].historyLog.push(
            string(
                abi.encodePacked(
                    Strings.toString(block.timestamp),
                    " | Tama created with name : ",
                    tamaName
                )
            )
        );
        tamaList.push(tamaName);
    }

    function getTamaHistory(string memory tamaName)
        public
        view
        returns (string[] memory historyLog)
    {
        historyLog = tamaMap[tamaName].historyLog;
    }

    function getTama(string memory tamaName)
        public
        view
        returns (
            address owner,
            string memory name,
            uint256 level,
            uint256 totalExp,
            bool isListed,
            uint256 listedPrice
        )
    {
        owner = tamaMap[tamaName].owner;
        name = tamaMap[tamaName].name;
        level = tamaMap[tamaName].level;
        totalExp = tamaMap[tamaName].totalExp;
        isListed = tamaMap[tamaName].isListed;
        listedPrice = tamaMap[tamaName].listedPrice;
    }

    function trainTama(string memory tamaName) public onlyOwner(tamaName) {
        require(
            tamaMap[tamaName].lastTrained < (block.timestamp - 5 minutes),
            "Tama is still tired, wait for 5 minutes"
        );
        uint256 trainEXP = 50;
        tamaMap[tamaName].totalExp += trainEXP;
        tamaMap[tamaName].lastTrained = block.timestamp;
        tamaMap[tamaName].level = calculateExp(tamaMap[tamaName].totalExp);
        tamaMap[tamaName].historyLog.push(
            string(
                abi.encodePacked(
                    Strings.toString(block.timestamp),
                    " | Tama is training and get EXP : ",
                    Strings.toString(trainEXP)
                )
            )
        );
    }

    function feedTama(string memory tamaName) public onlyOwner(tamaName) {
        require(
            tamaMap[tamaName].lastFeed < (block.timestamp - 1 minutes),
            "Tama is still full, wait for 1 minutes"
        );
        uint256 feedEXP = 10;
        tamaMap[tamaName].totalExp += feedEXP;
        tamaMap[tamaName].lastFeed = block.timestamp;
        tamaMap[tamaName].level = calculateExp(tamaMap[tamaName].totalExp);
        tamaMap[tamaName].historyLog.push(
            string(
                abi.encodePacked(
                    Strings.toString(block.timestamp),
                    " | Tama is eating and get EXP : ",
                    Strings.toString(feedEXP)
                )
            )
        );
    }

    function buyExp(string memory tamaName) public payable {
        require(msg.value == 1 ether, "Need to send 1 ETH");
        (bool sent, ) = initiatorAddress.call{value: msg.value}("");
        require(sent, "Failed to send Ether ");
        uint256 potEXP = 100;
        tamaMap[tamaName].totalExp += potEXP;
        tamaMap[tamaName].level = calculateExp(tamaMap[tamaName].totalExp);
        tamaMap[tamaName].historyLog.push(
            string(
                abi.encodePacked(
                    Strings.toString(block.timestamp),
                    " | Tama is getting EXP Potion : ",
                    Strings.toString(potEXP)
                )
            )
        );
    }

    function deleteTama(string memory tamaName) public onlyOwner(tamaName) {
        delete tamaMap[tamaName];
        for (uint256 i = 0; i < tamaList.length; i++) {
            if (keccak256(bytes(tamaList[i])) == keccak256(bytes(tamaName))) {
                tamaList[i] = tamaList[i + 1];
            }
        }
        tamaList.pop();
    }

    function listInETH(string memory tamaName, uint256 priceETH)
        public
        onlyOwner(tamaName)
    {
        tamaMap[tamaName].isListed = true;
        tamaMap[tamaName].listedPrice = priceETH;
        marketMap[marketCounter] = MarketData(tamaName, priceETH);
        tamaMap[tamaName].marketIndex = marketCounter;
        marketCounter++;
        tamaMap[tamaName].historyLog.push(
            string(
                abi.encodePacked(
                    Strings.toString(block.timestamp),
                    " | Tama is getting listed with price : ",
                    Strings.toString(priceETH)
                )
            )
        );
    }

    function cancelListing(string memory tamaName) public onlyOwner(tamaName) {
        tamaMap[tamaName].isListed = false;
        uint256 marketIndex = tamaMap[tamaName].marketIndex;
        delete marketMap[marketIndex];
        tamaMap[tamaName].historyLog.push(
            string(
                abi.encodePacked(
                    Strings.toString(block.timestamp),
                    " | Tama listing has been cancelled"
                )
            )
        );
    }

    function getMarket() public view returns (MarketData[] memory) {
        MarketData[] memory id = new MarketData[](marketCounter);
        for (uint256 i = 0; i < marketCounter; i++) {
            MarketData storage value = marketMap[i];
            id[i] = value;
        }
        return id;
    }

    function buyTama(string memory tamaName) public payable {
        require(tamaMap[tamaName].isListed == true);
        require(
            msg.value >= (tamaMap[tamaName].listedPrice * 1e18),
            "Please send the amount as per this Tama price"
        );
        (bool sent, ) = tamaMap[tamaName].owner.call{value: msg.value}("");
        require(sent, "Failed to send Ether ");
        tamaMap[tamaName].owner = msg.sender;
        tamaMap[tamaName].isListed = false;
        uint256 marketIndex = tamaMap[tamaName].marketIndex;
        delete marketMap[marketIndex];

        tamaMap[tamaName].historyLog.push(
            string(
                abi.encodePacked(
                    Strings.toString(block.timestamp),
                    " | Tama is bought, now the owner is : ",
                    tamaMap[tamaName].owner
                )
            )
        );
    }

    function giveBonus(uint256 expAmount) public onlyInitiator {
        for (uint256 i = 0; i < tamaList.length; i++) {
            tamaMap[tamaList[i]].totalExp += expAmount;
            tamaMap[tamaList[i]].level = calculateExp(
                tamaMap[tamaList[i]].totalExp
            );
            tamaMap[tamaList[i]].historyLog.push(
                string(
                    abi.encodePacked(
                        Strings.toString(block.timestamp),
                        " | Tama is getting bonus EXP : ",
                        Strings.toString(expAmount)
                    )
                )
            );
        }
    }

    function isNameExist(string memory tamaName)
        private
        view
        returns (bool isExist)
    {
        isExist = false;
        for (uint256 i = 0; i < tamaList.length; i++) {
            if (keccak256(bytes(tamaList[i])) == keccak256(bytes(tamaName))) {
                isExist = true;
                break;
            }
        }
        return isExist;
    }

    function calculateExp(uint256 totalExp)
        private
        pure
        returns (uint256 Level)
    {
        Level = (25 + Math.sqrt(625 + 100 * totalExp)) / 50;
    }
}
