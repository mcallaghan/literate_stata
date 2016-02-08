clear all
set more off

cd "C:\Users\m.callaghan\Documents\GitHub\literate_stata\example"


log using ex_1, text replace
*@s
di 5+5
sysuse auto
sum
*@e
cap log close

log using ex_2, text replace
*@s
reg price weight
*@e
cap log close

*logs2rtf
