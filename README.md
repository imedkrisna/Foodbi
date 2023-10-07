# About
 This is a repo to produce various graphs and regression results for the following working paper:

        - Competitiveness in Indonesian Food Industry with Dionisius Narjoko and M. Ridhwan

Machine used is Stata 17.0 with prodest package. Some files in this repo isn't needed, some are obsolete. Graph is stored in the folder "graph" while regression results is in the "reg" folder. All data that i use is stored in "new_data/use". Note that the final paper may contain graph that is not produced by me.

Pay attention to the data used in the do files. I ignore all data which is stored locally in my machine (e.g., *.xlsx and *.dta), mainly due to practicality reason and  data confidentiality.

## Old version

- KBLI is used to fix some old version of data which has funny variable names and ISIC.
- prodest is the earliest. IDK what im doing
- prodestv1 a bit better but using output
- prodestv2 use value added and removes outlier (top & bot 5%). Need to clean more since some lines will be obsolete.

## Current version

- Prodestv3 use regression for each ISIC4 and mamin_new as data year>2017 from scratch. Also tabstat for important 4-digit ISIC
- regression is the do file for the regression
- StataGraph is for making graphs.

## Work in progress

- Generate industry-level markups
- More regression!
