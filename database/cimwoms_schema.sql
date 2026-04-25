-------DDL CIMWOMS-------
    --ABDUL RAFEH--
     --24p-0659--
     --BSCS-4A--




PRAGMA foreign_keys = ON;



-- 1. buildings
CREATE TABLE buildings(
    building_id INTEGER PRIMARY KEY AUTOINCREMENT,
    building_name VARCHAR(100) NOT NULL,
    building_code VARCHAR(20) NOT NULL UNIQUE,
    campus_zone VARCHAR(50) NOT NULL
);



-- 2. rooms
CREATE TABLE rooms(
    room_id INTEGER PRIMARY KEY AUTOINCREMENT,
    building_id INTEGER NOT NULL,
    room_number VARCHAR(20) NOT NULL,
    floor_no INTEGER NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    UNIQUE (building_id, room_number),
    FOREIGN KEY (building_id) REFERENCES buildings(building_id)
);



-- 3. asset_types
CREATE TABLE asset_types(
    asset_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);




-- 4. assets
CREATE TABLE assets(
    asset_id INTEGER PRIMARY KEY AUTOINCREMENT,
    room_id INTEGER NOT NULL,
    asset_type_id INTEGER NOT NULL,
    asset_name VARCHAR(100) NOT NULL,
    asset_tag VARCHAR(50) NOT NULL UNIQUE,
    manufacturer VARCHAR(100),
    installation_date DATE,
    asset_status VARCHAR(30) NOT NULL
                  CHECK (asset_status IN ('GOOD','FAIR','POOR','OUT_OF_SERVICE')),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (asset_type_id) REFERENCES asset_types(asset_type_id)
);



-- 5. users
CREATE TABLE users(
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    role VARCHAR(30) NOT NULL CHECK (role IN ('REPORTER','SUPERVISOR','TECHNICIAN')),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- 6. issue_categories
CREATE TABLE issue_categories(
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);



-- 7. work_orders
CREATE TABLE work_orders(
    work_order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    reported_by INTEGER NOT NULL,
    room_id INTEGER NOT NULL,
    asset_id INTEGER,
    category_id INTEGER NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(20) NOT NULL
                  CHECK (priority IN ('LOW','MEDIUM','HIGH','URGENT')),
    status VARCHAR(30) NOT NULL
                  CHECK (status IN ('OPEN','ASSIGNED','IN_PROGRESS','ON_HOLD','COMPLETED','CANCELLED')),
    reported_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date DATE,
    completed_at DATETIME,
    FOREIGN KEY (reported_by) REFERENCES users(user_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id),
    FOREIGN KEY (category_id) REFERENCES issue_categories(category_id)
);



-- 8. assignments
CREATE TABLE assignments(
    assignment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    work_order_id INTEGER NOT NULL,
    technician_id INTEGER NOT NULL,
    assigned_by INTEGER NOT NULL,
    assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    assignment_role VARCHAR(50),
    UNIQUE (work_order_id, technician_id),
    FOREIGN KEY (work_order_id) REFERENCES work_orders(work_order_id),
    FOREIGN KEY (technician_id) REFERENCES users(user_id),
    FOREIGN KEY (assigned_by) REFERENCES users(user_id)
);




-- 9. status_history
CREATE TABLE status_history(
    history_id INTEGER PRIMARY KEY AUTOINCREMENT,
    work_order_id INTEGER NOT NULL,
    old_status VARCHAR(30) NOT NULL
                  CHECK (old_status IN ('OPEN','ASSIGNED','IN_PROGRESS','ON_HOLD','COMPLETED','CANCELLED')),
    new_status VARCHAR(30) NOT NULL
                  CHECK (new_status IN ('OPEN','ASSIGNED','IN_PROGRESS','ON_HOLD','COMPLETED','CANCELLED')),
    changed_by INTEGER NOT NULL,
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    changed_note TEXT,
    FOREIGN KEY (work_order_id) REFERENCES work_orders(work_order_id),
    FOREIGN KEY (changed_by) REFERENCES users(user_id)
);

