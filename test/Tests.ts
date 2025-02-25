import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";

describe("Multisig Wallet", function () {
  async function deployMultiSigWallet() {

    const ADDRESS_ZERO = '0x0000000000000000000000000000000000000000'

    const [owner1, owner2] = await hre.ethers.getSigners();

    const MultisigWalet = await hre.ethers.getContractFactory("LockedMultySigWallet");
    const multisigWallet = await MultisigWalet.deploy();

    return { multisigWallet, owner1, owner2, ADDRESS_ZERO };
  }

  describe("Deployment", function () {
    it("Should deploy the contract", async function () {
      const { multisigWallet, ADDRESS_ZERO } = await deployMultiSigWallet();
      expect(multisigWallet.target).to.be.not.equal(ADDRESS_ZERO);
    });
  });

  describe("Add Owner", function () {
    it("Should add owner", async () => {
      const { multisigWallet, owner1 } = await deployMultiSigWallet();
      await multisigWallet.addOwner(owner1.address);
      expect(await multisigWallet.owners(owner1.address)).to.be.equal(true);
    })
  });

  describe("Remove Owner", function () {
    it("Should remove owner", async () => {
      const { multisigWallet, owner1 } = await deployMultiSigWallet();
      await multisigWallet.removeOwner(owner1.address);
      expect(await multisigWallet.owners(owner1.address)).to.be.equal(false);
    })
  });

  describe("Make a deposite", function() {
    it("Should make a deposite", async () => {
      const { multisigWallet,  } = await deployMultiSigWallet();

      await multisigWallet.deposit(10000);

      const transactionsCountAfter = await multisigWallet.transactionsCount();

      expect(transactionsCountAfter).to.be.equal(1);
    })
  })

  describe("Approuve transaction", function() {
    it("Should approve a transaction", async () => {
      const { multisigWallet, owner1 } = await deployMultiSigWallet();

      await multisigWallet.deposit(10000);

      await new Promise(resolve => setTimeout(resolve, 10));

      await multisigWallet.approveTransaction(1);

      expect((await multisigWallet.transactions(1)).isValidated).to.be.equal(true);
    })
  });
});
