module MyModule::diploma {
    use std::string::String;
    use std::signer;
    use aptos_std::table::{Self, Table};

    struct Diploma has store, drop {
        student_name: String,
        unique_id: String
    }

    struct DiplomaRegistry has key {
        diplomas: Table<String, Diploma>
    }

    public entry fun issue_diploma(
        university: &signer, 
        student_name: String,
        unique_id: String
    ) acquires DiplomaRegistry {
        let university_addr = signer::address_of(university);
        
        if (!exists<DiplomaRegistry>(university_addr)) {
            move_to(university, DiplomaRegistry {
                diplomas: table::new()
            });
        };
        
        let registry = borrow_global_mut<DiplomaRegistry>(university_addr);
        
        let diploma = Diploma { student_name, unique_id };
        table::add(&mut registry.diplomas, unique_id, diploma);
    }

    public fun verify_diploma(
        university_addr: address, 
        unique_id: String
    ): bool acquires DiplomaRegistry {
        exists<DiplomaRegistry>(university_addr) && 
        table::contains(&borrow_global<DiplomaRegistry>(university_addr).diplomas, unique_id)
    }
}