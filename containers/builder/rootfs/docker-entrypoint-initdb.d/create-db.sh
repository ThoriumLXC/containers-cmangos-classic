#!/bin/bash

echo "[mariadb]: Creating databases"
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" < /sql/db_create_mysql.sql

echo "[mariadb]: Import databases"
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" classiccharacters < /sql/classiccharacters.sql
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" classicmangos < /sql/classicmangos.sql
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" classicrealmd < /sql/classicrealmd.sql
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" classiclogs < /sql/classiclogs.sql

echo "[mariadb]: Granting permissions"
SQL_COMMAND=$(cat <<EOF
GRANT ALL ON classicmangos.* TO '$MARIADB_USER'@'%';
GRANT ALL ON classiccharacters.* TO '$MARIADB_USER'@'%';
GRANT ALL ON classicrealmd.* TO '$MARIADB_USER'@'%';
GRANT ALL ON classiclogs.* TO '$MARIADB_USER'@'%';
FLUSH PRIVILEGES;
EOF
)
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" -e "$SQL_COMMAND"

echo "[mariadb]: Configuring default realm"
REALMLIST_NAME=${REALMLIST_NAME:-CMaNGOS}
REALMLIST_PORT=${REALMLIST_PORT:-8085}
REALMLIST_ICON=${REALMLIST_ICON:-1}
REALMLIST_TIMEZONE=${REALMLIST_TIMEZONE:-0}
REALMLIST_ALLOWED_SECURITY_LEVEL=${REALMLIST_ALLOWED_SECURITY_LEVEL:-0}

SQL_COMMAND=$(cat <<EOF
INSERT INTO classicrealmd.realmlist (name, address, port, icon, timezone, allowedSecurityLevel)
VALUES ('$REALMLIST_NAME', '$REALMLIST_ADDRESS', '$REALMLIST_PORT', '$REALMLIST_ICON', '$REALMLIST_TIMEZONE', '$REALMLIST_ALLOWED_SECURITY_LEVEL');
EOF
)
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" -e "$SQL_COMMAND"

echo "[mariadb]: Executing custom scripts"
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" classicrealmd < /sql/user_accounts.sql

echo "[mariadb]: $0 completed"
