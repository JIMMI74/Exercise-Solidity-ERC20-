const NeoToken = artifacts.require("NeoToken");
const USDTJ = artifacts.require("USDTJ");
const Intermediary = artifacts.require("Intermediary");

module.exports = async function(deployer, network, accounts) {
await deployer.deploy(NeoToken)
const neoToken = await NeoToken.deployed()
  console.log("Neo Token deployed: ", neoToken.address)

  await deployer.deploy(USDTJ)
  const usdtj = await USDTJ.deployed()
  console.log("StableCoin USTDJ deployed: ", usdtj.address)


  await deployer.deploy(Intermediary, neoToken.address, usdtj.address)
  const intermediary = await Intermediary.deployed()
  console.log(" Intermediary deployed: ", intermediary.address)

  // Transfer all tokens to DecentralBank (1 million)
  await neoToken.transfer(Intermediary.address, '1000000000000000000000000')
  console.log(intermediary.address)

  // Transfer 100 Mock Tether tokens to investor
  await usdtj.transfer(accounts[1], '100000000000000000000')


};