#!/bin/sh
export DATABASE_URL="mysql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}/${DB_NAME}"

wait_for_db() {
  counter=0
  echo >&2 "Connecting to database at $DB_HOST"
  while ! mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e "USE mysql;" >/dev/null; do
    counter=$((counter+1))
    if [ $counter == 30 ]; then
      echo >&2 "Error: Couldn't connect to database."
      exit 1
    fi
    echo >&2 "Trying to connect to database at $DB_HOST. Attempt $counter..."
    sleep 5
  done
}

setup_db() {
  echo >&2 "Creating the database if it does not exist..."
  mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD --skip-column-names -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
}

wait_for_db
setup_db

if [ -r /etc/vaultwarden.sh ]; then
    . /etc/vaultwarden.sh
elif [ -r /etc/bitwarden_rs.sh ]; then
    echo "### You are using the old /etc/bitwarden_rs.sh script, please migrate to /etc/vaultwarden.sh ###"
    . /etc/bitwarden_rs.sh
fi

if [ -d /etc/vaultwarden.d ]; then
    for f in /etc/vaultwarden.d/*.sh; do
        if [ -r $f ]; then
            . $f
        fi
    done
elif [ -d /etc/bitwarden_rs.d ]; then
    echo "### You are using the old /etc/bitwarden_rs.d script directory, please migrate to /etc/vaultwarden.d ###"
    for f in /etc/bitwarden_rs.d/*.sh; do
        if [ -r $f ]; then
            . $f
        fi
    done
fi

exec /vaultwarden "${@}"
