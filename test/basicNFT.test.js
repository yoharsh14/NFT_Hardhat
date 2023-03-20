const { assert } = require("chai");
const { network, getNamedAccounts, deployments, ethers } = require("hardhat");
const { developmentChains, networkConfig } = require("../helper-hardhat.config");

!developmentChains.includes(network.name)
    ? describe.skip()
    : describe("Basic NFT test", () => {
          let basicNft, deployer;
          const chainId = networkConfig.chainId;

          beforeEach(async () => {
              deployer = (await getNamedAccounts()).deployer;
              await deployments.fixture(["all"]);
              basicNft = await ethers.getContract("BasicNFT", deployer);
          });

          describe("constructor", () => {
              it("NFT Name is set properly", async () => {
                  const name = await basicNft.name();
                  assert.equal(name, "OGDogie");
              });
              it("NFT Symbol is set properly", async () => {
                  const symbol = await basicNft.symbol();
                  assert.equal(symbol, "OG");
              });
              it("NFT Counter Id is set properly", async () => {
                  const counter = await basicNft.getTokenCounter();
                  assert.equal(counter, 0);
              });
          });
          describe("Minting NFT", () => {
              beforeEach(async () => {
                  const txResponse = await basicNft.mintNft();
                  await txResponse.wait(1);
              });
              it("Allow users to mint NFT, and updates appropriately", async () => {
                  const tokenURI = await basicNft.tokenURI(0);
                  const counter = await basicNft.getTokenCounter();
                  assert.equal(tokenURI, await basicNft.TOKEN_URI());
                  assert.equal(counter.toString(), "1");
              });
              it("Show correct balance and owner of an NFT", async () => {
                  const deployerAddress = deployer;
                  const deployerBalance = await basicNft.balanceOf(deployerAddress);
                  const owner = await basicNft.ownerOf("0");
                  assert.equal(owner, deployerAddress);
                  assert.equal(deployerBalance.toString(), "1");
              });
          });
      });
