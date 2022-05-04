pragma solidity ^0.5.0;

contract Decentragram {
    string public name = "Decentragram";

    // Store Posts
    uint256 public imageCount = 0;
    mapping(uint256 => Image) public images;

    struct Image {
        uint256 id;
        string hash;
        string description;
        uint256 tipAmount;
        address payable author;
    }

    event ImageCreated(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    event ImageTipped(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    // Create Posts
    function uploadImage(string memory _imgHash, string memory _description)
        public
    {
        // Ensures image hash exists
        require(bytes(_imgHash).length > 0);

        // Ensures post description exists
        require(bytes(_description).length > 0);

        // Ensures uploader address exists
        require(msg.sender != address(0x0));

        // Increment image id
        imageCount++;

        // Add image to contract
        images[imageCount] = Image(
            imageCount,
            _imgHash,
            _description,
            0,
            msg.sender
        );

        // Trigger an event
        emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
    }

    // Tip Posts
    function tipImageOwner(uint256 _id) public payable {
        // Id is valid
        require(_id > 0 && _id <= imageCount);
        // Get post
        Image memory _image = images[_id];

        // Get author
        address payable _author = _image.author;

        // Tip author with desired amount
        address(_author).transfer(msg.value);

        // Increment tip amount
        _image.tipAmount = _image.tipAmount + msg.value;

        // Update the image
        images[_id] = _image;

        // Trigger an event
        emit ImageTipped(
            _id,
            _image.hash,
            _image.description,
            _image.tipAmount,
            _author
        );
    }
}
