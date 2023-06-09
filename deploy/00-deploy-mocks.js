const {network} = require("hardhat")
const {developmentChains, DECIMAL, INITIAL_PRICE} = require("../helper-hardhat-config")



module.exports = async ({getNamedAccounts, deployments}) => {
    const {deploy, log} = deployments
    const {deployer} = await getNamedAccounts()
    const chainId = network.config.chainId

    if (chainId == 31337){
        log("Local Network detected! Deploying mocks...")
        await deploy("MockV3Aggregator", {
            contract: "MockV3Aggregator",
            from: deployer,
            log: true,
            args: [DECIMAL, INITIAL_PRICE],
        })
        log("Mocks Deployed!")
        log("-------------------------------------------")
    }
}


module.exports.tags = ["all", "mocks"]