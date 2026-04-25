PRAGMA foreign_keys = ON;

-- CIMWOMS Queries
-- These queries show useful reports from the maintenance system.



-- 1. Full work order report with building, room, asset, category and reporter
SELECT 
    wo.work_order_id,
    wo.title,
    wo.priority,
    wo.status,
    b.building_name,
    r.room_number,
    r.room_type,
    COALESCE(a.asset_name, 'Room-level issue') AS asset_name,
    c.category_name,
    u.full_name AS reported_by,
    wo.reported_at,
    wo.due_date,
    wo.completed_at
FROM work_orders wo
JOIN rooms r ON wo.room_id = r.room_id
JOIN buildings b ON r.building_id = b.building_id
LEFT JOIN assets a ON wo.asset_id = a.asset_id
JOIN issue_categories c ON wo.category_id = c.category_id
JOIN users u ON wo.reported_by = u.user_id
ORDER BY wo.reported_at DESC;


-- 2. Work orders by current status
SELECT 
    status,
    COUNT(*) AS total_work_orders
FROM work_orders
GROUP BY status
ORDER BY total_work_orders DESC;


-- 3. Work orders by priority
SELECT 
    priority,
    COUNT(*) AS total_work_orders
FROM work_orders
GROUP BY priority
ORDER BY 
    CASE priority
        WHEN 'URGENT' THEN 1
        WHEN 'HIGH' THEN 2
        WHEN 'MEDIUM' THEN 3
        WHEN 'LOW' THEN 4
    END;


-- 4. Open and pending work orders only
SELECT 
    wo.work_order_id,
    wo.title,
    wo.priority,
    wo.status,
    b.building_name,
    r.room_number,
    wo.reported_at,
    wo.due_date
FROM work_orders wo
JOIN rooms r ON wo.room_id = r.room_id
JOIN buildings b ON r.building_id = b.building_id
WHERE wo.status IN ('OPEN', 'ASSIGNED', 'IN_PROGRESS', 'ON_HOLD')
ORDER BY wo.due_date ASC;


-- 5. Urgent and high priority work orders
SELECT 
    wo.work_order_id,
    wo.title,
    wo.priority,
    wo.status,
    b.building_name,
    r.room_number,
    COALESCE(a.asset_name, 'Room-level issue') AS asset_name,
    wo.due_date
FROM work_orders wo
JOIN rooms r ON wo.room_id = r.room_id
JOIN buildings b ON r.building_id = b.building_id
LEFT JOIN assets a ON wo.asset_id = a.asset_id
WHERE wo.priority IN ('URGENT', 'HIGH')
ORDER BY 
    CASE wo.priority
        WHEN 'URGENT' THEN 1
        WHEN 'HIGH' THEN 2
    END,
    wo.due_date ASC;


-- 6. Overdue work orders
-- Date is fixed for project testing so the output is stable.
SELECT 
    wo.work_order_id,
    wo.title,
    wo.priority,
    wo.status,
    b.building_name,
    r.room_number,
    wo.due_date
FROM work_orders wo
JOIN rooms r ON wo.room_id = r.room_id
JOIN buildings b ON r.building_id = b.building_id
WHERE wo.status NOT IN ('COMPLETED', 'CANCELLED')
  AND wo.due_date < '2026-04-20'
ORDER BY wo.due_date ASC;


-- 7. Technician workload report
SELECT 
    u.user_id,
    u.full_name AS technician_name,
    COUNT(a.assignment_id) AS assigned_work_orders
FROM users u
LEFT JOIN assignments a ON u.user_id = a.technician_id
WHERE u.role = 'TECHNICIAN'
GROUP BY u.user_id, u.full_name
ORDER BY assigned_work_orders DESC;


-- 8. Technician workload with active work only
SELECT 
    u.full_name AS technician_name,
    COUNT(a.assignment_id) AS active_assignments
FROM assignments a
JOIN users u ON a.technician_id = u.user_id
JOIN work_orders wo ON a.work_order_id = wo.work_order_id
WHERE wo.status IN ('OPEN', 'ASSIGNED', 'IN_PROGRESS', 'ON_HOLD')
GROUP BY u.full_name
ORDER BY active_assignments DESC;


-- 9. Most reported buildings
SELECT 
    b.building_name,
    COUNT(wo.work_order_id) AS total_work_orders
FROM work_orders wo
JOIN rooms r ON wo.room_id = r.room_id
JOIN buildings b ON r.building_id = b.building_id
GROUP BY b.building_id, b.building_name
ORDER BY total_work_orders DESC;


-- 10. Most common issue categories
SELECT 
    c.category_name,
    COUNT(wo.work_order_id) AS total_issues
FROM issue_categories c
LEFT JOIN work_orders wo ON c.category_id = wo.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_issues DESC;


-- 11. Asset condition report
SELECT 
    a.asset_id,
    a.asset_name,
    a.asset_tag,
    a.asset_status,
    b.building_name,
    r.room_number,
    at.type_name AS asset_type
FROM assets a
JOIN rooms r ON a.room_id = r.room_id
JOIN buildings b ON r.building_id = b.building_id
JOIN asset_types at ON a.asset_type_id = at.asset_type_id
ORDER BY 
    CASE a.asset_status
        WHEN 'OUT_OF_SERVICE' THEN 1
        WHEN 'POOR' THEN 2
        WHEN 'FAIR' THEN 3
        WHEN 'GOOD' THEN 4
    END,
    b.building_name,
    r.room_number;


-- 12. Poor or out-of-service assets needing attention
SELECT 
    a.asset_name,
    a.asset_tag,
    a.asset_status,
    at.type_name AS asset_type,
    b.building_name,
    r.room_number
FROM assets a
JOIN asset_types at ON a.asset_type_id = at.asset_type_id
JOIN rooms r ON a.room_id = r.room_id
JOIN buildings b ON r.building_id = b.building_id
WHERE a.asset_status IN ('POOR', 'OUT_OF_SERVICE')
ORDER BY 
    CASE a.asset_status
        WHEN 'OUT_OF_SERVICE' THEN 1
        WHEN 'POOR' THEN 2
    END;


-- 13. Completed work orders with resolution time
SELECT 
    wo.work_order_id,
    wo.title,
    b.building_name,
    r.room_number,
    wo.reported_at,
    wo.completed_at,
    ROUND((julianday(wo.completed_at) - julianday(wo.reported_at)) * 24, 2) AS resolution_hours
FROM work_orders wo
JOIN rooms r ON wo.room_id = r.room_id
JOIN buildings b ON r.building_id = b.building_id
WHERE wo.status = 'COMPLETED'
  AND wo.completed_at IS NOT NULL
ORDER BY resolution_hours ASC;


-- 14. Average resolution time for completed work orders
SELECT 
    ROUND(AVG((julianday(completed_at) - julianday(reported_at)) * 24), 2) AS average_resolution_hours
FROM work_orders
WHERE status = 'COMPLETED'
  AND completed_at IS NOT NULL;


-- 15. Work orders without assigned technicians
SELECT 
    wo.work_order_id,
    wo.title,
    wo.priority,
    wo.status,
    b.building_name,
    r.room_number
FROM work_orders wo
JOIN rooms r ON wo.room_id = r.room_id
JOIN buildings b ON r.building_id = b.building_id
LEFT JOIN assignments a ON wo.work_order_id = a.work_order_id
WHERE a.assignment_id IS NULL
ORDER BY wo.priority DESC, wo.reported_at DESC;


-- 16. Work order assignment details
SELECT 
    wo.work_order_id,
    wo.title,
    wo.status,
    tech.full_name AS technician_name,
    sup.full_name AS assigned_by,
    a.assigned_at,
    a.assignment_role
FROM assignments a
JOIN work_orders wo ON a.work_order_id = wo.work_order_id
JOIN users tech ON a.technician_id = tech.user_id
JOIN users sup ON a.assigned_by = sup.user_id
ORDER BY a.assigned_at DESC;


-- 17. Status history audit trail for all work orders
SELECT 
    sh.history_id,
    sh.work_order_id,
    wo.title,
    sh.old_status,
    sh.new_status,
    u.full_name AS changed_by,
    sh.changed_at,
    sh.changed_note
FROM status_history sh
JOIN work_orders wo ON sh.work_order_id = wo.work_order_id
JOIN users u ON sh.changed_by = u.user_id
ORDER BY sh.work_order_id, sh.changed_at;


-- 18. Room-level issues where no specific asset was selected
SELECT 
    wo.work_order_id,
    wo.title,
    wo.priority,
    wo.status,
    b.building_name,
    r.room_number,
    wo.reported_at
FROM work_orders wo
JOIN rooms r ON wo.room_id = r.room_id
JOIN buildings b ON r.building_id = b.building_id
WHERE wo.asset_id IS NULL;


-- 19. Buildings with room and asset counts
SELECT 
    b.building_name,
    COUNT(DISTINCT r.room_id) AS total_rooms,
    COUNT(a.asset_id) AS total_assets
FROM buildings b
LEFT JOIN rooms r ON b.building_id = r.building_id
LEFT JOIN assets a ON r.room_id = a.room_id
GROUP BY b.building_id, b.building_name
ORDER BY total_assets DESC;


-- 20. Dashboard summary
SELECT 
    (SELECT COUNT(*) FROM buildings) AS total_buildings,
    (SELECT COUNT(*) FROM rooms) AS total_rooms,
    (SELECT COUNT(*) FROM assets) AS total_assets,
    (SELECT COUNT(*) FROM work_orders) AS total_work_orders,
    (SELECT COUNT(*) FROM work_orders WHERE status IN ('OPEN', 'ASSIGNED', 'IN_PROGRESS', 'ON_HOLD')) AS active_work_orders,
    (SELECT COUNT(*) FROM work_orders WHERE status = 'COMPLETED') AS completed_work_orders,
    (SELECT COUNT(*) FROM users WHERE role = 'TECHNICIAN') AS total_technicians;