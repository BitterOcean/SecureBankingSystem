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

CREATE OR REPLACE PROCEDURE get_password(
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

#CALL get_password('mazrouee99', @password); 
#SELECT @password;
#------------------------------------------------------------------
DELIMITER $$

CREATE OR REPLACE PROCEDURE check_ban(
	IN _username VARCHAR(50),
    OUT _status int
)
BEGIN
	DECLARE ban DECIMAL DEFAULT 0;
    SELECT COUNT(*)
    INTO ban
    FROM ban_users
    WHERE username = _username and ban_times <> 0 
    and CURRENT_TIMESTAMP < finished_at;
    IF ban > 0 THEN
        SET _status = 1;
    ELSE
        SET _status = 0;
    END IF;
END$$

DELIMITER ;