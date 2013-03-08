#!/usr/bin/perl -w


open(PSQL, "| psql -h 172.16.0.6 -p 5432 -U postgres -d aas_base ") or die "fork impossible: $!\n";

