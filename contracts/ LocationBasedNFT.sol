// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract LocationBasedNFT is ERC721 {
    // 事前に設定された位置情報を宣言と同時に初期化
    int256 public targetLatitude = 11111;
    int256 public targetLongitude = 22222;

    uint256 public tokenIdCounter;

    // コンストラクタ
    constructor() ERC721("LocationBasedNFT", "LBNFT") {
        tokenIdCounter = 1; // 初期トークンIDを1に設定
    }

    // 位置情報を受け取り、条件が一致するか確認し、一致すればNFTを発行
    function mintNFT(int256 _latitude, int256 _longitude) public {
        require(_latitude == targetLatitude, "Latitude does not match.");
        require(_longitude == targetLongitude, "Longitude does not match.");

        // NFTをミント
        _safeMint(msg.sender, tokenIdCounter);
        tokenIdCounter++;
    }
}
