#!/bin/sh
#
# Executes the build processes of cmangos-classic, based on the
# build & source directories provided by the environment variables.
#
# All source files are prebaked within the container image.
#

cd "$SOURCE_DIR/sql/"

dir_database="/opt/mangos/db"
dir_sql="$dir_database/sql"
dir_migrations="$dir_sql/migrations"

mkdir -p "$dir_migrations" "$dir_sql/playerbots"
cp /source/classic-db/*.sql "$dir_sql"
cp create/db_create_mysql.sql "$dir_sql"
cp -R $SOURCE_DIR/sql/base "$dir_sql/base"

cp "$SOURCE_DIR/src/modules/PlayerBots/sql/other/database_merge_classic.sql" "$dir_sql/playerbots/database_merge_classic.sql"
cp "$SOURCE_DIR/src/modules/PlayerBots/sql/characters"/*.sql "$dir_sql/playerbots"
cp "$SOURCE_DIR/src/modules/PlayerBots/sql/world"/*.sql "$dir_sql/playerbots"
cp "$SOURCE_DIR/src/modules/PlayerBots/sql/world/classic"/*.sql "$dir_sql/playerbots"

cp -r /docker-entrypoint-initdb.d "$dir_database/"
chmod +x "/docker-entrypoint-initdb.d"/*.sh
