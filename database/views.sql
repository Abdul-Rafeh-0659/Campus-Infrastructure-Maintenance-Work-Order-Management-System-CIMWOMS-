
-- CIMWOMS Views
-- Campus Infrastructure Maintenance & Work Order Management System
-- These views provide reusable reports for work orders, technicians, assets, buildings and urgent pending maintenance issues.


PRAGMA foreign_keys = ON;
--============================================================
--View 1: Full Work Order Details
--Shows complete work order information with building, room,
--asset, category, reporter, and current status.
--==============================================================


CREATE VIEW IF NOT EXISTS view_work_order_details AS
SELECT
    wo.work_order_id,
    wo.title,
    wo.description,
    wo.priority,
    wo.status,
    wo.reported_at,
    wo.due_date,
    wo.completed_at,

    b.building_name,
    b.building_code,
    b.campus_zone,

    r.room_number,
    r.floor_no,
    r.room_type,

    a.asset_name,
    a.asset_tag,
    a.asset_status,

    at.type_name AS asset_type,

    ic.category_name,

    u.full_name AS reported_by,
    u.email AS reporter_email

FROM work_orders wo
JOIN rooms r
    ON wo.room_id = r.room_id
JOIN buildings b
    ON r.building_id = b.building_id
LEFT JOIN assets a
    ON wo.asset_id = a.asset_id
LEFT JOIN asset_types at
    ON a.asset_type_id = at.asset_type_id
JOIN issue_categories ic
    ON wo.category_id = ic.category_id
JOIN users u
    ON wo.reported_by = u.user_id;



--===========================================================
--View 2: Technician Workload
--Shows how many work orders are assigned to each technician.
--Useful for checking workload distribution.
--===========================================================



CREATE VIEW IF NOT EXISTS view_technician_workload AS
SELECT
    u.user_id AS technician_id,
    u.full_name AS technician_name,
    u.email,
    COUNT(a.assignment_id) AS total_assigned_orders,

    SUM(CASE WHEN wo.status = 'OPEN' THEN 1 ELSE 0 END) AS open_orders,
    SUM(CASE WHEN wo.status = 'ASSIGNED' THEN 1 ELSE 0 END) AS assigned_orders,
    SUM(CASE WHEN wo.status = 'IN_PROGRESS' THEN 1 ELSE 0 END) AS in_progress_orders,
    SUM(CASE WHEN wo.status = 'ON_HOLD' THEN 1 ELSE 0 END) AS on_hold_orders,
    SUM(CASE WHEN wo.status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_orders,
    SUM(CASE WHEN wo.status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled_orders

FROM users u
LEFT JOIN assignments a
    ON u.user_id = a.technician_id
LEFT JOIN work_orders wo
    ON a.work_order_id = wo.work_order_id
WHERE u.role = 'TECHNICIAN'
GROUP BY
    u.user_id,
    u.full_name,
    u.email;


--================================================================
--View 3: Building Maintenance Summary
--Shows the number of work orders in each building.
--Useful for finding buildings with the most maintenance issues.
--===================================================================


CREATE VIEW IF NOT EXISTS view_building_maintenance_summary AS
SELECT
    b.building_id,
    b.building_name,
    b.building_code,
    b.campus_zone,

    COUNT(wo.work_order_id) AS total_work_orders,

    SUM(CASE WHEN wo.status = 'OPEN' THEN 1 ELSE 0 END) AS open_orders,
    SUM(CASE WHEN wo.status = 'ASSIGNED' THEN 1 ELSE 0 END) AS assigned_orders,
    SUM(CASE WHEN wo.status = 'IN_PROGRESS' THEN 1 ELSE 0 END) AS in_progress_orders,
    SUM(CASE WHEN wo.status = 'ON_HOLD' THEN 1 ELSE 0 END) AS on_hold_orders,
    SUM(CASE WHEN wo.status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_orders,
    SUM(CASE WHEN wo.status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled_orders,

    SUM(CASE WHEN wo.priority = 'URGENT' THEN 1 ELSE 0 END) AS urgent_orders,
    SUM(CASE WHEN wo.priority = 'HIGH' THEN 1 ELSE 0 END) AS high_priority_orders

FROM buildings b
LEFT JOIN rooms r
    ON b.building_id = r.building_id
LEFT JOIN work_orders wo
    ON r.room_id = wo.room_id
GROUP BY
    b.building_id,
    b.building_name,
    b.building_code,
    b.campus_zone;




--============================================================
--View 4: Asset Maintenance History
--Shows maintenance records for assets.
--Useful for identifying assets that repeatedly need repairs.
--=============================================================



CREATE VIEW IF NOT EXISTS view_asset_maintenance_history AS
SELECT
    a.asset_id,
    a.asset_name,
    a.asset_tag,
    a.manufacturer,
    a.installation_date,
    a.asset_status,

    at.type_name AS asset_type,

    b.building_name,
    r.room_number,

    COUNT(wo.work_order_id) AS total_maintenance_requests,

    SUM(CASE WHEN wo.status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_requests,
    SUM(CASE WHEN wo.status != 'COMPLETED' AND wo.status != 'CANCELLED' THEN 1 ELSE 0 END) AS active_requests,

    MAX(wo.reported_at) AS latest_reported_issue

FROM assets a
JOIN asset_types at
    ON a.asset_type_id = at.asset_type_id
JOIN rooms r
    ON a.room_id = r.room_id
JOIN buildings b
    ON r.building_id = b.building_id
LEFT JOIN work_orders wo
    ON a.asset_id = wo.asset_id
GROUP BY
    a.asset_id,
    a.asset_name,
    a.asset_tag,
    a.manufacturer,
    a.installation_date,
    a.asset_status,
    at.type_name,
    b.building_name,
    r.room_number;





--=====================================================================
--View 5: Pending Urgent Work Orders
--Shows urgent or high-priority work orders that are not completed.
--Useful for supervisors to quickly identify critical issues.
--===================================================================

CREATE VIEW IF NOT EXISTS view_pending_urgent_work_orders AS
SELECT
    wo.work_order_id,
    wo.title,
    wo.description,
    wo.priority,
    wo.status,
    wo.reported_at,
    wo.due_date,

    b.building_name,
    r.room_number,

    a.asset_name,
    a.asset_tag,

    ic.category_name,

    reporter.full_name AS reported_by,

    GROUP_CONCAT(tech.full_name, ', ') AS assigned_technicians

FROM work_orders wo
JOIN rooms r
    ON wo.room_id = r.room_id
JOIN buildings b
    ON r.building_id = b.building_id
LEFT JOIN assets a
    ON wo.asset_id = a.asset_id
JOIN issue_categories ic
    ON wo.category_id = ic.category_id
JOIN users reporter
    ON wo.reported_by = reporter.user_id
LEFT JOIN assignments ass
    ON wo.work_order_id = ass.work_order_id
LEFT JOIN users tech
    ON ass.technician_id = tech.user_id

WHERE wo.priority IN ('HIGH', 'URGENT')
  AND wo.status NOT IN ('COMPLETED', 'CANCELLED')


GROUP BY
    wo.work_order_id,
    wo.title,
    wo.description,
    wo.priority,
    wo.status,
    wo.reported_at,
    wo.due_date,
    b.building_name,
    r.room_number,
    a.asset_name,
    a.asset_tag,
    ic.category_name,
    reporter.full_name;
