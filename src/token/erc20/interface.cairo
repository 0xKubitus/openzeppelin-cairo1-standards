#[abi]
trait IERC20 {
    fn name() -> felt252;
    fn symbol() -> felt252;
    fn balance_of(account: ContractAddress) -> u256;
    fn owner_of(token_id: u256) -> ContractAddress;
    fn transfer_from(from: ContractAddress, to: ContractAddress, token_id: u256);
    fn safe_transfer_from(from: ContractAddress, to: ContractAddress, token_id: u256, data: Span<felt252>);
    fn approve(to: ContractAddress, token_id: u256);
    fn set_approval_for_all(operator: ContractAddress, approved: bool);
    fn get_approved(token_id: u256) -> ContractAddress;
    fn is_approved_for_all(owner: ContractAddress, operator: ContractAddress) -> bool;
}

// camelCase ABI support for contracts using camelCase naming for functions (for example, the ETH contract)
#[abi]
trait IERC20Camel {
    fn name() -> felt252;
    fn symbol() -> felt252;
    fn totalSupply() -> u256;
    fn decimals() -> felt252;
    fn balanceOf(account: ContractAddress) -> u256;
    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256;

    fn transfer(recipient: ContractAddress, amount: u256) -> bool;
    // fn transfer(recipient: ContractAddress, amount: u256) -> felt252; // https://github.com/OpenZeppelin/cairo-contracts/blob/release-v0.5.0/src/openzeppelin/token/erc20/library.cairo shows the standard erc20 transfer() function returned a felt, not a bool...
    fn transferFrom(from: ContractAddress, to: ContractAddress, tokenId: u256);
    fn approve(to: ContractAddress, tokenId: u256);
    fn increaseAllowance(spender: ContractAddress, added_value: u256) -> bool; // maybe try returning a felt252 here too in case of error;
    fn decreaseAllowance(spender: ContractAddress, subtracted_value: u256) -> bool; // maybe try returning a felt252 here too in case of error;
}