#!/usr/bin/perl -w


open(PSQL, "| psql -h localhost -p 5432 -U postgres -d biological ") or die "fork impossible: $!\n";

#open(PSQL, "| psql -h localhost -p 5432 -U postgres -d faostat ") or die "fork impossible: $!\n";

