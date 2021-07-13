CREATE USER 'pynative'@'localhost' IDENTIFIED BY 'pynative@#29';
GRANT ALL PRIVILEGES ON * . * TO 'pynative'@'localhost';
FLUSH PRIVILEGES;




SELECT *
FROM login_request_log
ORDER BY created_at DESC
LIMIT 5
