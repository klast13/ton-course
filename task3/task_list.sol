// я не смог разобраться как правильно работать с массивом структур в солидити, контракт не работает, написал схематично, чтобы показать идею 




pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract task_list {

	// State variable storing the sum of arguments that were passed to function 'add',
    struct tasksStruct {
        string name;
        uint32 timestamp;
        bool is_done;
    }

    tasksStruct[] tasks;

	constructor() public {
		// check that contract's public key is set
		require(tvm.pubkey() != 0, 101);
		// Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	// Modifier that allows to accept some external messages
	modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

    // добавление новой задачи
    function add_task(string _name) public {
        tasksStruct newTask = tasksStruct(_name, now, false);
        tasks.push(newTask);
	}

    // показать кол-во невыполненых задач
    function show_opened_tasks() public view returns (uint) {
        uint count_of_opened_tasks = 0;
        for (uint i=0; i<tasks.length; i++){
            if (!tasks[i].is_done) {
                count_of_opened_tasks += 1; 
            }
        }
        return count_of_opened_tasks;
	}
    
    // показать список задач
    function show_list_of_tasks() public view checkOwnerAndAccept returns(tasksStruct[]) {        
        return tasks;

    // показать описание по ключу
	}
    function show_discribtion_by_key(uint index) public view checkOwnerAndAccept returns(tasksStruct) {
        return tasks[index-1];

    // удалить задачу
	}
    function delete_task(uint index) public checkOwnerAndAccept {
        for (uint i = index; i < tasks.length - 1; i++) {
            tasks[i] = tasks[i+1];
        }
        tasks.pop();

    // пометить как выполненную
	}
    function mark_as_done(uint index) public checkOwnerAndAccept {
        tasks[index].is_done = true;
	}

}