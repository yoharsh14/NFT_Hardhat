# What are we going to do
1. Basic NFT ✅ address: 0xc5F7605579BF5F2C7d7eCE1dE54803Dd6cad6e65
2. Random IPFS NFT ✅ address: 0xdf204af5928A72716e05c6fc5bADC46aD250dE43
- Pros: Cheap
- const: Someone needs to pin our data
3. Dynamic SVG NFT ✅ address 0x3F9aF05a63C180056ec60783032C0D5De7154eCd
-Pros: the data is on chain!
- cons: Much more expensive!
If price of ETH is above X --> Happy Face
If its' below --> frawn face
# What is NTF's
- NFT's also known as ERC721 standard
- NFT means Non-Fungible Tokens, that means never two bill/assets/digital objects have same value, like charlizard != pikachu
- Fungible tokens are those token which have same value, like 1LINK == 1LINK.

- Nowadays basic use case of NFT's are art!
- axie infinity 9 digital plots in 1.5 million dollors
- There is another standard which is semi-fungible tokens, that standard is ERC-1155

- main d/f between ERC20 and ERC721 is in ERC20 there is simple mappings `mappings(address=>uint256) balance ` but in ERC721 it has unique token ID's, each token ID has a unique owner and in addition they have token URI, each token is unique and each token ID represent a uinque asset.

- if a asset is unique we want to visvualize, know their property and how it look like. For this there comes the Metadata and token UIR's come in.
- so storing image of an asset is  very very high, sometimes we can store but most of the time not.
- for storing there come another standard token URI
 - A UIR is a string containing characters that identify a physical or logical resource. URI follows syntax rules to ensure uniformity. Moreover, it also maintains extensibility via a hierarchical naming scheme. The full form of URI is Uniform Resource Identifier.
 - we can use simple centralized API or IPFS to actually get that token URI. 
 - Typical URI has following fields `{"name":"Name", "description":"Description","image":"URI","attribute":[]}`
 - There is a different URI, namely Image UIR which points to the image.
 - Disclamer: If you store Image on IPFS it could be lost if IPFS gets shut down
 ### steps:
    1. Get IPFS
    2. Add tokenURI json file to IPFS
    3. Add IPFS URI to your NFT URI.
## we go through creating 3 differenct kinds of NFT's 
 1. A Basic NFT
 2. IPFS Hosted NFT
   - That uses Radomness t ogenerate uniques NFT
 3. SVG NFT (Hosted 100% on chain)
  - uses price feeds to be dynamic


  # How RandomIpfsNft works
  ## Variables used
    ### Chainlink VRF Variables
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    uint64 private immutable i_subscriptionId;
    bytes32 private immutable i_gasLane;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    ### VRF Helper
    - mapping(uint256 => address) public s_requestIdToSender;
    ### NFT Variable
    uint256 public s_tokenCounter;
    uint256 internal constant MAX_CHANCE_VALUE = 100;
    string[] internal s_dogTokenUris;
    uint256 internal immutable i_mintFee;