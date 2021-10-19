pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract task_list {

    struct tasksStruct {
        string name;
        bool is_done;
        bool is_deleted;
    }
    //<map>.min() не получилось со строкой сделать, было бы логичнее сделать ключом название
    mapping(uint => tasksStruct) tasks;    
    

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
    // добавление новой задачи
    function add_task(string _name) public checkOwnerAndAccept {
        tasksStruct newTask = tasksStruct(_name, false, false);
        tasks.add(now, newTask);        
	}
    // показать кол-во невыполненых задач
    function show_opened_tasks() public checkOwnerAndAccept returns (uint) {
        uint count_of_opened_tasks = 0;
        optional(uint, tasksStruct) currentOpt = tasks.min();
        
        while (currentOpt.hasValue()) {
            (uint key, tasksStruct val) = currentOpt.get();
            if (!val.is_done && !val.is_deleted) {
                count_of_opened_tasks += 1; 
            }
        }
        return count_of_opened_tasks; 
	}
    // показать список задач
    function show_list_of_tasks() public checkOwnerAndAccept returns(tasksStruct[]) { 
        tasksStruct[] resArr;       
        optional(uint, tasksStruct) currentOpt = tasks.min();
        
        while (currentOpt.hasValue()) {
            (uint key, tasksStruct val) = currentOpt.get();
            resArr.push(val);
            currentOpt = tasks.next(key);
        }
        return resArr; 
    }
    // показать описание по ключу
	    function show_discribtion_by_key(string _name) public checkOwnerAndAccept returns(tasksStruct) {
        optional(uint, tasksStruct) currentOpt = tasks.min();
        
        while (currentOpt.hasValue()) {
            (uint key, tasksStruct val) = currentOpt.get();
            if (val.name == _name) {
                return val;
            }
            currentOpt = tasks.next(key);
        }
    }
    // удалить задачу
    function delete_task(string _name) public view checkOwnerAndAccept {
        optional(uint, tasksStruct) currentOpt = tasks.min();
        
        while (currentOpt.hasValue()) {
            (uint key, tasksStruct val) = currentOpt.get();
            if (val.name == _name) {
                val.is_deleted = true;
            }
            currentOpt = tasks.next(key);
        }
    }   
    // пометить как выполненную
    function mark_as_done(string _name) public view checkOwnerAndAccept {
        optional(uint, tasksStruct) currentOpt = tasks.min();
        
        while (currentOpt.hasValue()) {
            (uint key, tasksStruct val) = currentOpt.get();
            if (val.name == _name) {
                val.is_done = true;
            }
            currentOpt = tasks.next(key);
	    }
    }

}