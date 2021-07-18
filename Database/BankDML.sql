USE securebankingsystem
GO


DROP PROCEDURE IF EXISTS accept_join_request;
DELIMITER $$
CREATE PROCEDURE accept_join_request(
	IN _username VARCHAR(50),
  IN _account_no INT(10),
  IN _conf_lable VARCHAR(1),
  IN _integrity_lable VARCHAR(1)
)
BEGIN
	START TRANSACTION;
  UPDATE Join_Request
  SET `status` = '1'
  WHERE applicant_username = _username
    AND desired_account_no = _account_no;

	INSERT INTO Account_User (
    username,
    account_no,
    conf_lable,
    integrity_lable
    ) VALUES (
      _username,
      _account_no,
      _conf_lable,
      _integrity_lable
    );
	COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS account_info;
DELIMITER $$
CREATE PROCEDURE account_info(IN _account_no INT(10))
BEGIN
	SELECT `type`, created_at, amount, opener_ID
  FROM Account
	WHERE account_no = _account_no;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS add_accept_log;
DELIMITER $$
CREATE PROCEDURE add_accept_log(
	IN _applicant_username VARCHAR(50),
	IN _sender_username VARCHAR(50),
  IN _conf_lable VARCHAR(1),
  IN _integrity_lable VARCHAR(1),
  IN _ip VARCHAR(20),
	IN _port VARCHAR(20),
  IN _status VARCHAR(1)
)
BEGIN
	START TRANSACTION;
	INSERT INTO Accept_Request_Log (sender_username, applicant_username, conf_lable, integrity_lable, ip, port, `status`)
	  VALUES (_sender_username, _applicant_username, _conf_lable, _integrity_lable, _ip, _port, _status);
	COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS add_account;
DELIMITER $$
CREATE PROCEDURE add_account(
	IN _username VARCHAR(50),
  IN _type VARCHAR(30),
  IN _amount DECIMAL(19, 4),
  IN _conf_lable VARCHAR(1),
  IN _integrity_lable VARCHAR(1),
  OUT _account_no VARCHAR(10)
)
BEGIN
	DECLARE AC INT DEFAULT 1000000000;
	WHILE (SELECT COUNT(*)
         FROM Account
         WHERE AC in (SELECT CAST(account_no AS INT) FROM Account)) DO
		SET AC = AC + 1;
  END WHILE;
  SELECT CAST(AC AS CHAR(10))
  INTO _account_no;

	START TRANSACTION;
	INSERT INTO Account (account_no, opener_ID, `type`, amount, conf_lable, integrity_lable)
	  VALUES (_account_no, _username, _type, _amount, _conf_lable, _integrity_lable);
	COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS add_account_user;
DELIMITER $$
CREATE PROCEDURE add_account_user(
    IN _account_no INT(10),
    IN _username VARCHAR(50),
    IN _conf_lable VARCHAR(1),
    IN _integrity_lable VARCHAR(1))
BEGIN
	INSERT INTO account_user(account_no, username, conf_lable, integrity_lable)
	SELECT _account_no, _username, _conf_lable, _integrity_lable
	FROM DUAL
	WHERE NOT EXISTS(
    	SELECT 1
    	FROM Account_User
    	WHERE account_no = _account_no AND username = _username
	)
	LIMIT 1;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS add_deposit_log;
DELIMITER $$
CREATE PROCEDURE add_deposit_log (
  IN _username VARCHAR(50),
  IN _from_account_no INT(20),
  IN _to_account_no INT(20),
  IN _amount DECIMAL(11, 4),
  IN _ip VARCHAR(20),
	IN _port VARCHAR(20),
  IN _status VARCHAR(1)
)
BEGIN
	START TRANSACTION;
	INSERT INTO Deposit_Request_Log (username, from_account_no, to_account_no, amount, ip, port, `status`)
	  VALUES (_username, _from_account_no, _to_account_no, _amount, _ip, _port, _status);
	COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS add_join_log;
DELIMITER $$
CREATE PROCEDURE add_join_log(
	IN _applicant_username VARCHAR(50),
  IN _desired_account_no INT(50),
  IN _ip VARCHAR(20),
	IN _port VARCHAR(20),
  IN _status VARCHAR(1)
)
BEGIN
	START TRANSACTION;
	INSERT INTO Join_Request_Log (applicant_username, desired_account_no, ip, port, `status`)
	  VALUES (_applicant_username, _desired_account_no, _ip, _port, _status);
	COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS add_login_log;
DELIMITER $$
CREATE PROCEDURE add_login_log(
	IN _username VARCHAR(50),
  IN _password VARCHAR(200),
  IN _salt VARCHAR(100),
  IN _ip VARCHAR(20),
  IN _port VARCHAR(6),
  IN _status VARCHAR(1)
)
BEGIN
	START TRANSACTION;
	INSERT INTO Login_Request_Log (username, `password`, salt, ip, port, `status`)
	  VALUES (_username, _password, _salt, _ip, _port, _status);
	COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS add_show_account_log;
DELIMITER $$
CREATE PROCEDURE add_show_account_log(
	IN _username VARCHAR(50),
  IN _account_no INT(50),
  IN _ip VARCHAR(20),
  IN _port VARCHAR(6),
  IN _status VARCHAR(1)
)
BEGIN
	START TRANSACTION;
	INSERT INTO ShowAccount_Request_Log (username, account_no, ip, port, `status`)
	  VALUES (_username, _account_no, _ip, _port, _status);
	COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS add_show_my_account_log;
DELIMITER $$
CREATE PROCEDURE add_show_my_account_log(
	IN _username VARCHAR(50),
  IN _ip VARCHAR(20),
  IN _port VARCHAR(6),
  IN _status VARCHAR(1)
)
BEGIN
	START TRANSACTION;
	INSERT INTO ShowMyAccount_Request_Log (username, ip, port, `status`)
	  VALUES (_username, _ip, _port, _status);
	COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS add_show_my_join_request_log;
DELIMITER $$
CREATE PROCEDURE add_show_my_join_request_log(
	IN _username VARCHAR(50),
  IN _ip VARCHAR(20),
  IN _port VARCHAR(6),
  IN _status VARCHAR(1)
)
BEGIN
	START TRANSACTION;
	INSERT INTO ShowMyJoinRequests_Log (username, ip, port, `status`)
	  VALUES (_username, _ip, _port, _status);
	COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS add_signup_log;
DELIMITER $$
CREATE PROCEDURE add_signup_log(
    IN _username VARCHAR(50),
    IN _password VARCHAR(200),
    IN _salt VARCHAR(100),
    IN _status VARCHAR(1)
)
BEGIN
	START TRANSACTION;
	INSERT INTO Signup_Request_Log (username, `password`, salt, `status`)
	  VALUES (_username, _password, _salt, _status);
	COMMIT;
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
	INSERT INTO User (username, `password`, salt)
	  VALUES (_username, _password, _salt);
	COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS add_withdraw_log;
DELIMITER $$
CREATE PROCEDURE add_withdraw_log (
  IN _username VARCHAR(50),
  IN _account_no INT(20),
  IN _amount DECIMAL(11, 4),
  IN _ip VARCHAR(20),
	IN _port VARCHAR(20),
  IN _status VARCHAR(1)
)
BEGIN
	START TRANSACTION;
	INSERT INTO Withdraw_Request_Log (username, account_no, amount, ip, port, `status`)
	  VALUES (_username, _account_no, _amount, _ip, _port, _status);
	COMMIT;
END$$

DELIMITER ;


DROP TRIGGER IF EXISTS auto_account_updated_at;
DELIMITER $$
CREATE TRIGGER auto_account_updated_at
BEFORE UPDATE
ON Account
FOR EACH ROW
  SET NEW.updated_at = CURRENT_TIMESTAMP;
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
    VALUES(NEW.username, 0, NULL, NULL);
$$
DELIMITER ;
GO

DROP TRIGGER IF EXISTS auto_join_updated_at;
DELIMITER $$
CREATE TRIGGER auto_join_updated_at
BEFORE UPDATE
ON Join_Request
FOR EACH ROW
  SET NEW.updated_at = CURRENT_TIMESTAMP;
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
  SET amount = CASE
                  WHEN amount + NEW.amount >= 0 THEN amount + NEW.amount
                  ELSE amount
                END
  WHERE account_no = NEW.to_account_no;
  -- update origin account balance
  IF NEW.to_account_no <> NEW.from_account_no THEN
    UPDATE Account
    SET amount = CASE
                  WHEN amount - NEW.amount >= 0 THEN amount - NEW.amount
                  ELSE amount
                END
    WHERE account_no = NEW.from_account_no;
  END IF;
END$$
DELIMITER ;
GO


DROP PROCEDURE IF EXISTS check_account_number;
DELIMITER $$
CREATE PROCEDURE check_account_number(
	IN _account_no INT(10),
  OUT _status INT
)
BEGIN
	DECLARE NumOfAccounts DECIMAL DEFAULT 0;
    SELECT COUNT(*)
    INTO NumOfAccounts
    FROM Account
    WHERE account_no = _account_no;

    IF NumOfAccounts > 0 THEN
        SET _status = 1;
    ELSE
        SET _status = 0;
    END IF;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS check_balance;
DELIMITER $$
CREATE PROCEDURE check_balance (
  IN _account_no INT(10),
  IN _amount DECIMAL(11, 4),
  OUT _ret INT
)
BEGIN
  DECLARE balance DECIMAL(19, 4);
  SELECT amount
  INTO balance
  FROM Account
  WHERE account_no = _account_no;

  IF balance >= _amount THEN
    SET _ret = 1;
  ELSE
    SET _ret = 0;
  END IF;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS check_ban;
DELIMITER $$
CREATE PROCEDURE check_ban(
	IN _username VARCHAR(50),
  OUT _status INT,
  OUT remaining_time INT
)
BEGIN
	DECLARE ban DECIMAL DEFAULT 0;
  SELECT COUNT(*)
  INTO ban
  FROM Ban_Users
  WHERE username = _username
    AND ban_times <> 0
    AND CURRENT_TIMESTAMP < finished_at;

  SELECT TIME_TO_SEC(TIMEDIFF(finished_at, CURRENT_TIMESTAMP)) diff
  INTO remaining_time
  FROM Ban_Users
  WHERE username = _username;

  IF ban > 0 THEN
      SET _status = 1;
  ELSE
      SET _status = 0;
      SET remaining_time = 0;
  END IF;
END$$

DELIMITER ;


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


DROP PROCEDURE IF EXISTS create_join_request;
DELIMITER $$
CREATE PROCEDURE create_join_request(
  IN _applicant_username VARCHAR(50),
	IN _desired_account_no INT(10)
)
BEGIN
	START TRANSACTION;
	INSERT INTO Join_Request (applicant_username, desired_account_no)
	  VALUES (_applicant_username, _desired_account_no);
	COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS deposit;
DELIMITER $$
-- Deposit ~ transfare from_account_no to_account_no
CREATE PROCEDURE deposit(
  IN _username VARCHAR(50),
	IN _from_account_no INT(10),
  IN _to_account_no INT(10),
  IN _amount DECIMAL(11, 4)
)
BEGIN
	START TRANSACTION;
	INSERT INTO `Transaction` (
    username,
    from_account_no,
    to_account_no,
    amount
    ) VALUES (
      _username,
      _from_account_no,
      _to_account_no,
      _amount
    );
	COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS five_Deposit;
DELIMITER $$
CREATE PROCEDURE five_Deposit(IN _account_no INT(10))
BEGIN
	SELECT from_account_no, amount, created_at
  FROM `Transaction`
	WHERE to_account_no = _account_no
        AND from_account_no <> _account_no
	ORDER BY created_at DESC
	LIMIT 5;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS five_withdraw;
DELIMITER $$
CREATE PROCEDURE five_withdraw(IN _account_no INT(10))
BEGIN
	SELECT ABS(amount), created_at
  FROM `Transaction`
	WHERE from_account_no = _account_no
	ORDER BY created_at DESC
	LIMIT 5;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS get_account_conf_label;
DELIMITER $$
CREATE PROCEDURE get_account_conf_label(
	IN _account_no INT(10),
  OUT _conf_lable VARCHAR(1)
)
BEGIN
    SELECT conf_lable
    INTO _conf_lable
    FROM Account
    WHERE account_no = _account_no;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS get_account_integrity_label;
DELIMITER $$
CREATE PROCEDURE get_account_integrity_label(
	IN _account_no INT(10),
  OUT _integrity_lable VARCHAR(1)
)
BEGIN
    SELECT integrity_lable
    INTO _integrity_lable
    FROM Account
    WHERE account_no = _account_no;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS get_user_conf_label;
DELIMITER $$
CREATE PROCEDURE get_user_conf_label(
	IN _username VARCHAR(50),
  IN _account_no INT(10),
  OUT _conf_lable VARCHAR(1)
)
BEGIN
    SELECT conf_lable
    INTO _conf_lable
    FROM Account_User
    WHERE account_no = _account_no
      AND username = _username;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS get_user_integrity_label;
DELIMITER $$
CREATE PROCEDURE get_user_integrity_label(
	IN _username VARCHAR(50),
  IN _account_no INT(10),
  OUT _integrity_lable VARCHAR(1)
)
BEGIN
    SELECT integrity_lable
    INTO _integrity_lable
    FROM Account_User
    WHERE account_no = _account_no
      AND username = _username;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS get_password_salt;
DELIMITER $$
CREATE PROCEDURE get_password_salt(
	IN _username VARCHAR(50),
  OUT _password VARCHAR(200),
  OUT _salt VARCHAR(100)
)
BEGIN
    SELECT `password`
    INTO _password
    FROM User
    WHERE username = _username;

    SELECT salt
    INTO _salt
    FROM User
    WHERE username = _username;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS is_account_owner;
DELIMITER $$
CREATE PROCEDURE is_account_owner(
  IN _username VARCHAR(50),
  IN _account_no INT(10),
  OUT _ret INT
)
BEGIN
  SELECT EXISTS(
    SELECT account_no
    FROM Account
    WHERE account_no = _account_no
      AND opener_ID = _username
  ) INTO _ret;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS is_join_from_username_for_account;
DELIMITER $$
CREATE PROCEDURE is_join_from_username_for_account(
  IN _username VARCHAR(50),
  IN _account_no INT(10),
  OUT _ret INT
)
BEGIN
  SELECT EXISTS(
    SELECT join_ID
    FROM Join_Request
    WHERE desired_account_no = _account_no
      AND applicant_username = _username
  ) INTO _ret;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS is_user_joint_account;
DELIMITER $$
CREATE PROCEDURE is_user_joint_account(
  IN _username VARCHAR(50),
  IN _account_no INT(10),
  OUT _ret INT
)
BEGIN
  SELECT EXISTS(
    SELECT account_user_ID
    FROM Account_User
    WHERE account_no = _account_no
      AND username = _username
  ) INTO _ret;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS my_own_account;
DELIMITER $$
CREATE PROCEDURE my_own_account(
  IN _username VARCHAR(50),
  OUT _ret INT(10)
)
BEGIN
	SELECT account_no
  INTO _ret
  FROM Account
	WHERE opener_ID = _username;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS Show_MyAccount;
DELIMITER $$
CREATE PROCEDURE Show_MyAccount(IN _username VARCHAR(50))
BEGIN
    (
        SELECT account_no
        FROM Account_User
        WHERE username = _username
    )
   UNION
    (
        SELECT account_no
        FROM Account
        WHERE opener_ID = _username
    );
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS Show_MyJoinRequests;
DELIMITER $$
CREATE PROCEDURE Show_MyJoinRequests(IN _username VARCHAR(50))
BEGIN
	SELECT applicant_username
  FROM Join_Request INNER JOIN Account
    ON Join_Request.desired_account_no = Account.account_no
  WHERE Join_Request.status = '0'
    AND Account.opener_ID = _username;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS update_ban;
DELIMITER $$
CREATE PROCEDURE update_ban(
	IN _username VARCHAR(50)
)
BEGIN
	DECLARE _ban_times INT DEFAULT 0;
	SELECT ban_times
  INTO _ban_times
  FROM Ban_Users
  WHERE username = _username;

  START TRANSACTION;
	UPDATE Ban_Users
  SET ban_times = _ban_times + 1,
      started_at = CURRENT_TIMESTAMP,
      finished_at = CURRENT_TIMESTAMP + INTERVAL 30 SECOND
  WHERE username = _username;
	COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS update_ban_user;
DELIMITER $$
CREATE PROCEDURE update_ban_user(
  IN _username VARCHAR(50),
  IN _ban_times INT,
	IN _started_at DATETIME,
  IN _finished_at DATETIME
)
BEGIN
	UPDATE Ban_Users
    SET ban_times = _ban_times,
        started_at = _started_at,
        finished_at = _finished_at
    WHERE username = _username;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS withdraw;
DELIMITER $$
-- Withdraw ~ withdraw from_account_no
-- to_account_no is additional (project bug!)
CREATE PROCEDURE withdraw(
  IN _username VARCHAR(50),
	IN _account_no INT(10),
  IN _amount DECIMAL(11, 4)
)
BEGIN
	START TRANSACTION;
	INSERT INTO `Transaction` (
    username,
    from_account_no,
    to_account_no,
    amount
    ) VALUES (
      _username,
      _account_no,
      _account_no,
      (0 - _amount)
    );
	COMMIT;
END$$

DELIMITER ;
