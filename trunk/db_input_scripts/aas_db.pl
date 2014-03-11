#!/usr/bin/perl -w

# On grouper: 
## open(PSQL, "| psql -h 172.16.0.6 -p 5432 -U postgres -d aas_base ") or die "fork impossible: $!\n";

open(PSQL, "| psql -h 50.18.115.108 -p 5432 -U postgres -d aas_base ") or die "fork impossible: $!\n";
