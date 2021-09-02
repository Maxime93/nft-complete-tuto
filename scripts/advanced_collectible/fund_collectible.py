from brownie import AdvancedCollectible
from scripts.helpful_scripts import fund_advanced_collectible

def main():
    # AdvancedCollectible is a list of deployed contracts
    # we do this to get the latest deployed contract
    advanced_collectible = AdvancedCollectible[len(AdvancedCollectible) - 1] # this is a contract address
    fund_advanced_collectible(advanced_collectible)
