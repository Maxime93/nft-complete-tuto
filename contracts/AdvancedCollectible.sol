pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract AdvancedCollectible is ERC721, VRFConsumerBase {

    bytes32 internal keyHash;
    uint256 public fee;
    uint256 public tokenCounter = 0;

    enum Breed{PUG, SHIBA_INU, ST_BERNARD}

    mapping(bytes32 => address) public requestIdToSender;
    mapping(bytes32 => string) public requestIdToTokenURI;
    mapping(uint256 => Breed) public tokenIdToBreed;
    mapping(bytes32 => uint256) public requestIdToTokenId;
    event requestedCollectible(bytes32 indexed requestId);

    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyHash) public
    VRFConsumerBase(_VRFCoordinator, _LinkToken)
    ERC721("Doggies", "Dog")
    {
        keyHash = _keyHash;
        fee = 0.1 * 10 ** 18; // 0.1 LINK
    }

    function createCollectible(uint256 userProvidedSeed, string memory tokenURI)
    public returns (bytes32){
        // What is tokenURI? It's the endpoint thatt returns JSON that has the metadata of the NFT.
        // Where is this stored? If centralized storage that is useless?
        // Therefore we store that on IPFS or Filecoin.

        // We are requesting a random number from the user, and we verify it
        bytes32 requestId = requestRandomness(keyHash, fee);
        requestIdToSender[requestId] = msg.sender;
        requestIdToTokenURI[requestId] = tokenURI;
        emit requestedCollectible(requestId);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber) internal override {
        // When we call chainlink with a randomness request, the chainlink node
        // responds by calling this function. It returns the request in
        // question and the newly generated random number

        address dogOwner = requestIdToSender[requestId]; // unpacking more or less gas than msg.sender?
        string memory tokenURI = requestIdToTokenURI[requestId];
        uint256 newItemId = tokenCounter;

        // we inherit this from ERC721
        _safeMint(dogOwner, newItemId);
        _setTokenURI(newItemId, tokenURI);

        // We assign a breed from the randomness
        Breed breed = Breed(randomNumber % 3);

        tokenIdToBreed[newItemId] = breed;
        requestIdToTokenId[requestId] = newItemId;

        // Increment the counter;
        tokenCounter = tokenCounter + 1;
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        // we only want the owner to be able to do this
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner or approved"
        );
        _setTokenURI(tokenId, _tokenURI);
    }
}