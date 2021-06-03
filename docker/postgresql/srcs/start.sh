gosu postgres postgres --single <<EOSQL
  CREATE DATABASE server_development;
  CREATE DATABASE server_test;
  CREATE DATABASE server_production;
EOSQL
