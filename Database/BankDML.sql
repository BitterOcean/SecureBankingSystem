USE securebankingsystem
GO

----------------------------------------
------------- Procedures ---------------
----------------------------------------
DROP PROCEDURE IF EXISTS check_user;
DELIMITER $$
CREATE PROCEDURE check_user(
	IN _username VARCHAR(50),
  OUT _status INT
)
BEGIN
	DECLARE numOfUsers DECIMAL DEFAULT 0;
  SELECT COUNT(*)
  INTO numOfUsers
  FROM User
  WHERE username = _username;

  IF numOfUsers > 0 THEN
      SET _status = 1;
  ELSE
      SET _status = 0;
  END IF;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS add_user;
DELIMITER $$
CREATE PROCEDURE add_user(
	IN _username VARCHAR(50),
  IN _password VARCHAR(200),
  IN _salt VARCHAR(100)
)
BEGIN
	START TRANSACTION;
	INSERT INTO user (username, `password`, salt)
	  VALUES (_username, _password, _salt);
	COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS get_password;
DELIMITER $$
CREATE PROCEDURE get_password(
	IN _username VARCHAR(50),
  OUT _password VARCHAR(200)
)
BEGIN
    SELECT `password`
    INTO _password
    FROM user
    WHERE username = _username;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS check_ban;
DELIMITER $$
CREATE PROCEDURE check_ban(
	IN _username VARCHAR(50),
  OUT _status INT
)
BEGIN
	DECLARE ban DECIMAL DEFAULT 0;
  SELECT COUNT(*)
  INTO ban
  FROM ban_users
  WHERE username = _username
    AND ban_times <> 0
    AND CURRENT_TIMESTAMP < finished_at;
  IF ban > 0 THEN
      SET _status = 1;
  ELSE
      SET _status = 0;
  END IF;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS deposit;
DELIMITER $$
CREATE PROCEDURE deposit(
  IN _username VARCHAR(50),
	IN _from_account_no INT(10),
  IN _to_account_no INT(10),
  IN _amount DECIMAL(7, 4)
)
BEGIN
	START TRANSACTION;
	INSERT INTO `Transaction` (
    username,
    from_account_no,
    to_account_no,
    amount,
    `status`
    )
	  VALUES (
      _username,
      _from_account_no,
      _to_account_no,
      _amount,
      '1'
    );
	COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS withdraw;
DELIMITER $$
CREATE PROCEDURE withdraw(
  IN _username VARCHAR(50),
	IN _from_account_no INT(10),
  IN _to_account_no INT(10),
  IN _amount DECIMAL(7, 4)
)
BEGIN
	START TRANSACTION;
	INSERT INTO `Transaction` (
    username,
    from_account_no,
    to_account_no,
    amount,
    `status`
    )
	  VALUES (
      _username,
      _from_account_no,
      _to_account_no,
      (0 - _amount),
      '1'
    );
	COMMIT;
END$$

DELIMITER ;

----------------------------------------
------------- Triggers -----------------
----------------------------------------
DROP TRIGGER IF EXISTS auto_updated_at;
DELIMITER $$
CREATE TRIGGER auto_updated_at
AFTER UPDATE
ON Account
FOR EACH ROW
  UPDATE Account
  SET NEW.updated_at = CURRENT_TIMESTAMP
$$
DELIMITER ;
GO


DROP TRIGGER IF EXISTS auto_insert_ban_user;
DELIMITER $$
CREATE TRIGGER auto_insert_ban_user
AFTER INSERT
ON User
FOR EACH ROW
  INSERT INTO Ban_Users ( username, ban_times, started_at, finished_at )
    VALUES(NEW.username, 0, NULL, NULL)
$$
DELIMITER ;
GO


DROP TRIGGER IF EXISTS auto_update_account_balance_after_transaction;
DELIMITER $$
CREATE TRIGGER auto_update_account_balance_after_transaction
AFTER INSERT
ON `Transaction`
FOR EACH ROW
BEGIN
  -- update destination account balance
  UPDATE Account
  SET amount = amount + NEW.amount
  WHERE account_no = NEW.to_account_no;
  -- update origin account balance
  UPDATE Account
  SET amount = amount - NEW.amount
  WHERE account_no = NEW.from_account_no;
END$$
DELIMITER ;
GO
