#!/usr/bin/perl -w

#use strict;
# AUTHOR: doug.beare@gmail.com
#####################################################
#THIS PROGRAM IS BEST RUN BY POSTGRES SUPERUSER######
#####################################################

# PURPOSE: CREATE THE ICOADS-GRIDDED DATA

require "aas_db.pl";

# CREATE THE DATA TABLE IN POSTGRESQL

print PSQL ("SET SEARCH_PATH TO global; \n");

print PSQL ("DROP TABLE global.clim_icoads_gridded CASCADE; \n");
#
##print PSQL ("CREATE TABLESPACE dbspace LOCATION \'G://pGdata\'; \n");
#
#print PSQL ("SET default_tablespace = dbspace; \n");
#
print PSQL ("CREATE TABLE global.clim_icoads_gridded (
year int,
month int,
bsz int,
blo float,
bla float,
pid2 float,
s1 float,
s3 float,
s5 float,
M float,
N float,
S float,
D float,
HT float,
lon float,
lat float,
type varchar(12)) WITH OIDS;\n");


print PSQL ("COMMENT ON TABLE  global.clim_icoads_gridded IS 'These are global gridded data from ICOADs';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_gridded.year IS 'Year';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_gridded.month IS 'Month';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_gridded.bsz IS 'Box size: 1 = 1degree latitude x longitude 2 = 2degree latitude x longitude';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_gridded.blo IS 'box left (W) corner longitude (E)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_gridded.bla IS 'box lower (S) corner latitude (+N, -S)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_gridded.pid2 IS 'PID2: 0 = standard statistics (3.5 sigma trimming limits; ship data) 1 = enhanced statistics (4.5 sigma trimming limits; ship + other data)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_gridded.M IS 'mean';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_gridded.N IS 'number of observations';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_gridded.S IS 'standard deviation';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_gridded.D IS 'mean day of month of the observations';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_gridded.HT IS 'fraction of observations in daylight';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_gridded.lon IS 'mean longitude of observations';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_gridded.lat IS 'mean latitude of observations';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_gridded.type IS 'type of data, e.g. SST=sea surface temperature';\n");


## FILL THE TABLE
## SST data

open(DATAFILE, "ls /srv/public/input_data_files/ICOADS-Global-Gridded/sst/tmp/*database |");
while(<DATAFILE>){
s/^\s*(.*)\s*$/$1/;
chomp;
open(FILE,"<$_") or die "Cannot open file $_: $!\n";
print PSQL ("\\COPY global.clim_icoads_gridded FROM \'$_\' WITH delimiter \',\' null as \'-9999.00\'\n");
print "IMPORTING: $_\n";}
close(DATAFILE);

### AIRT
open(DATAFILE, "ls /srv/public/input_data_files/ICOADS-Global-Gridded/airtemp/tmp/*database |");
while(<DATAFILE>){
s/^\s*(.*)\s*$/$1/;
chomp;
open(FILE,"<$_") or die "Cannot open file $_: $!\n";
print PSQL ("\\COPY global.clim_icoads_gridded FROM \'$_\' WITH delimiter \',\' null as \'-9999.00\'\n");
print "IMPORTING: $_\n";}
close(DATAFILE);

### WINDSTRESS
open(DATAFILE, "ls /srv/public/input_data_files/ICOADS-Global-Gridded/windstress/tmp/*database |");
while(<DATAFILE>){
s/^\s*(.*)\s*$/$1/;
chomp;
open(FILE,"<$_") or die "Cannot open file $_: $!\n";
print PSQL ("\\COPY global.clim_icoads_gridded FROM \'$_\' WITH delimiter \',\' null as \'-9999.00\'\n");
print "IMPORTING: $_\n";}
close(DATAFILE);


print PSQL ("ALTER TABLE global.clim_icoads_gridded ADD PRIMARY KEY (year,month,blo,bla);\n")

print PSQL ("UPDATE global.clim_icoads_gridded SET lon = blo+lon;\n")
print PSQL ("UPDATE global.clim_icoads_gridded SET lon = lon-360 WHERE lon > 180 AND type= 'SST';
UPDATE global.clim_icoads_gridded SET lon = lon-360 WHERE lon > 180 AND type= 'AIRT';


\n")



print PSQL ("UPDATE global.clim_icoads_gridded SET lat = bla+lat;\n")


### Create indices ###

print PSQL ("CREATE INDEX icoads_gridded_month ON global.clim_icoads_gridded (month);\n");
print PSQL ("CREATE INDEX icoads_gridded_year ON global.clim_icoads_gridded (year);\n");
print PSQL ("CREATE INDEX icoads_gridded_lat ON global.clim_icoads_gridded (lat);\n");
print PSQL ("CREATE INDEX icoads_gridded_lon ON global.clim_icoads_gridded (lon);\n");

#### Add on geometry point ###

print PSQL ("SET SEARCH_PATH to public;\n");
print PSQL ("SELECT addgeometrycolumn('','global','clim_icoads_gridded','the_point',4326,'POINT',2);\n");
print PSQL ("UPDATE global.clim_icoads_gridded SET the_point = GeomFromEWKT('SRID=4326;POINT(' || clim_icoads_gridded.lon || ' ' || clim_icoads_gridded.lat || ')');\n");
print PSQL ("CREATE INDEX clim_icoads_gridded_the_point ON global.clim_icoads_gridded USING GIST (the_point);\n");



close(PSQL);









#===============================================================================
#International Comprehensive Ocean-Atmosphere Data Set (ICOADS):     Release 2.4
#Monthly Summary Groups (MSG1)                                 22 September 2007
#==========================================================================<msg>
#
#Document Revision Information (previous version: 27 February 2004):  Updates
#(heading only) for Release 2.4.
#
#-------------------------------------------------------------------------------
#
#
#{1. Introduction}
#
#This document provides a technical description of the Monthly Summary Groups
#(MSG) format.  This format is designed to store both 1-degree, and 2-degree,
#latitude x longitude monthly summaries (the format also has the capability,
#unused at present, to store 0.5-degree data).
#
#MSG products are currently available covering the global domain (1-degree
#and/or 2-degree boxes) and an equatorial domain (1-degree), with 1-degree
#products available only for 1960 forward.  The boundaries of the global
#2-degree boxes fall on even degrees of latitude and longitude (e.g., 0-2E,
#88-90N).  The 2-degree box system is the same as LLN2F1 as described in
#Release 1, supp. G, except omitting the polar boxes (16,200 boxes total).
#The boundaries of the global 1-degree boxes fall on units of latitude
#and longitude (e.g., 0-1E, 89-90N) (64,800 boxes total).  The equatorial
#domain comprises the latitude band 10.5N to 10.5S, and is global with
#respect to longitude.  The equatorial 1-degree boxes are shifted half a
#degree in latitude (only) in comparison to the global domain, such that
#the center-latitude of the central row of boxes is the equator (e.g., 0-1E,
#0.5S-0.5N).  See <stat_doc> for additional information about the details
#of products and time periods of data currently available in the MSG format.
#
#Six "groups" of variables make up MSG (Table 1a).  The variables comprise the
#19 variables that were produced for COADS Release 1 (groups 3-7) plus three
#additional variables that make up group 9: the cube of the wind speed, W**3, as
#well as the zonal and meridional contributions to the latent heat flux, U(QS-Q)
#and V(QS-Q).  The ten statistics calculated for each variable are listed in
#Table 1b.  Header fields, as defined below Table 1b, precede the statistics in
#the MSG format.
#
#The Fortran read program for the MSG format should provide ready access to the
#header fields and statistics included in each group (using the abbreviations
#given in Tables 1a and 1b, and for the header fields as follow Table 1b).  As
#background, however, a technical description of the format layout (bit lengths)
#is given in sec. 2, and detailed information about the reconstruction of
#floating point data is given in sec. 3.
#
#Each MSG record contains the data for a single year, month and (2- or 1-degree)
#box.  The MSG records are labeled with the year, month, and box-size, and
#the latitude/longitude coordinates of the lower-left corner of the box.  The
#weighted mean position of all observations within a box can be obtained from
#the corner coordinates plus the longitude and latitude offset statistics, x
#and y, for each variable.
#
#MSG records were output only for year-months and boxes containing at least one
#observation of at least one variable.  Records are supressed for boxes (and a
#few entire year-months) without any extant data.  This provides an inherent
#form of data compression for sparsely populated spatial grids.  The records
#are sorted by year, month, and either 2- or 1-degree box.  The 2- and 1-degree
#box systems proceed east from the prime meridian (i.e., starting with the
#box with its SW corner longitude at 0E) and spiral down through each zone of
#latitude.
#
#
#Table 1a.  Variables in MSG.  Each group contains four variables and ten
#selected statistics (Table 1b) for each variable.  Derived variables in groups
#5-8 are computed as indicated from individual observations of other variables,
#e.g., the wind-stress parameter "X" is the product of W and U.  In addition,
#QS denotes saturation Q at SST.
#-------------------------------------------------------------------------------
#                                      Group
#3                  4               5                6          7     9
#===============================================================================
#Sea sfc. temp. (S) Scalar wind (W) Total cloud. (C) D=S - A    I=UA  M=FU
#Air temp. (A)      Wind U-comp.(U) R                E=(S - A)W J=VA  N=FV
#Specific hum. (Q)  Wind V-comp.(V) X=WU             F=QS - Q   K=UQ  B1=(W**3)*
#Relative hum. (R)  SLP (P)         Y=WV             G=FW       L=VQ  B2=(W**3)*
#-------------------------------------------------------------------------------
#* B1 and B2 are high- and low-resolution representations of B = W**3 (i.e.,
#data increments of 0.5 or 5 m**3/s**3; see Table 4b).
#----------
#
#Table 1b.  Statistics in MSG.  Each statistic is assigned a number and a
#lower-case abbreviation (from Release 1, supp. A, Table A1-2).
#-------------------------------------------------------------------------------
#No.  Abbrev. Variable
#===============================================================================
# 9    s1     1/6 sextile (a robust estimate of the mean minus 1 standard dev.)
#11    s3     3/6 sextile (the median)
#13    s5     5/6 sextile (a robust estimate of the mean plus 1 standard dev.)
# 6    m      mean
# 5    n      number of observations
# 7    s      standard deviation
# 1    d      mean day-of-month of observations
# 2    ht     fraction of observations in daylight
# 3    x      mean longitude of observations
# 4    y      mean latitude of observations
#-------------------------------------------------------------------------------
#
#Following is a definition of the MSG header fields preceding the statistics
#in the MSG format:
#
#   RPTIN
#   RPTID
#The RPTIN field is reserved for use of the RPTIN unblocking utility, where
#available (e.g., NCAR), and RPTID indicates the MSG format version number (1).
#
#   YEAR
#The year can range from 1800 to 2054.
#
#   MONTH
#     1=January, 2=February, ..., 12=December.
#
#   BSZ  box size
#     0 = 0.5 degree latitude x longitude (not currently used)
#     1 = 1   degree latitude x longitude
#     2 = 2   degree latitude x longitude
#
#   BLO  box left (W) corner longitude (E)
#   BLA  box lower (S) corner latitude (+N, -S)
#Coordinates (half-degree precision) of the lower-left (SW) corner of the box
#(BSZ gives the box size).  For a given variable, the mean sample position
#of the observations within a box can be obtained from:
#     mean longitude = BLO + x
#     mean latitude  = BLA + y
#Note that longitude is always measured in east coordinates.  Because the x
#values can range up to two degrees (one degree) for 2-degree (1-degree) boxes,
#the resultant range of mean longitude is 0-360E.
#
#   PID1  product identification part 1
#   PID2  product identification part 2
#Presently, PID1 is unused.  PID2:
#     0 = standard statistics (3.5 sigma trimming limits; ship data)
#     1 = enhanced statistics (4.5 sigma trimming limits; ship + other data)
#
#   GRP  group
#Group number (3-7 or 9).
#
#   CK  checksum
#A checksum was computed and stored with each packed summary as a measure of
#reliability during storage and transmission.  The Fortran read program will
#recalculate the checksum and compare it to the stored checksum.  If
#disagreement is found data processing will stop and an error statement will
#be issued.  This problem indicates that the data file is corrupted or the
#access software is not correctly implemented.
#
#
#{2. Details of Monthly Summary Groups (MSG)}
#
#Table 2 shows the bit layout in common to any MSG (regardless of group number);
#Tables 3a through 3f show the bit layout of each of the 64-bit or 16-bit
#sections of groups 3-7 and 9 (note that Tables B1-1b through B1-1f in Release
#1, supp. B give identical bit layouts for groups 3-7 in the MSTG1 format).
#Each variable is assigned a number and an upper-case abbreviation (from Release
#1, supp. A, Table A1-1).
#
#Example of bit layout:  If we denote the lower-case abbreviation for each
#statistic by "a" and the upper-case abbreviation for each variable by "B",
#group 3 contains, in order, RPTIN, RPTID, ..., CK followed by:
#   ((aB, B = S,A,Q,R), a = s1,s3,s5,m,n,s,d,ht,x,y)
#I.e., s1 of S, s1 of A,..., s1 of R; s3 of S, s3 of A,..., s3 of R; ... ;
#y of S, y of A,..., y of R.
#
#The MSG format was developed as an extension and enhancement to the MSTG
#format; following is a summary of changes in comparison to MSTG2:
#     a) Header information (first 64 bits): The 2- and 10-degree box numbers
#        are omitted.  Instead, the box size and coordinates are specified
#        (thus accommodating different box systems within the MSG format).
#        Data falling precisely at the North (or theoretically at the South)
#        Pole are handled differently in MSG: there are no 2-deg (or 1-deg)
#        boxes dedicated to +90 or -90 latitude, as in the 2-degree box system
#        used for MSTG.  Instead, data are assigned to boxes adjoining the
#        poles based on reported longitude and other box inclusivity rules
#        (see Release 1, supp. G).  Header fields also were added for product
#        identification (i.e., standard versus enhanced statistics).
#
#     b) The 1st and 5th sextiles were added, and the estimated standard
#        deviation was replaced by the actual standard deviation; the estimate
#        can however still be computed, i.e., (s5 - s1)/2.
#
#     c) The units and ranges (of true values) of the mean longitude and
#        latitude of the observations (x and y) depend on the box size, as
#        detailed in sec. 3.
#
#
#Table 2.  The Monthly Summary Group (MSG1) format.  Fields added (with respect
#to MSTG2) are marked by a double asterisk (**), and when the number of bits for
#a field has changed (*), the old MSTG2 value is shown in parentheses.
#-------------------------------------------------------------------------------
#No.        Abbrev.        Description                        Bits
#===============================================================================
#               Header fields:
#           RPTIN          (reserved)                           12
#           RPTID          (reserved)                            4
#           YEAR                                                 8
#           MONTH                                                4
#           BSZ            box size                              3**
#           BLO            box left (W) corner longitude         10**
#           BLA            box lower (S) corner latitude         9**
#           PID1           product identification part 1         3**
#           PID2           product identification part 2         3**
#           GRP            group                                 4
#           CK             checksum                              4*(8)
#
#               Statistics:
#9          s1             1/6 sextile (est minus 1 sigma)      64**
#11         s3             3/6 sextile (the median)             64
#13         s5             5/6 sextile (est plus 1 sigma)       64**
#6          m              mean                                 64
#5          n              number of observations               64
#7          s              standard deviation                   64**
#1          d              mean day-of-month of observations    16
#2          ht             fraction of observations in daylight 16
#3          x              mean longitude of observations       16
#4          y              mean latitude of observations        16
#
#                          total                               512*(384) = 64B
#-------------------------------------------------------------------------------
#
#Table 3a.  Group 3, 64-bit or 16-bit sections.
#-------------------------------------------------------------------------------
#No. Abbr. Variable                                                   Bits  Bits
#===============================================================================
#1    S    sea surface temperature                                      16     4
#2    A    air temperature                                              16     4
#8    Q    specific humidity                                            16     4
#9    R    relative humidity                                            16     4
#
#          total                                                        64    16
#-------------------------------------------------------------------------------
#
#Table 3b.  Group 4, 64-bit or 16-bit sections.
#-------------------------------------------------------------------------------
#No. Abbr. Variable                                                   Bits  Bits
#===============================================================================
#3    W    scalar wind                                                  16     4
#4    U    vector wind eastward component                               16     4
#5    V    vector wind northward component                              16     4
#6    P    sea level pressure                                           16     4
#
#          total                                                        64    16
#-------------------------------------------------------------------------------
#
#Table 3c.  Group 5, 64-bit or 16-bit sections.
#-------------------------------------------------------------------------------
#No. Abbr. Variable                                                   Bits  Bits
#===============================================================================
#7    C    total cloudiness                                             16     4
#9    R    relative humidity                                            16     4
#14   X    WU                                                           16     4
#15   Y    WV (14-15 are wind stress parameters)                        16     4
#
#          total                                                        64    16
#-------------------------------------------------------------------------------
#
#Table 3d.  Group 6, 64-bit or 16-bit sections.
#-------------------------------------------------------------------------------
#No. Abbr. Variable                                                   Bits  Bits
#===============================================================================
#10   D    S - A = sea-air temperature difference                       16     4
#11   E    (S - A)W = sea-air temperature difference*wind magnitude     16     4
#12   F    QS - Q = (saturation Q at S) - Q                             16     4
#13   G    FW = (QS - Q)W (evaporation parameter)                       16     4
#
#          total                                                        64    16
#-------------------------------------------------------------------------------
#
#Table 3e.  Group 7, 64-bit or 16-bit sections.
#-------------------------------------------------------------------------------
#No. Abbr. Variable                                                   Bits  Bits
#===============================================================================
#16   I    UA                                                           16     4
#17   J    VA                                                           16     4
#18   K    UQ                                                           16     4
#19   L    VQ (16-19 are sensible and latent heat transport parameters) 16     4
#
#          total                                                        64    16
#-------------------------------------------------------------------------------
#
#Table 3f.  Group 9, 64-bit or 16-bit sections.
#-------------------------------------------------------------------------------
#No. Abbr. Variable                                                   Bits  Bits
#===============================================================================
#20   M    FU                                                           16     4
#21   N    FV                                                           16     4
#22   B1   B = W**3 (high-resolution representation)                    16     4
#23   B2   B = W**3 (low-resolution representation)                     16     4
#
#          total                                                        64    16
#-------------------------------------------------------------------------------
#
#
#{3. Reconstruction of floating point data}
#
#The Fortran access program provides the logic necessary to transfer binary data
#into memory and then extract into INTEGER variables the bit strings whose
#lengths are given in sec. 2.  Refer to Release 1, supp. H for more information
#about the techniques used.
#
#Compression was achieved by packing data represented as positive integers
#into fields whose lengths are specified in the bits column of Tables 2 and
#3a through 3f.  To accomplish this, a field's floating point true value
#was divided by its units (the smallest increment of the data that has been
#encoded).  Then the base was subtracted to produce, after rounding, a coded
#positive integer, which was finally right-justified with zero fill in the
#field's position within the summary.  Using the true value mean of sea surface
#temperature value 28.61 degrees C as an example, (28.61/0.01) - (-501) = 3362.
#
#Once a given field has been extracted into the coded value, the true value can
#be reconstructed by reversing the process:
#      true value = (coded + base) * units
#
#The above true value example is reconstructed by (3362 + (-501)) * 0.01) =
#28.61 degrees C.  NOTE: in each coded value, zero is reserved as an indicator
#of missing data.
#
#The coded and true value ranges, the units, and the base associated with each
#header field and statistic will be found in Table 4a.  In the case of the first
#and fifth sextiles, median, mean, and standard deviation, these quantities are
#different for each variable, hence cross-reference to Table 4b.  Similarly for
#the mean longitude and latitude of the observations, where the units depend on
#box size, hence cross-reference to Table 4c.
#
#
#Table 4a.  Unpacking header fields and statistics.  Notation is as follows:
#m:n denotes m through n inclusive; @ is used as a plain text abbreviation for
#the degree symbol.  "Units" gives the smallest increment of the data that has
#been encoded; thus a change of one unit in the integer coded value represents
#a change in the true value of one of the units shown (units of 1 are explained
#in the text).
#-------------------------------------------------------------------------------
#  Abbr. Description                           True value   Units   Base  Coded
#===============================================================================
#                 Header fields
#  --------------------------------------------
#  RPTIN (reserved)                             n/a          n/a      n/a    n/a
#  RPTID (reserved)                             n/a          n/a      n/a    n/a
#  YEAR                                         1800:2054    1       1799  1:255
#  MONTH                                        1:12         1          0   same
#  BSZ   box size                               0:2          1         -1    1:3
#  BLO   box left (W) corner longitude (E)      0:359.5      0.5@      -1  1:720
#  BLA   box lower (S) corner latitude (+N, -S) -90.0:90.0   0.5@    -181  1:361
#  PID1  product identification part 1                 (presently unused)
#  PID2  product identification part 2          0:1          1         -1    1:2
#  GRP   group                                  3:9          1          0   same
#  CK    checksum                               n/a          n/a      n/a    n/a
#
#                 Statistics
#  --------------------------------------------
#  s1    1/6 sextile (est minus 1 sigma)           (all as given in Table 4b)
#  s3    3/6 sextile (the median)                  (all as given in Table 4b)
#  s5    5/6 sextile (est plus 1 sigma)            (all as given in Table 4b)
#  m     mean                                      (all as given in Table 4b)
#  n     number of observations                 1:65535      1          0   same
#  s (e) standard deviation (or estimate; MSTG) 0:#          Table 4b  -1   1:#
#  d     mean day-of-month of observations*     2:30         2 days   0.0   1:15
#  ht    fraction of observations in daylight   0.0:1.0      0.1       -1   1:11
#  x     mean longitude of observations         Table 4c     Table 4c  -1   1:11
#  y     mean latitude of observations          Table 4c     Table 4c  -1   1:11
#-------------------------------------------------------------------------------
#* A coded value of 16, which would otherwise result when the calculated mean
#day-of-month is 31 (e.g., 31/2 = 15.5, rounded = 16), is avoided by changing
#16 into a coded value of 15 prior to storage.  This means that the coded value
#15 represents a slightly larger numeric interval than the other values.
## Standard deviations have a true value ranging upwards from zero for all
#variables, thus the base is always -1.  Units for each variable are still
#chosen from Table 4b.  [NOTE: The MSTG format contains the standard deviation
#estimate instead of the standard deviation about the mean (s); this robust
#estimate is computed from the fifth and first sextiles: e = (s5 - s1)/2.
#For unpacking purposes, e is treated exactly like the corresponding standard
#deviation of each respective variable.]
#----------
#
#Table 4b.  Unpacking variables (notation as for Table 4a).  Variables 20-23
#are unique to the MSG format; otherwise the information presented here follows
#Release 1, supp. A, Table A2-4b.
#-------------------------------------------------------------------------------
#No. Abbrev.  Variable              True value*     Units         Base    Coded
#===============================================================================
#            "Observed"
#    ------------------------------
# 1  S  sea surface temperature     -5.00:40.00     0.01 @C       -501   1:4501
# 2  A  air temperature             -88.00:58.00    0.01 @C       -8801  1:14601
# 3  W  scalar wind                 0.00:102.20     0.01 m/s      -1     1:10221
# 4  U  vector wind eastward comp.  -102.20:102.20  0.01 m/s      -10221 1:20441
# 5  V  vector wind northward comp. -102.20:102.20  0.01 m/s      -10221 1:20441
# 6  P  sea level pressure          870.00:1074.60  0.01 hPa      86999  1:20461
# 7  C  total cloudiness            0.0:8.0         0.1 okta      -1     1:81
# 8  Q  specific humidity           0.00:40.00      0.01 g/kg     -1     1:4001
#
#            Derived
#    ------------------------------
# 9  R  relative humidity           0.0:100.0       0.1 %         -1     1:1001
#10  D  S - A                       -63.00:128.00   0.01 @C       -6301  1:19101
#11  E  (S - A)W                    -1000.0:1000.0  0.1 @C m/s     -10001 1:20001
#12  F  (saturation Q at S) - Q     -40.00:40.00    0.01 g/kg     -4001  1:8001
#13  G  FW                          -1000.0:1000.0  0.1 g/kg m/s  -10001 1:20001
#14  X  WU                          -3000.0:3000.0  0.1 m**2/s**2 -30001 1:60001
#15  Y  WV                          -3000.0:3000.0  0.1 m**2/s**2 -30001 1:60001
#16  I  UA                          -2000.0:2000.0  0.1 @C m/s    -20001 1:40001
#17  J  VA                          -2000.0:2000.0  0.1 @C m/s    -20001 1:40001
#18  K  UQ                          -1000.0:1000.0  0.1 g/kg m/s  -10001 1:20001
#19  L  VQ                          -1000.0:1000.0  0.1 g/kg m/s  -10001 1:20001
#20  M  FU                          -1000.0:1000.0  0.1 g/kg m/s  -10001 1:20001
#21  N  FV                          -1000.0:1000.0  0.1 g/kg m/s  -10001 1:20001
#22  B1 B = W**3 (high-resolution)  0.0:32767.0     0.5 m**3/s**3 -1     1:65535
#23  B2 B = W**3 (low-resolution)   0:327670        5   m**3/s**3 -1     1:65535
#-------------------------------------------------------------------------------
#* Each individual observation is checked against the given range of true values
#(with B1 as an exception, as discussed below), and only individual observations
#within range are included in the statistics.  The total cloudiness code N=9 for
#"sky obscured or cloud amount cannot be estimated" is thereby always rejected.
#Generally other variables should fall within the true value ranges due to the
#application of trimming (e.g., Release 1, Table C2-3) and other preprocessing.
#B1 is handled differently, in that each observation of W**3 is checked only
#against the true value column for B2 (not B1).  Once final statistics for W**3
#have been calculated, the attempt is made to store each W**3 statistic in both
#B1 and B2.  Should a given statistic exceed the highest value allowed for B1,
#it is stored only in B2.  Note that in this case one statistic (e.g., m) may
#be stored in both B1 and B2, but another (e.g., s5) only in B2.
#----------
#
#Table 4c.  Unpacking mean longitude and latitude (x and y) of the observations,
#depending on box size (BSZ) (notation as for Table 4a).  After unpacking, it
#should be noted that the resultant true values corresponding to the lower- and
#upper-most coded values are not centered in the numerical intervals that they
#represent.  The lower portion of the table provides information about this
#issue, also listing "best" adjusted values.
#-------------------------------------------------------------------------------
#  Abbr. Description                            True value   Units   Base  Coded
#===============================================================================
#             BSZ = 2 = 2   degree latitude x longitude:
#  x     mean longitude of observations         0.0:2.0      0.2@      -1   1:11
#  y     mean latitude of observations          0.0:2.0      0.2@      -1   1:11
#             BSZ = 1 = 1   degree latitude x longitude:
#  x     mean longitude of observations         0.0:1.0      0.1@      -1   1:11
#  y     mean latitude of observations          0.0:1.0      0.1@      -1   1:11
#             BSZ = 0 = 0.5 degree latitude x longitude (not currently used):
#  x     mean longitude of observations         0.0:0.5      0.05@     -1   1:11
#  y     mean latitude of observations          0.0:0.5      0.05@     -1   1:11
#
#Resultant (and best numeric fit) mappings of coded values into true values:
#        Coded     2-degree              1-degree              0.5-degree
#        -----    ------------          ------------          ------------
#          1      0.0   (0.05)          0.0   (0.02)          0.0   (0.01)
#          2      0.2                   0.1                   0.05
#          3      0.4                   0.2                   0.1
#          4      0.6                   0.3                   0.15
#          5      0.8                   0.4                   0.2
#          6      1.                    0.5                   0.25
#          7      1.2                   0.6                   0.3
#          8      1.4                   0.7                   0.35
#          9      1.6                   0.8                   0.4
#         10      1.8                   0.9                   0.45
#         11      2.0   (1.95)          1.0   (0.98)          0.5   (0.49)
#
