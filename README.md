# wrapped-mavericks

This is a minimal wrapper for the EVMaverick contract.

It should:
- let an user lock a given EVM, and mint a corresponding wrapped EVM with the same token id
- let an user burn a wrapped EVM, and get back the locked EVM of the same token id
- show fixed metadata for wrapped EVMs (unless the community decides trait rarity doesn't matter, in which case baseURI can point to the old metadata) 
- have upgradeable royalties, controlled by the community multisig
- let the multisig withdraw ETH and ERC20s from the contract
