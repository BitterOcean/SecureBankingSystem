DELIMITER $$

CREATE OR REPLACE PROCEDURE check_user(
	IN _username VARCHAR(50),
    OUT _status int
)
BEGIN
	DECLARE NumOfUsers DECIMAL DEFAULT 0;
    SELECT COUNT(*)
    INTO NumOfUsers
    FROM user
    WHERE username = _username;
    IF NumOfUsers > 0 THEN
        SET _status = 1;
    ELSE
        SET _status = 0;
    END IF;
END$$

DELIMITER ;

#CALL check_user('mazrouee99', @status); 
#SELECT @status;
#------------------------------------------------------------------
DELIMITER $$

CREATE OR REPLACE PROCEDURE add_user(
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

#CALL add_user('mazrouee99', '12345', 'gjjk');
#------------------------------------------------------------------
DELIMITER $$

CREATE OR REPLACE PROCEDURE get_password_salt(
	IN _username VARCHAR(50),
    OUT _password VARCHAR(200),
    OUT _salt VARCHAR(100)
)
BEGIN
    SELECT `password`
    INTO _password
    FROM user
    WHERE username = _username;
    SELECT salt
    INTO _salt
    FROM user
    WHERE username = _username;
END$$

DELIMITER ;
#------------------------------------------------------------------
/*DELIMITER $$

CREATE OR REPLACE PROCEDURE add_account(
    IN _account_no VARCHAR(10),
	IN _username VARCHAR(50),
    IN _type VARCHAR(30),
    IN _amount DECIMAL(15, 4),
    IN _conf_lable VARCHAR(1),
    IN _integrity_lable VARCHAR(1)
)
BEGIN
	START TRANSACTION;
	INSERT INTO account (account_no, opener_ID, `type`, amount, conf_lable, integrity_lable)
	VALUES (_account_no, _username, _type, _amount, _conf_lable, _integrity_lable);
    INSERT INTO account_user(username, account_no, conf_lable, integrity_lable)
    VALUES (_username, _account_no, _conf_lable, _integrity_lable);
	COMMIT;
END$$

DELIMITER ;

#CALL add_account('1234567890', 'mazrouee99', 'Short-term saving account',1250.26 ,'2' ,'3');*/
#------------------------------------------------------------------
DELIMITER $$

CREATE OR REPLACE PROCEDURE check_account_number(
	IN _account_no VARCHAR(10),
    OUT _status int
)
BEGIN
	DECLARE NumOfAccounts DECIMAL DEFAULT 0;
    SELECT COUNT(*)
    INTO NumOfAccounts
    FROM account
    WHERE account_no = _account_no;
    IF NumOfAccounts > 0 THEN
        SET _status = 1;
    ELSE
        SET _status = 0;
    END IF;
END$$

DELIMITER ;

#CALL check_account_number('1234567890', @status); 
#SELECT @status;
#------------------------------------------------------------------
DELIMITER $$

CREATE OR REPLACE PROCEDURE update_ban(
	IN _username VARCHAR(50)
)
BEGIN
	DECLARE _ban_times INT DEFAULT 0;
	SELECT ban_times
    INTO _ban_times
    FROM ban_users
    WHERE username = _username;
	
    START TRANSACTION;
	UPDATE ban_users
    SET
    	ban_times = _ban_times + 1,
        started_at = CURRENT_TIMESTAMP,
        finished_at = CURRENT_TIMESTAMP + INTERVAL 30 SECOND
    WHERE
    	username = _username;
	COMMIT;
END$$

DELIMITER ;

#CALL update_ban('mazrouee99');
#------------------------------------------------------------------
DELIMITER $$

CREATE OR REPLACE PROCEDURE check_ban(
	IN _username VARCHAR(50),
    OUT _status int,
    OUT remaining_time int
)
BEGIN
	DECLARE ban DECIMAL DEFAULT 0;
    
    SELECT COUNT(*)
    INTO ban
    FROM ban_users
    WHERE username = _username and ban_times <> 0 
    and CURRENT_TIMESTAMP < finished_at;
    
    SELECT TIME_TO_SEC(TIMEDIFF(finished_at, CURRENT_TIMESTAMP)) diff
    INTO remaining_time
    FROM ban_users
    WHERE username = _username;
    
    IF ban > 0 THEN
        SET _status = 1;
    ELSE
        SET _status = 0;
        SET remaining_time = 0;
    END IF;
END$$

DELIMITER ;

#CALL check_ban('mazrouee99', @status, @remain_time);
#SELECT @status;
#SELECT @remain_time;
#------------------------------------------------------------------
DELIMITER $$

CREATE OR REPLACE PROCEDURE add_account(
	IN _username VARCHAR(50),
    IN _type VARCHAR(30),
    IN _amount DECIMAL(15, 4),
    IN _conf_lable VARCHAR(1),
    IN _integrity_lable VARCHAR(1),
    OUT _account_no VARCHAR(10)
)
BEGIN
	DECLARE AC int DEFAULT 1000000000;
	WHILE (SELECT COUNT(*)
           FROM account
           WHERE AC in (SELECT CAST(account_no as int) FROM account)) DO
		SET AC = AC + 1;
    END WHILE;
    SELECT CAST(AC as char(10))
    INTO _account_no;
           
	START TRANSACTION;
	INSERT INTO account (account_no, opener_ID, `type`, amount, conf_lable, integrity_lable)
	VALUES (_account_no, _username, _type, _amount, _conf_lable, _integrity_lable);
    INSERT INTO account_user(username, account_no, conf_lable, integrity_lable)
    VALUES (_username, _account_no, _conf_lable, _integrity_lable);
	COMMIT;
END$$

DELIMITER ;

#CALL add_account('mazrouee99', 'Short-term saving account',1250.26 ,'2' ,'3', @account_number);
#SELECT @account_number;
#------------------------------------------------------------------


DELIMITER $$
CREATE or REPLACE PROCEDURE Show_MyAccount(IN _username VARCHAR(50))
BEGIN
   (select account_user.account_no as account_no
   from account_user
   where account_user.username = _username)
   UNION
   (select account.account_no as account_no
   from account
   where account.opener_ID = _username);
END$$
GO


DELIMITER $$
CREATE or REPLACE PROCEDURE add_account_user(IN _account_no int(10),
                                             IN _username VARCHAR(50), 
                                             IN _conf_lable VARCHAR(1), 
                                             IN _integrity_lable VARCHAR(1))
BEGIN
	INSERT INTO account_user(account_no, username, conf_lable, integrity_lable)
	SELECT _account_no, _username, _conf_lable, _integrity_lable
	FROM DUAL
	WHERE NOT EXISTS(
    	SELECT 1
    	FROM account_user
    	WHERE account_no = _account_no AND username = _username
	)
	LIMIT 1;
END$$
GO


DELIMITER $$
CREATE or REPLACE PROCEDURE five_withdraw(IN _account_no int(10))
BEGIN
	SELECT * FROM transaction
	WHERE from_account_no = _account_no AND to_account_no = _account_no
	ORDER BY timestamp DESC
	LIMIT 5;
END$$
GO


DELIMITER $$
CREATE or REPLACE PROCEDURE five_Deposit(IN _account_no int(10))
BEGIN
	SELECT * FROM transaction
	WHERE to_account_no = _account_no AND from_account_no <> _account_no
	ORDER BY timestamp DESC
	LIMIT 5;
END$$
GO


DELIMITER $$
CREATE or REPLACE PROCEDURE account_info(IN _account_no int(10))
BEGIN
	SELECT account.type, account.created_at, account.amount, account.opener_ID 
    FROM account
	WHERE from_account_no = _account_no;
END$$
GO