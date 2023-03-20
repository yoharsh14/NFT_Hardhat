# What are we going to do
1. Basic NFT
2. Random IPFS NFT
3. Dynamic SVG NFT


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