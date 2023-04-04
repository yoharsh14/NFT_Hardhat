const { assert } = require("chai");
const { network, getNamedAccounts, deployments, ethers } = require("hardhat");
const { developmentChains, networkConfig } = require("../../helper-hardhat.config");

!developmentChains.includes(network.name)
    ? describe.sikp
    : describe("random IPFS NFT Test", async () => {
          let randomIpfsNft, deployer;
          const chainId = networkConfig.chainId;
          beforeEach(async () => {
              deployer = (await getNamedAccounts()).deployer;
              await deployments.fixture(["mocks", "randomIpfs"]);
              randomIpfsNft = await ethers.getContract("RandomIpfsNft");
              vrfCoordinatorV2Mock = await ethers.getContract("VRFCoordinatorV2Mock");
          });
          describe("construntor", async () => {
              it("sets starting values correctly", async () => {
                  const dogTokenUriZero = await randomIpfsNft.getDogTokenUris(0);
                  const isInitialized = await randomIpfsNft.getInitialized();
                  assert(dogTokenUriZero.includes("ipfs://"));
                  assert.equal(isInitialized, true);
              });
          });
          describe("requestNft", () => {});
      });
