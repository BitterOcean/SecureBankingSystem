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
        SET _status = 0;
    ELSE
        SET _status = 1;
    END IF;
END$$

DELIMITER ;

CALL check_user('mazrouee99', @status); 
SELECT @status;
#------------------------------------------------------------------
DELIMITER $$

CREATE OR REPLACE PROCEDURE add_user(
	IN _username VARCHAR(50),
    IN _password VARCHAR(200),
    IN _salt VARCHAR(100)
)
BEGIN
	INSERT INTO user (username, `password`, salt)
	VALUES (_username, _password, _salt);
END$$

DELIMITER ;

CALL add_user('mazrouee99', '12345', 'gjjk');
#------------------------------------------------------------------
