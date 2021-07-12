USE securebankingsystem
GO


DROP FUNCTION IF EXISTS is_ban;
DELIMITER //

CREATE FUNCTION is_ban(username_var varchar(255))
  RETURNS INT
  LANGUAGE SQL
  DETERMINISTIC
  CONTAINS SQL
  SQL SECURITY DEFINER
  COMMENT 'returns 0 if the user is banned and 1 otherwise'
    BEGIN
      SET @ban_times_var := (SELECT ban_times FROM Ban_Users WHERE username = username_var);
      SET @started_at_var := (SELECT started_at FROM Ban_Users WHERE username = username_var);
      SET @finished_at_var := (SELECT finished_at FROM Ban_Users WHERE username = username_var);

      IF (@started_at_var IS NULL OR @ban_times_var = 0) THEN
        SET @ret = 0;
      ELSE
        IF (TIMESTAMPDIFF(MINUTE, @started_at_var, @finished_at_var) < 0) THEN
          SET @ret = 1;
        ELSE
          SET @ret = 0;
        END IF;
      END IF;

      RETURN @ret;
    END
//
DELIMITER ;
GO


DROP FUNCTION IF EXISTS find_last_failed_login;
DELIMITER //

CREATE FUNCTION find_last_failed_login(username_var VARCHAR(255))
  RETURNS INT
  LANGUAGE SQL
  DETERMINISTIC
  CONTAINS SQL
  SQL SECURITY DEFINER
  COMMENT 'returns the number of failed logins from the last successful login'
    BEGIN
      SET @one_day_befor_today = (SELECT ADDDATE(CURDATE(), INTERVAL -1 DAY));

      SET @last_success_login = (
        SELECT created_at
        FROM Login_Request_Log
        WHERE username = username_var
          AND `status` = '1'
      );

      SET @max_date = (
        SELECT CASE
            WHEN @last_success_login > @one_day_befor_today THEN @last_success_login
            ELSE @one_day_befor_today
          END
      );

      SET @ret = (
        SELECT count(*)
        FROM Login_Request_Log
        WHERE username = username_var
          AND `status` = '0'
          AND created_at > @max_date
      );

      RETURN @ret;
    END
//
DELIMITER ;
GO


DROP FUNCTION IF EXISTS check_password;
DELIMITER //

CREATE FUNCTION check_password(username_var VARCHAR(255), password_var VARCHAR(500))
  RETURNS INT
  LANGUAGE SQL
  DETERMINISTIC
  CONTAINS SQL
  SQL SECURITY DEFINER
  COMMENT 'returns 1 if the password is correct and 0 otherwise'
    BEGIN
      SET @ret = 0;
      SET @pass = (
        SELECT `password`
        FROM User
        WHERE username = username_var
      );

      IF @pass = password_var THEN
        SET @ret = 1;
      END IF;

      RETURN @ret;
    END
//
DELIMITER ;
GO


DROP TRIGGER IF EXISTS auto_updated_at;
DELIMITER //

CREATE TRIGGER auto_updated_at
AFTER UPDATE
ON Account
FOR EACH ROW
  UPDATE Account
  SET NEW.updated_at = CURRENT_TIMESTAMP
//
DELIMITER ;
GO


DROP TRIGGER IF EXISTS auto_insert_ban_user;
DELIMITER //

CREATE TRIGGER auto_insert_ban_user
AFTER INSERT
ON User
FOR EACH ROW
  INSERT INTO Ban_Users ( username, ban_times, started_at, finished_at )
    VALUES(NEW.username, 0, NULL, NULL)
//
DELIMITER ;
GO