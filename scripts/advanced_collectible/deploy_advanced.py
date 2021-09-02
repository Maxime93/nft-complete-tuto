from brownie import AdvancedCollectible, accounts, network, config
from scripts.helpful_scripts import fund_advanced_collectible

def main():
    # We are deploying to the rinkeby testnet. Therefore we need a wallet.
    dev = accounts.add(config['wallets']['from_key'])
    # print(dev) # 0xe16Bd85C59f7A75350350676D798A1C193F9e7f0 which is my private key address
    print("Network: " + network.show_active())
    publish_source = False
    advanced_collectible = AdvancedCollectible.deploy(
        config['networks'][network.show_active()]['vrf_coordinator'],
        config['networks'][network.show_active()]['link_token'],
        config['networks'][keyHash]['link_token'],
        {"from": dev},
        publish_source=publish_source
    ) # This is an address (where our contract lives)
    fund_advanced_collectible(advanced_collectible)
    return advanced_collectible
