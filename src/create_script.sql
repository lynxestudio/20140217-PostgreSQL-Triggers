CREATE TABLE invoices
(
    inv_id serial PRIMARY KEY,
    inv_number integer NOT NULL,
    inv_date date,
    inv_total money
);

CREATE TABLE invoices_audit
(
    inv_id serial PRIMARY KEY,
    inv_number int not null,
    inv_modified datetime not null default now(),
    inv_date date,
    inv_total money
);

CREATE TRIGGER tgr_invoice_history
AFTER DELETE OR UPDATE
ON invoices
FOR EACH ROW
    EXECUTE PROCEDURE usp_invoice_history();

CREATE OR REPLACE FUNCTION usp_invoice_history() returns TRIGGER AS
$$
    BEGIN
    INSERT INTO invoices_audit(inv_number,inv_date,inv_total,inv_modified,operation,operationwhen,inv_modifiedby)
    VALUES(OLD.inv_number,OLD.inv_date,OLD.inv_total,CURRENT_TIMESTAMP,TG_OP,TG_WHEN,CURRENT_USER);
    RETURN null;
    END;
$$
language 'plpgsql';

