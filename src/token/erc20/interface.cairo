use openzeppelin::utils::serde::SpanSerde;
use starknet::ContractAddress;
use array::SpanTrait;

#[abi]
trait IERC20 {
    fn name() -> felt252;
    fn symbol() -> felt252;
    fn decimals() -> u8;
    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256;
    fn approve(spender: ContractAddress, amount: u256) -> bool;
    fn transfer(recipient: ContractAddress, amount: u256) -> bool;
    // fn transfer(recipient: ContractAddress, amount: u256) -> felt252; // https://github.com/OpenZeppelin/cairo-contracts/blob/release-v0.5.0/src/openzeppelin/token/erc20/library.cairo shows the standard erc20 transfer() function returned a felt, not a bool...

    fn total_supply() -> u256;
    fn balance_of(account: ContractAddress) -> u256;
    fn transfer_from(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool;
    fn increase_allowance(spender: ContractAddress, added_value: u256) -> bool; // maybe try returning a felt252 here too in case of error;
    fn decrease_allowance(spender: ContractAddress, subtracted_value: u256) -> bool; // maybe try returning a felt252 here too in case of error;

}

// camelCase ABI support for contracts using camelCase naming for functions (for example, the ETH contract)
#[abi]
trait IERC20Camel {
    fn name() -> felt252;
    fn symbol() -> felt252;
    fn decimals() -> u8;
    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256;
    fn approve(spender: ContractAddress, amount: u256) -> bool;
    fn transfer(recipient: ContractAddress, amount: u256) -> bool;
    // fn transfer(recipient: ContractAddress, amount: u256) -> felt252; // https://github.com/OpenZeppelin/cairo-contracts/blob/release-v0.5.0/src/openzeppelin/token/erc20/library.cairo shows the standard erc20 transfer() function returned a felt, not a bool...

    fn totalSupply() -> u256;
    fn balanceOf(account: ContractAddress) -> u256;
    fn transferFrom(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool;
    fn increaseAllowance(spender: ContractAddress, added_value: u256) -> bool; // maybe try returning a felt252 here too in case of error;
    fn decreaseAllowance(spender: ContractAddress, subtracted_value: u256) -> bool; // maybe try returning a felt252 here too in case of error;
}