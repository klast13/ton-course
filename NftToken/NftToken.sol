pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract NftToken {

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
	}
    modifier checkAdressExists(string adress) {
        require(!adrToInfo.exists(adress), 100, "this adress already selling");
        tvm.accept();
		_;
	}
    
    struct TokenOfFlat {
        uint nft;
        bool hasElevator;
        uint area;
        uint floor;
        uint128 priceForSell; // 0 если не продается
    }

    mapping (string => TokenOfFlat) adrToInfo;

    function createToken(string adress, bool hasElevator, uint area, uint floor) public checkAdressExists(adress){
        adrToInfo.add(adress, TokenOfFlat(msg.pubkey(), hasElevator, area, floor, 0));
    }

    function sellToken(string adr, uint128 price) public checkOwnerAndAccept {
        adrToInfo[adr].priceForSell = price;
    }

    function getTokenInfo(string adress) public view returns (bool elev, uint area, uint floor, uint price) {
        elev = adrToInfo[adress].hasElevator;
        area = adrToInfo[adress].area;
        floor = adrToInfo[adress].floor;
        price = adrToInfo[adress].priceForSell;
    }

    //function selling(address Adress_for_sending, string adress, bool Send_only_if_adress_exists) public checkOwnerAndAccept {
    //    Adress_for_sending.transfer(adrToInfo[adress].priceForSell, Send_only_if_adress_exists, 0);
    //}
}
