PRAGMA foreign_keys = ON;

-- FAST PESHAWAR inspired sample data for CIMWOMS
-- Fictional records based on realistic campus rooms and facilities.
-- CS, AI, SE and CE labs are treated as part of one Computing Block.

-- 1. buildings
INSERT INTO buildings(building_name, building_code, campus_zone)
VALUES
('Academic Block', 'ACD', 'Main Campus'),
('Computing Block', 'CMP', 'Main Campus'),
('Main Library', 'LIB', 'Central Campus'),
('Administration Block', 'ADM', 'Central Campus'),
('Masjid', 'MSJ', 'Campus Facilities'),
('Boys Hostel', 'HST', 'Residential Area');


-- 2. rooms
INSERT INTO rooms(building_id, room_number, floor_no, room_type)
VALUES
(1, 'Room 1', 1, 'Classroom'),
(1, 'Room 2', 1, 'Classroom'),
(1, 'Room 3', 1, 'Classroom'),
(1, 'Room 4', 1, 'Classroom'),
(1, 'Room 5', 2, 'Classroom'),
(1, 'Room 6', 2, 'Classroom'),
(1, 'Room 8', 2, 'Classroom'),
(1, 'Room 9', 3, 'Classroom'),
(1, 'Room 10', 3, 'Classroom'),
(1, 'Room 11', 3, 'Classroom'),
(1, 'Room 12', 3, 'Classroom'),
(1, 'Hall A', 0, 'Seminar Hall'),

(2, 'CALL Lab', 1, 'Computer Lab'),
(2, 'Mehboob PC Lab', 1, 'Computer Lab'),
(2, 'Hassan Abidi Lab', 2, 'Computer Lab'),
(2, 'Khyber Lab', 2, 'Computer Lab'),
(2, 'AI New Lab', 3, 'AI Lab'),
(2, 'DLD Lab', 1, 'Digital Logic Lab'),
(2, 'Embedded Lab', 1, 'Embedded Systems Lab'),
(2, 'Electronics Lab', 2, 'Electronics Lab'),
(2, 'Rafaqat CE Lab 1', 2, 'Computer Engineering Lab'),

(3, 'Library Reading Hall', 0, 'Reading Hall'),
(3, 'Library Discussion Room', 1, 'Study Room'),

(4, 'Admin Office', 1, 'Office'),
(4, 'Teacher''s Office', 2, 'Faculty Office'),

(5, 'Prayer Hall', 0, 'Prayer Area'),
(5, 'Ablution Area', 0, 'Wash Area'),

(6, 'Hostel Room B-101', 1, 'Hostel Room'),
(6, 'Hostel Study Room', 0, 'Study Room');


-- 3. asset_types
INSERT INTO asset_types(type_name, description)
VALUES
('Projector', 'Multimedia projector used in classrooms, labs and halls'),
('Air Conditioner', 'Cooling unit installed in rooms, offices and labs'),
('Computer', 'Desktop computer used in labs or offices'),
('Printer', 'Printer used in offices, labs or admin areas'),
('Electrical Board', 'Electrical switches, sockets and distribution boards'),
('Furniture', 'Chairs, desks, tables and classroom furniture'),
('Network Device', 'Router, switch, access point or other network equipment'),
('Lab Equipment', 'Equipment used in computing and electronics labs'),
('Water Fixture', 'Taps, wash basins and other water-related fixtures');

-- 4. assets
INSERT INTO assets(room_id, asset_type_id, asset_name, asset_tag, manufacturer, installation_date, asset_status)
VALUES
(1, 1, 'Room 1 Epson Projector', 'FAST-ACD-R1-PRJ-001', 'Epson', '2022-08-15', 'GOOD'),
(2, 2, 'Room 2 Gree AC', 'FAST-ACD-R2-AC-001', 'Gree', '2021-06-10', 'FAIR'),
(5, 6, 'Room 5 Student Chairs Set', 'FAST-ACD-R5-FUR-001', 'Local', '2020-09-01', 'FAIR'),
(8, 1, 'Room 9 Multimedia Projector', 'FAST-ACD-R9-PRJ-001', 'BenQ', '2021-10-12', 'POOR'),
(12, 1, 'Hall A Main Projector', 'FAST-ACD-HA-PRJ-001', 'Sony', '2020-02-20', 'GOOD'),
(12, 2, 'Hall A Central AC', 'FAST-ACD-HA-AC-001', 'Dawlance', '2019-05-05', 'FAIR'),

(13, 3, 'CALL Lab PC 01', 'FAST-CMP-CALL-PC-001', 'Dell', '2021-08-20', 'FAIR'),
(13, 7, 'CALL Lab Network Switch', 'FAST-CMP-CALL-NET-001', 'Cisco', '2020-11-15', 'GOOD'),
(14, 3, 'Mehboob PC Lab Computer 01', 'FAST-CMP-MPC-PC-001', 'HP', '2021-09-10', 'GOOD'),
(15, 3, 'Hassan Abidi Lab Computer 01', 'FAST-CMP-HAL-PC-001', 'Dell', '2022-01-25', 'GOOD'),
(16, 2, 'Khyber Lab AC', 'FAST-CMP-KHY-AC-001', 'Haier', '2020-07-18', 'POOR'),
(17, 3, 'AI New Lab GPU Workstation', 'FAST-CMP-AI-PC-001', 'Lenovo', '2023-03-12', 'GOOD'),
(17, 7, 'AI New Lab Access Point', 'FAST-CMP-AI-NET-001', 'TP-Link', '2023-03-15', 'FAIR'),
(18, 8, 'DLD Lab FPGA Kit', 'FAST-CMP-DLD-LAB-001', 'Xilinx', '2021-04-10', 'GOOD'),
(19, 8, 'Embedded Lab Microcontroller Kit', 'FAST-CMP-EMB-LAB-001', 'Arduino', '2021-05-22', 'FAIR'),
(20, 5, 'Electronics Lab Main Electrical Board', 'FAST-CMP-ELAB-ELB-001', 'Schneider', '2018-12-10', 'POOR'),
(21, 3, 'Rafaqat CE Lab Computer 01', 'FAST-CMP-RCE-PC-001', 'Dell', '2022-09-01', 'GOOD'),

(22, 6, 'Library Reading Table Set', 'FAST-LIB-RH-FUR-001', 'Local', '2018-09-01', 'FAIR'),
(22, 2, 'Library Reading Hall AC', 'FAST-LIB-RH-AC-001', 'Gree', '2020-06-30', 'GOOD'),
(23, 7, 'Library WiFi Access Point', 'FAST-LIB-DR-NET-001', 'Cisco', '2021-11-05', 'GOOD'),

(24, 4, 'Admin Office HP Printer', 'FAST-ADM-OFF-PRN-001', 'HP', '2022-02-10', 'GOOD'),
(25, 2, 'Teacher Office AC', 'FAST-ADM-TO-AC-001', 'Haier', '2020-04-18', 'FAIR'),

(26, 2, 'Masjid Prayer Hall AC', 'FAST-MSJ-PH-AC-001', 'Gree', '2019-08-01', 'FAIR'),
(27, 9, 'Masjid Ablution Tap Set', 'FAST-MSJ-ABL-WTR-001', 'Local', '2018-03-20', 'POOR'),

(28, 2, 'Hostel Room B-101 AC', 'FAST-HST-B101-AC-001', 'Dawlance', '2021-07-05', 'OUT_OF_SERVICE'),
(29, 6, 'Hostel Study Room Desk Set', 'FAST-HST-SR-FUR-001', 'Local', '2020-01-12', 'FAIR');

-- 5. users
INSERT INTO users(full_name, email, phone, role, created_at)
VALUES
('Abdul Rafeh', 'abdul.rafeh@nu.edu.pk', '03001234501', 'REPORTER', '2026-04-01 09:00:00'),
('Ali Hamza', 'ali.hamza@nu.edu.pk', '03001234502', 'REPORTER', '2026-04-01 09:10:00'),
('Sara Khan', 'sara.khan@nu.edu.pk', '03001234503', 'REPORTER', '2026-04-01 09:20:00'),
('Hassan Malik', 'hassan.malik@nu.edu.pk', '03001234504', 'SUPERVISOR', '2026-04-01 10:00:00'),
('Ayesha Noor', 'ayesha.noor@nu.edu.pk', '03001234505', 'SUPERVISOR', '2026-04-01 10:15:00'),
('Usman Tariq', 'usman.tariq@nu.edu.pk', '03001234506', 'TECHNICIAN', '2026-04-01 11:00:00'),
('Bilal Ahmed', 'bilal.ahmed@nu.edu.pk', '03001234507', 'TECHNICIAN', '2026-04-01 11:10:00'),
('Zain Iqbal', 'zain.iqbal@nu.edu.pk', '03001234508', 'TECHNICIAN', '2026-04-01 11:20:00'),
('Maria Saeed', 'maria.saeed@nu.edu.pk', '03001234509', 'TECHNICIAN', '2026-04-01 11:30:00'),
('Fatima Rauf', 'fatima.rauf@nu.edu.pk', '03001234510', 'REPORTER', '2026-04-01 12:00:00');

-- 6. issue_categories
INSERT INTO issue_categories(category_name, description)
VALUES
('Electrical', 'Power supply, sockets, switches, wiring and electrical board issues'),
('HVAC', 'Air conditioning and ventilation problems'),
('IT Equipment', 'Computers, projectors, printers and display equipment'),
('Furniture', 'Broken chairs, desks, tables and other furniture problems'),
('Network', 'Internet, WiFi, switches and access point issues'),
('Water Supply', 'Taps, leakage and water-related maintenance issues'),
('Lab Equipment', 'Problems with computing or electronics lab equipment'),
('General Maintenance', 'General repair and maintenance requests');


-- 7. work_orders
INSERT INTO work_orders(reported_by, room_id, asset_id, category_id, title, description, priority, status, reported_at, due_date, completed_at)
VALUES
(1, 1, 1, 3, 'Room 1 projector not displaying', 'The projector turns on but does not display the laptop screen during class.', 'HIGH', 'ASSIGNED', '2026-04-10 09:15:00', '2026-04-12', NULL),
(2, 13, 7, 3, 'CALL Lab computer running slow', 'CALL Lab PC 01 is taking too long to boot and open software.', 'MEDIUM', 'IN_PROGRESS', '2026-04-10 10:30:00', '2026-04-14', NULL),
(3, 16, 11, 2, 'Khyber Lab AC not cooling', 'The AC in Khyber Lab is running but the room remains hot.', 'HIGH', 'OPEN', '2026-04-11 11:00:00', '2026-04-13', NULL),
(1, 20, 16, 1, 'Electronics Lab board sparking', 'Sparks were noticed near the main electrical board in Electronics Lab.', 'URGENT', 'COMPLETED', '2026-04-11 08:40:00', '2026-04-11', '2026-04-11 15:10:00'),
(10, 22, 18, 4, 'Library reading table damaged', 'One reading table in the library is unstable and unsafe for students.', 'LOW', 'ASSIGNED', '2026-04-12 13:20:00', '2026-04-18', NULL),
(2, 17, 13, 5, 'AI New Lab WiFi weak', 'Students are facing weak WiFi signals in the AI New Lab.', 'MEDIUM', 'ON_HOLD', '2026-04-12 15:10:00', '2026-04-16', NULL),
(3, 24, 21, 3, 'Admin printer paper jam', 'The admin office printer repeatedly shows a paper jam error.', 'MEDIUM', 'COMPLETED', '2026-04-13 09:30:00', '2026-04-15', '2026-04-14 12:00:00'),
(1, 12, 5, 3, 'Hall A projector focus issue', 'The projected image in Hall A is blurry during presentations.', 'LOW', 'OPEN', '2026-04-13 14:30:00', '2026-04-20', NULL),
(2, 18, 14, 7, 'DLD Lab FPGA kit not working', 'One FPGA kit in the DLD Lab is not powering on.', 'HIGH', 'IN_PROGRESS', '2026-04-14 10:00:00', '2026-04-17', NULL),
(3, 19, 15, 7, 'Embedded Lab kit cable missing', 'A microcontroller kit in Embedded Lab is missing its connecting cable.', 'LOW', 'CANCELLED', '2026-04-14 12:15:00', '2026-04-21', NULL),
(10, 27, 24, 6, 'Masjid ablution tap leaking', 'One tap in the ablution area is continuously leaking water.', 'MEDIUM', 'ASSIGNED', '2026-04-15 08:30:00', '2026-04-17', NULL),
(1, 28, 25, 2, 'Hostel room AC not working', 'The AC in Hostel Room B-101 is not turning on.', 'HIGH', 'ASSIGNED', '2026-04-15 18:45:00', '2026-04-16', NULL),
(2, 25, 22, 2, 'Teacher office AC noise', 'The AC in the teacher office is cooling but making loud noise.', 'MEDIUM', 'OPEN', '2026-04-16 09:50:00', '2026-04-19', NULL),
(1, 14, NULL, 8, 'Mehboob PC Lab door lock issue', 'The door lock of Mehboob PC Lab is difficult to open and close.', 'MEDIUM', 'OPEN', '2026-04-17 16:00:00', '2026-04-22', NULL),
(3, 29, 26, 4, 'Hostel study room desk damaged', 'One desk in the hostel study room has a loose side panel.', 'LOW', 'ASSIGNED', '2026-04-18 10:40:00', '2026-04-24', NULL);


-- 8. assignments
INSERT INTO assignments(work_order_id, technician_id, assigned_by, assigned_at, assignment_role)
VALUES
(1, 6, 4, '2026-04-10 10:00:00', 'Primary Technician'),
(2, 7, 4, '2026-04-10 11:00:00', 'Primary Technician'),
(4, 8, 5, '2026-04-11 09:00:00', 'Primary Technician'),
(5, 9, 5, '2026-04-12 14:00:00', 'Primary Technician'),
(6, 7, 4, '2026-04-12 16:00:00', 'Primary Technician'),
(7, 7, 4, '2026-04-13 10:00:00', 'Primary Technician'),
(9, 8, 5, '2026-04-14 10:30:00', 'Primary Technician'),
(11, 9, 5, '2026-04-15 09:00:00', 'Primary Technician'),
(12, 6, 4, '2026-04-15 19:00:00', 'Primary Technician'),
(15, 9, 5, '2026-04-18 11:00:00', 'Primary Technician');


-- 9. status_history
INSERT INTO status_history(work_order_id, old_status, new_status, changed_by, changed_at, changed_note)
VALUES
(1, 'OPEN', 'ASSIGNED', 4, '2026-04-10 10:00:00', 'Projector issue assigned to technician.'),
(2, 'OPEN', 'ASSIGNED', 4, '2026-04-10 11:00:00', 'Computer issue assigned to IT technician.'),
(2, 'ASSIGNED', 'IN_PROGRESS', 7, '2026-04-10 13:00:00', 'Technician started checking the lab computer.'),
(4, 'OPEN', 'ASSIGNED', 5, '2026-04-11 09:00:00', 'Urgent electrical issue assigned immediately.'),
(4, 'ASSIGNED', 'IN_PROGRESS', 8, '2026-04-11 10:15:00', 'Electrical inspection started.'),
(4, 'IN_PROGRESS', 'COMPLETED', 8, '2026-04-11 15:10:00', 'Electrical board repaired and tested.'),
(5, 'OPEN', 'ASSIGNED', 5, '2026-04-12 14:00:00', 'Library furniture issue assigned.'),
(6, 'OPEN', 'ASSIGNED', 4, '2026-04-12 16:00:00', 'Network issue assigned to technician.'),
(6, 'ASSIGNED', 'ON_HOLD', 7, '2026-04-13 12:00:00', 'Replacement access point may be required.'),
(7, 'OPEN', 'ASSIGNED', 4, '2026-04-13 10:00:00', 'Admin printer issue assigned.'),
(7, 'ASSIGNED', 'IN_PROGRESS', 7, '2026-04-13 11:00:00', 'Technician started printer inspection.'),
(7, 'IN_PROGRESS', 'COMPLETED', 7, '2026-04-14 12:00:00', 'Printer cleaned and tested successfully.'),
(9, 'OPEN', 'ASSIGNED', 5, '2026-04-14 10:30:00', 'DLD Lab equipment issue assigned.'),
(9, 'ASSIGNED', 'IN_PROGRESS', 8, '2026-04-14 12:20:00', 'FPGA kit inspection started.'),
(10, 'OPEN', 'CANCELLED', 5, '2026-04-14 14:30:00', 'Cable was found by lab assistant.'),
(11, 'OPEN', 'ASSIGNED', 5, '2026-04-15 09:00:00', 'Masjid water leakage assigned.'),
(12, 'OPEN', 'ASSIGNED', 4, '2026-04-15 19:00:00', 'Hostel AC issue assigned.'),
(15, 'OPEN', 'ASSIGNED', 5, '2026-04-18 11:00:00', 'Hostel furniture issue assigned.');
