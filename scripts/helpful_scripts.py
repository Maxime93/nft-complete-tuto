from brownie import AdvancedCollectible, accounts, config, interface, network

def fund_advanced_collectible(nft_contract):
    dev = accounts.add(config['wallets']['from_key'])
    # Interface is a secret way to get the ABI
    # We copied the interface from the chainlink git repo
    link_token = interface.LinkTokenInterface(config['networks'][network.show_active()]['linkToken'])

    # Sending one link to our contract!
    # Our contract needs link to pay for the random number generation
    link_token.transfer(nft_contract, 1000000000000000000, {"from": dev})
