# wrapped-mavericks

This is a minimal wrapper for the EVMaverick contract.

It should:
- let an user lock a given EVM, and mint a corresponding wrapped EVM with the same token id
- let an user burn a wrapped EVM, and get back the locked EVM of the same token id
- show the same metadata for wrapped EVMs as regular EVMs
- have upgradeable royalties, controlled by the contract owner (ideally, the community multisig)
- let the contract withdraw ETH and ERC20s from the contract
