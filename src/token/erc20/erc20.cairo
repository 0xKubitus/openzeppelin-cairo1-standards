use starknet::ContractAddress;

#[abi]
trait IERC20ABI {
    // case agnostic view functions
    fn name() -> felt252;
    fn symbol() -> felt252;
    fn decimals() -> u8;
    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256;

    // snake_case view functions
    fn total_supply() -> u256;
    fn balance_of(account: ContractAddress) -> u256;

    // camelCase view functions
    fn totalSupply() -> u256;
    fn balanceOf(account: ContractAddress) -> u256;

    // case agnostic external functions
    fn transfer(recipient: ContractAddress, amount: u256) -> bool;
    fn approve(spender: ContractAddress, amount: u256) -> bool;

    // snake_case external functions
    fn transfer_from(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool;
    fn increase_allowance(spender: ContractAddress, added_value: u256) -> bool;
    fn decrease_allowance(spender: ContractAddress, subtracted_value: u256) -> bool;

    // camelCase external functions
    fn transferFrom(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool;
    fn increaseAllowance(spender: ContractAddress, added_value: u256) -> bool;
    fn decreaseAllowance(spender: ContractAddress, subtracted_value: u256) -> bool;

}

#[contract]
mod ERC20 {
    use openzeppelin::token::erc20;
    use integer::BoundedInt;
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use zeroable::Zeroable;

    struct Storage {
        _name: felt252,
        _symbol: felt252,
        _total_supply: u256,
        _balances: LegacyMap<ContractAddress, u256>,
        _allowances: LegacyMap<(ContractAddress, ContractAddress), u256>,
    }

    #[event]
    fn Transfer(from: ContractAddress, to: ContractAddress, value: u256) {}

    #[event]
    fn Approval(owner: ContractAddress, spender: ContractAddress, value: u256) {}

    #[constructor]
    fn constructor(
        name: felt252, symbol: felt252, initial_supply: u256, recipient: ContractAddress
    ) {
        initializer(name, symbol);
        _mint(recipient, initial_supply);
    }

    impl ERC20Impl of erc20::interface::IERC20 {
        fn name() -> felt252 {
            _name::read()
        }

        fn symbol() -> felt252 {
            _symbol::read()
        }

        fn decimals() -> u8 {
            18_u8
        }

        fn total_supply() -> u256 {
            _total_supply::read()
        }

        fn balance_of(account: ContractAddress) -> u256 {
            _balances::read(account)
        }

        fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256 {
            _allowances::read((owner, spender))
        }

        fn transfer(recipient: ContractAddress, amount: u256) -> bool {
            let sender = get_caller_address();
            _transfer(sender, recipient, amount);
            true
        }

        fn transfer_from(
            sender: ContractAddress, recipient: ContractAddress, amount: u256
        ) -> bool {
            let caller = get_caller_address();
            _spend_allowance(sender, caller, amount);
            _transfer(sender, recipient, amount);
            true
        }

        fn approve(spender: ContractAddress, amount: u256) -> bool {
            let caller = get_caller_address();
            _approve(caller, spender, amount);
            true
        }

        fn increase_allowance(spender: ContractAddress, added_value: u256) -> bool {
            _increase_allowance(spender, added_value)
        }

        fn decrease_allowance(spender: ContractAddress, subtracted_value: u256) -> bool {
            _decrease_allowance(spender, subtracted_value)
        }
    }

    impl ERC20CamelImpl of erc20::interface::IERC20Camel {
        fn name() -> felt252 {
            ERC20Impl::name()
        }

        fn symbol() -> felt252 {
            ERC20Impl::symbol()
        }

        fn decimals() -> u8 {
            ERC20Impl::decimals()
        }

        fn totalSupply() -> u256 {
            ERC20Impl::total_supply()
        }

        fn balanceOf(account: ContractAddress) -> u256 {
            ERC20Impl::balance_of(account)
        }

        fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256 {
            ERC20Impl::allowance(owner, spender)
        }

        fn transfer(recipient: ContractAddress, amount: u256) -> bool {
            ERC20Impl::transfer(recipient, amount)
        }

        fn transferFrom(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool {
            ERC20Impl::transfer_from(sender, recipient, amount)
        }

        fn approve(spender: ContractAddress, amount: u256) -> bool {
            ERC20Impl::approve(spender, amount)
        }

        fn increaseAllowance(spender: ContractAddress, added_value: u256) -> bool {
            ERC20Impl::increase_allowance(spender, added_value)
        }

        fn decreaseAllowance(spender: ContractAddress, subtracted_value: u256) -> bool {
            ERC20Impl::decrease_allowance(spender, subtracted_value)
        }
    }


    // View


    #[view]
    fn name() -> felt252 {
        ERC20Impl::name()
    }

    #[view]
    fn symbol() -> felt252 {
        ERC20Impl::symbol()
    }

    #[view]
    fn decimals() -> u8 {
        ERC20Impl::decimals()
    }

    #[view]
    fn total_supply() -> u256 {
        ERC20Impl::total_supply()
    }
    #[view]
    fn totalSupply() -> u256 {
        ERC20CamelImpl::totalSupply()
    }

    #[view]
    fn balance_of(account: ContractAddress) -> u256 {
        ERC20Impl::balance_of(account)
    }
    #[view]
    fn balanceOf(account: ContractAddress) -> u256 {
        ERC20CamelImpl::balanceOf(account)
    }

    #[view]
    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256 {
        ERC20Impl::allowance(owner, spender)
    }


    // External


    #[external]
    fn transfer(recipient: ContractAddress, amount: u256) -> bool {
        ERC20Impl::transfer(recipient, amount)
    }

    #[external]
    fn transfer_from(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool {
        ERC20Impl::transfer_from(sender, recipient, amount)
    }
    #[external]
    fn transferFrom(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool {
        ERC20CamelImpl::transferFrom(sender, recipient, amount)
    }

    #[external]
    fn approve(spender: ContractAddress, amount: u256) -> bool {
        ERC20Impl::approve(spender, amount)
    }

    #[external]
    fn increase_allowance(spender: ContractAddress, added_value: u256) -> bool {
        ERC20Impl::increase_allowance(spender, added_value)
    }
    #[external]
    fn increaseAllowance(spender: ContractAddress, added_value: u256) -> bool {
        ERC20CamelImpl::increaseAllowance(spender, added_value)
    }

    #[external]
    fn decrease_allowance(spender: ContractAddress, subtracted_value: u256) -> bool {
        ERC20Impl::decrease_allowance(spender, subtracted_value)
    }
    #[external]
    fn decreaseAllowance(spender: ContractAddress, subtracted_value: u256) -> bool {
        ERC20CamelImpl::decreaseAllowance(spender, subtracted_value)
    }


    // Internals


    #[internal]
    fn initializer(name_: felt252, symbol_: felt252) {
        _name::write(name_);
        _symbol::write(symbol_);
    }

    #[internal]
    fn _increase_allowance(spender: ContractAddress, added_value: u256) -> bool {
        let caller = get_caller_address();
        _approve(caller, spender, _allowances::read((caller, spender)) + added_value);
        true
    }

    #[internal]
    fn _decrease_allowance(spender: ContractAddress, subtracted_value: u256) -> bool {
        let caller = get_caller_address();
        _approve(caller, spender, _allowances::read((caller, spender)) - subtracted_value);
        true
    }

    #[internal]
    fn _mint(recipient: ContractAddress, amount: u256) {
        assert(!recipient.is_zero(), 'ERC20: mint to 0');
        _total_supply::write(_total_supply::read() + amount);
        _balances::write(recipient, _balances::read(recipient) + amount);
        Transfer(Zeroable::zero(), recipient, amount);
    }

    #[internal]
    fn _burn(account: ContractAddress, amount: u256) {
        assert(!account.is_zero(), 'ERC20: burn from 0');
        _total_supply::write(_total_supply::read() - amount);
        _balances::write(account, _balances::read(account) - amount);
        Transfer(account, Zeroable::zero(), amount);
    }

    #[internal]
    fn _approve(owner: ContractAddress, spender: ContractAddress, amount: u256) {
        assert(!owner.is_zero(), 'ERC20: approve from 0');
        assert(!spender.is_zero(), 'ERC20: approve to 0');
        _allowances::write((owner, spender), amount);
        Approval(owner, spender, amount);
    }

    #[internal]
    fn _transfer(sender: ContractAddress, recipient: ContractAddress, amount: u256) {
        assert(!sender.is_zero(), 'ERC20: transfer from 0');
        assert(!recipient.is_zero(), 'ERC20: transfer to 0');
        _balances::write(sender, _balances::read(sender) - amount);
        _balances::write(recipient, _balances::read(recipient) + amount);
        Transfer(sender, recipient, amount);
    }

    #[internal]
    fn _spend_allowance(owner: ContractAddress, spender: ContractAddress, amount: u256) {
        let current_allowance = _allowances::read((owner, spender));
        if current_allowance != BoundedInt::max() {
            _approve(owner, spender, current_allowance - amount);
        }
    }
}
