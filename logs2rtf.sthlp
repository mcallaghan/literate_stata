{smcl}
{* *! version 1.0.0  29jan2016}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "examplehelpfile##syntax"}{...}
{viewerjumpto "Description" "examplehelpfile##description"}{...}
{viewerjumpto "Options" "examplehelpfile##options"}{...}
{viewerjumpto "Remarks" "examplehelpfile##remarks"}{...}
{viewerjumpto "Examples" "examplehelpfile##examples"}{...}
{title:Title}

{phang}
{bf:logs2rtf} {hline 2} Convert logs to rtf files


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:logs2:rtf}
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt src}}Specify the location of log files (if other than the 
current working directory){p_end}
{synopt:{opt dest}}Specify a location to save rtf files (if other than the 
current working directory){p_end}
{syntab:Formatting}
{synopt:{opt red(#)}}Specify the 0-255 rgb value for red (default 0){p_end}
{synopt:{opt green(#)}}Specify the 0-255 rgb value for green (default 0){p_end}
{synopt:{opt blue(#)}}Specify the 0-255 rgb value for blue (default 0){p_end}
{synopt:{opt fs(#)}}Specify the fontsize (default 8){p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:logs2rtf} cleans all log files (stripping the content between the delimiters *@s and *@e)
 in a specified location and saves formatted rtf files that can be 
 included in word as linked text for dynamic display of Stata output.

{marker remarks}{...}
{title:Remarks}

{pstd}
For more detailed information, you can 
{browse "https://github.com/mcallaghan/literate_stata":view on Github}


{marker examples}{...}
{title:Examples}

{phang}{cmd:. logs2rtf}{p_end}

{phang}{cmd:. logs2rtf, src(logs) dest(word) blue(255) fs(10)}{p_end}
