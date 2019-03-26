/*
 * Block Comment
 */
CREATE TABLE test_table (
  name  TEXT, 
  age   INTEGER, -- line comment
  score REAL,
  -- NOTE: type NUM would accept either INTEGER or REAL
  tf    BOOLEAN,
  -- YYYY-mm-dd HH:MM:SS (UTC time)
  -- equivalent: strftime('%Y-%m-%d %H:%M:%S', 'now')
  timestamp_default         DATETIME DEFAULT CURRENT_TIMESTAMP,
  timestamp_millisec        TEXT,
  timestamp_json_zulu       TEXT,
  timestamp_unixepoch_int   INTEGER,
  timestamp_unixepoch_real  REAL,
  PRIMARY KEY (name)
);
CREATE TRIGGER test_table_trigger_insert_timestamp 
  AFTER INSERT ON test_table
  BEGIN
    UPDATE test_table SET timestamp_default       = datetime('now')
      WHERE name=NEW.name;
    UPDATE test_table SET timestamp_millisec      = strftime('%Y-%m-%d %H:%M:%f', 'now')
      WHERE name=NEW.name;
    UPDATE test_table SET timestamp_json_zulu     = strftime('%Y-%m-%dT%H:%M:%SZ', 'now')
      WHERE name=NEW.name;
    UPDATE test_table SET timestamp_unixepoch_int = strftime('%s','now')
      WHERE name=NEW.name;
  END;
CREATE TRIGGER test_table_trigger_update_timestamp 
  AFTER UPDATE OF name, age, score, tf ON test_table
  BEGIN
    UPDATE test_table SET timestamp_default         = datetime('now')
      WHERE name=NEW.name;
    UPDATE test_table SET timestamp_millisec        = strftime('%Y-%m-%d %H:%M:%f', 'now')
      WHERE name=NEW.name;
    UPDATE test_table SET timestamp_json_zulu       = strftime('%Y-%m-%dT%H:%M:%SZ', 'now')
      WHERE name=NEW.name;
    UPDATE test_table SET timestamp_unixepoch_int   = strftime('%s','now')
      WHERE name=NEW.name;
  END;
CREATE TRIGGER test_table_trigger_insert_timestamp_real 
  AFTER INSERT ON test_table
  WHEN (NEW.timestamp_unixepoch_real IS NULL)
  BEGIN
    UPDATE test_table SET timestamp_unixepoch_real  = (julianday('now') - 2440587.5)*86400.0
      WHERE name=NEW.name;
  END;
CREATE TRIGGER test_table_trigger_update_timestamp_real 
  AFTER UPDATE OF name, age, score, tf ON test_table
  WHEN (OLD.timestamp_unixepoch_real == NEW.timestamp_unixepoch_real) -- not changed
  BEGIN
    UPDATE test_table SET timestamp_unixepoch_real  = (julianday('now') - 2440587.5)*86400.0
      WHERE name=NEW.name;
  END;

-- NOTE: Found FOR EACH ROW to change all rows in the database without a WHERE clause in statements. 
-- NOTE: Found WHEN to apply to overall TRIGGER, not individual statements within BEGIN/END.
-- NOTE: TRIGGER AFTER UPDATE can access OLD and NEW rows, but not the statement values.

INSERT INTO test_table (name, age, score, tf)
VALUES ( 'Friz', 145, 4.32, 0 );

INSERT INTO test_table (name, age, score, tf)
VALUES ( 'Mozu', 2, 3.1415, 1 );

INSERT INTO test_table (name, age, score, tf, timestamp_unixepoch_real)
VALUES ( 'Rela', 2, 6.2830, 1, 29.014);

INSERT INTO test_table (name, age, score, tf, timestamp_unixepoch_real) 
VALUES ( 'Zing', 3, 4.321, 0, 1.111);

UPDATE test_table SET age=4, score=1.234, tf=0, timestamp_unixepoch_real=8.888 
  WHERE name = 'Zing';

INSERT INTO test_table (name, age, score, tf, timestamp_unixepoch_real) 
  VALUES ( 'Qtii', 3, 4.321, 0, -0.101);

UPDATE test_table SET age=7, score=2.345, tf=0 
  WHERE name = 'Qtii';

-- ------------------------------------------
-- Import "sync_history_table"
-- ------------------------------------------

-- :NYI: sync_history_table is not yet implemented

