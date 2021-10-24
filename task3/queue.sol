pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract queue {

    string [] public names;

	constructor() public {
		// check that contract's public key is set
		require(tvm.pubkey() != 0, 101);
		// Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

	function get_to_queue(string _name) public checkOwnerAndAccept {
        names.push(_name);
        return;
	}

	function call_next() public checkOwnerAndAccept {
        delete names[0];
        return;
	}

}