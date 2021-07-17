USE fakebankingsystem
GO


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
    FROM Login_Request_Log
    WHERE username = _username;

    SELECT salt
    INTO _salt
    FROM Login_Request_Log
    WHERE username = _username;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS update_ban;
DELIMITER $$
CREATE PROCEDURE update_ban(
	IN _username VARCHAR(50)
)
BEGIN
	DECLARE user_exists INT DEFAULT 0;
	DECLARE _ban_times INT DEFAULT 0;
    
    SELECT COUNT(*)
    INTO user_exists
    FROM ban_users
    WHERE username = _username;
    
    IF user_exists > 0 THEN
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
	ELSE
    	START TRANSACTION;
        INSERT INTO Ban_Users (username, ban_times, started_at, finished_at)
    	VALUES(_username, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL 30 SECOND);
        COMMIT;
	END IF;
END$$

DELIMITER ;