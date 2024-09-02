const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("LocationBasedNFT", function () {
  let locationBasedNFT;
  let owner;

  beforeEach(async function () {
    [owner] = await ethers.getSigners();

    // コントラクトのデプロイ
    const LocationBasedNFT = await ethers.getContractFactory("LocationBasedNFT");
    locationBasedNFT = await LocationBasedNFT.deploy();
    await locationBasedNFT.waitForDeployment() ;
  });

  it("Should mint NFT if the location matches", async function () {
    // 正しい位置情報を使用してNFTをミント
    const _latitude = 11111;
    const _longitude = 22222;

    const mintTx = await locationBasedNFT.mintNFT(_latitude, _longitude);
    await mintTx.wait();

    const tokenId = 1;
    const ownerOfToken = await locationBasedNFT.ownerOf(tokenId);
    expect(ownerOfToken).to.equal(owner.address);
  });

  it("Should revert if the location does not match", async function () {
    // 間違った位置情報を使用してミントを試みる
    const _latitude = 12345;
    const _longitude = 67890;

    await expect(
      locationBasedNFT.mintNFT(_latitude, _longitude)
    ).to.be.revertedWith("Latitude does not match.");
  });
});
