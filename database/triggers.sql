--CIMWOMS Triggers
--Campus Infrastructure Maintenance & Work Order Management System
--These triggers add automation and data integrity to the database.


PRAGMA foreign_keys = ON;

--=============================================================================================================
--Trigger 1:
--Automatically add a record into status_history when a nework order is created.
--
--This records the first status of the work order. old_status will be NULL because there was no previous status.
--=====================================================================================================




CREATE TRIGGER IF NOT EXISTS trg_work_order_initial_status
AFTER INSERT ON work_orders
FOR EACH ROW
BEGIN
    INSERT INTO status_history (
        work_order_id,
        old_status,
        new_status,
        changed_by,
        changed_at,
        changed_note
    )
    VALUES (
        NEW.work_order_id,
        NULL,
        NEW.status,
        NEW.reported_by,
        CURRENT_TIMESTAMP,
        'Work order created with initial status'
    );
END;


--==================================================================
--Trigger 2:
--Automatically add a record into status_history whenever the status of a work order changes.
--
--This creates an audit trail of status changes.
--==============================================================

CREATE TRIGGER IF NOT EXISTS trg_work_order_status_change
AFTER UPDATE OF status ON work_orders
FOR EACH ROW
WHEN OLD.status != NEW.status
BEGIN
    INSERT INTO status_history (
        work_order_id,
        old_status,
        new_status,
        changed_by,
        changed_at,
        changed_note
    )
    VALUES (
        NEW.work_order_id,
        OLD.status,
        NEW.status,
        NEW.reported_by,
        CURRENT_TIMESTAMP,
        'Work order status automatically recorded by trigger'
    );
END;


--=========================================================
--Trigger 3:
--Automatically set completed_at when a work order status becomes COMPLETED.
--
--This prevents completed work orders from missing a completion timestamp.

--=========================================================



CREATE TRIGGER IF NOT EXISTS trg_set_completed_at
AFTER UPDATE OF status ON work_orders
FOR EACH ROW
WHEN NEW.status = 'COMPLETED'
     AND OLD.status != 'COMPLETED'
     AND NEW.completed_at IS NULL
BEGIN
    UPDATE work_orders
    SET completed_at = CURRENT_TIMESTAMP
    WHERE work_order_id = NEW.work_order_id;
END;









--=================================================================================================================
--Trigger 4:
--Automatically clear completed_at if a completed work order is reopened or moved back to another active status.
--
-- This keeps the completion date accurate.
--=============================================================================================================

CREATE TRIGGER IF NOT EXISTS trg_clear_completed_at
AFTER UPDATE OF status ON work_orders
FOR EACH ROW
WHEN OLD.status = 'COMPLETED'
     AND NEW.status != 'COMPLETED'
BEGIN
    UPDATE work_orders
    SET completed_at = NULL
    WHERE work_order_id = NEW.work_order_id;
END;




--============================================================================================================================
--Trigger 5:
--Prevent assigning a non-technician user as a technician.
--
--Only users with role = 'TECHNICIAN' can be placed in assignments. This protects the many-to-many assignment table.
--==============================================================================================================

CREATE TRIGGER IF NOT EXISTS trg_prevent_non_technician_assignment
BEFORE INSERT ON assignments
FOR EACH ROW
WHEN (
    SELECT role
    FROM users
    WHERE user_id = NEW.technician_id
) != 'TECHNICIAN'
BEGIN
    SELECT RAISE(
        ABORT,
        'Only users with role TECHNICIAN can be assigned to work orders'
    );
END;







--==============================================================================================
--Trigger 6:
--Prevent supervisors/reporters from assigning work orders if assigned_by is not a supervisor.
--
--This means only users with role = 'SUPERVISOR' can assign technicians to work orders.
--=============================================================================================

CREATE TRIGGER IF NOT EXISTS trg_prevent_non_supervisor_assignment
BEFORE INSERT ON assignments
FOR EACH ROW
WHEN (
    SELECT role
    FROM users
    WHERE user_id = NEW.assigned_by
) != 'SUPERVISOR'
BEGIN
    SELECT RAISE(
        ABORT,
        'Only users with role SUPERVISOR can assign work orders'
    );
END;





--==============================================================================================================================

--Trigger 7:
--Automatically change a work order status to ASSIGNED when a technician is assigned, but only if the work order is OPEN.
--
--This saves manual status updates.
--============================================================================================================================

CREATE TRIGGER IF NOT EXISTS trg_auto_set_assigned_status
AFTER INSERT ON assignments
FOR EACH ROW
WHEN (
    SELECT status
    FROM work_orders
    WHERE work_order_id = NEW.work_order_id
) = 'OPEN'
BEGIN
    UPDATE work_orders
    SET status = 'ASSIGNED'
    WHERE work_order_id = NEW.work_order_id;
END;
