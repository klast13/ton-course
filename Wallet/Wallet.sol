pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Wallet {
    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
	}

    function sendTransactionWithoutCommision(address Adress_for_sending, uint128 value, bool Send_only_if_adress_exists) public pure checkOwnerAndAccept {
        Adress_for_sending.transfer(value, Send_only_if_adress_exists, 0);
    }

    function sendTransactionWithCommision(address Adress_for_sending, uint128 value, bool Send_only_if_adress_exists) public pure checkOwnerAndAccept {
        Adress_for_sending.transfer(value, Send_only_if_adress_exists, 1);
    }

    function sendAllMoneyAndDestroyWallet(address Adress_for_sending,  bool Send_only_if_adress_exists) public pure checkOwnerAndAccept {
        Adress_for_sending.transfer(1, Send_only_if_adress_exists, 160);
    }
}