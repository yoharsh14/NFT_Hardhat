// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

error RandomIpfsNft__RangeOutOfBounds();
error RandomIpfsNft__NeedMoreETHSent();
error RandomIpfsNft__TransferFailed();

contract RandomIpfsNft is VRFConsumerBaseV2, ERC721URIStorage, Ownable {
    // when we mint an NFT, we will trigger a ChainLink VRF call to get us a random number
    // using that number, we ill get a random NFT
    //Pug, Shiba Inu,St. Bernard
    //Pug to super rare
    //Shiba sort of rare
    //St. brenard common

    //users have to pay to mint an NFT
    //the owner of the contracts can withdraw the ETH

    /** In order to request an NFT we need to call COORDINATOR.requestRandomWords but before that we have to collect
     * keyHash,s_subscriptionId,requestConfirmations,callbackGasLimit,numWords for VRFCoordinator
     */

    // Type declaration
    enum Breed {
        PUG,
        SHIBA_INU,
        ST_BERNARD
    }
    //Chainlink VRF Variable
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    uint64 private immutable i_subscriptionId;
    bytes32 private immutable i_gasLane;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    //VRF Helpers
    mapping(uint256 => address) public s_requestIdToSender;

    //NFT Variables
    uint256 public s_tokenCounter;
    uint256 internal constant MAX_CHANCE_VALUE = 100;
    string[] internal s_dogTokenUris;
    uint256 internal immutable i_mintFee;

    //Events
    event NftRequested(uint256 indexed requestId, address requester);
    event NftMinted(Breed dogBreed, address minter);

    //Constructor
    constructor(
        address vrfCoordinatorV2,
        uint64 subscriptionId,
        bytes32 gasLane,
        uint32 callbackGasLimit,
        string[3] memory dogTokenUris,
        uint256 mintFee
    ) VRFConsumerBaseV2(vrfCoordinatorV2) ERC721("RandomIpfsNft", "RIN") {
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_subscriptionId = subscriptionId;
        i_gasLane = gasLane;
        i_callbackGasLimit = callbackGasLimit;
        s_dogTokenUris = dogTokenUris;
        i_mintFee = mintFee;
    }

    // if we call requestNft then it will be in two transactions
    // 1. requestNft
    // 2. chainlink will call fulfillRandomWords
    function requestNft() public payable returns (uint256 requestId) {
        if (msg.value < i_mintFee) {
            revert RandomIpfsNft__NeedMoreETHSent();
        }
        requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
        s_requestIdToSender[requestId] = msg.sender;
        emit NftRequested(requestId, msg.sender);
    }

    /**Problem: Here what happens is when we call requestNft it will run itselft and with this chainlink
     * node will call fullfillRandomWords, then we will get a random words, what if we put _safeMint
     * function for minting NFT, but this doesn't work becase _safeMint takes *msg.sender* so here the
     * fulfillRandomWords is called by whome guess that, exactly the chainlink node. So we can't put
     * the _safeMint function inside the fulfillRandomWords.
     *
     * Solution: So now there is a big question,How can Mint NFT but also know which address have which NFT.
     * So what we can do is you see there is one common thing between requresNft and fulfillRandomWords is
     * requestId, so we can do is we will create a mappings and map requestId with address, And after creating
     * the mappings, we will map requestId with msg.sender and we will use _safeMint in the fulfillRandomWords
     * but before calling _safeMint we will call the _safeMint with the address that is mapped with requestId,
     * And this way its not gona be the chainlink nodes who is calling the safe min but the requester
     */
    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        address dogOwner = s_requestIdToSender[requestId];
        uint256 newTokenId = s_tokenCounter;

        //What does this token look like?
        uint256 moddedRng = randomWords[0] % MAX_CHANCE_VALUE;
        //0- 99
        // 7 -> PUG
        // 88 -> St.Bernard
        // 45 -> St.Bernard
        // 12 -> Shiba Inu

        Breed dogBreed = getBreedFromModdedRng(moddedRng);
        _safeMint(dogOwner, newTokenId);
        _setTokenURI(newTokenId, s_dogTokenUris[uint256(dogBreed)]);
        emit NftMinted(dogBreed, dogOwner);
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) {
            revert RandomIpfsNft__TransferFailed();
        }
    }

    function getBreedFromModdedRng(uint256 moddedRng) public pure returns (Breed) {
        uint256 cumulativeSum = 0;
        uint256[3] memory chanceArray = getChanceArray();
        // moddedRng = 25
        // i = 0
        // cumulativeSum = 0
        for (uint256 i = 0; i < chanceArray.length; i++) {
            if (moddedRng >= cumulativeSum && moddedRng < cumulativeSum + chanceArray[i]) {
                return Breed(i);
            }
            cumulativeSum += chanceArray[i];
        }
        revert RandomIpfsNft__RangeOutOfBounds();
    }

    function getChanceArray() public pure returns (uint256[3] memory) {
        return [10, 60, MAX_CHANCE_VALUE];
    }

    function getMinFee() public view returns (uint256) {
        return i_mintFee;
    }

    function getDogTokenUris(uint256 index) public view returns (string memory) {
        return s_dogTokenUris[index];
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
