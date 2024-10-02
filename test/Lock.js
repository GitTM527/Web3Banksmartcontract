const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("BankContract", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployBankContract() {


    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const BankContract = await ethers.getContractFactory("BankContract");
    const bankcontract = await BankContract.deploy();

    return { bankcontract, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should check if Account is created", async function () {
      const { owner, bankcontract } = await loadFixture(deployBankContract);

      expect(await bankcontract.owner()).to.equal(owner);
    });
  });
})