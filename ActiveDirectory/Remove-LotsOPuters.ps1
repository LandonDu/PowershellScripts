<#
.synopsis
Script pulls a list of computer names from a specified file path and deletes them from AD. The first line on the list of computer names will need to be 'ADComputer'

.description
A user will need to create a .csv file with a list of computer names with the header being 'ADComputer'. The script imports this list of computer names (file path defaults to C:\radius180\computers.csv) and deletes them from AD.

.example
.\remove-lotsoputers
or
.\remove-lotsoputers -filepath C:\test\computers.csv

.parameter FilePath
This parameter is used to specify the file path of the list of computers. 
#>


param (
    $FilePath = 'C:\radius180\computers.csv'
)

import-csv -path $FilePath | ForEach-Object {remove-adcomputer -identity $_.ADComputer -confirm:$false}