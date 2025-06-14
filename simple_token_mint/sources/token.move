
/// Module: token
module simple_token_mint::my_token{
    use sui::coin;

    public struct MyToken has drop {}

    // initialisation of the token:

    public fun int(witness: MyToken, ctx: &mut TxContext){
        let (treasury , metaData) = coin::create_currency(
            witness,
            6, //level of precision so 6 -> 10^-6 precision
            b"coinSimbol",
            b"tokenName",
            b"description",
            option::none(),
            ctx
        );
        transfer::public_freeze_object(metaData); //makes metaData immutable
        transfer::public_transfer(treasury, tx_context::sender(ctx)); 
        //Returning an object from a function, allows a caller to use the object 
        // and enables composability via programmable transactions.
        //just a warning
    }

    // Function to mint / generate new tokens
    public fun mint(
        treasury: &mut coin::TreasuryCap<MyToken>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ){
        let genrated_coins = coin::mint(treasury, amount, ctx);
        transfer::public_transfer (genrated_coins, recipient);
    }

    // Function to burn tokens already exist in token, we just duplicate code here
    // to show how it can be used
    /*
        public fun burn(
            treasury: &mut coin::TreasuryCap<MyToken>,
            coin_obj: coin::Coin<MyToken>
        ){
            coin::burn(treasury, coin_obj);
        }
    */

    // Function to get the total amount of tokens in circulation
    public fun total_supply(treasury: &coin::TreasuryCap<MyToken>): u64 {
        coin::total_supply(treasury)
    }
}