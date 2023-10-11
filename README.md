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

Run with this sequence:

1. Parameters which basically just preparing the data
1. Prodestv3 use regression for each ISIC4 and mamin_new as data year>2017 from scratch, generate industry level markups & TFP
1. regressionv2 is the do file for the regression, now with industry level regression, bi rate vs lending rate both current and lag 1. see "reg" folder.
1. StataGraphv2 is for making graphs, adds markups in 3 industries. see "graph" folder.

## Notes

- I highly encourage you to see the two *.smcl files, especially for tfpreg if you want to have a look at regression parameters.
- In the "graph" folder, you can see a series **markups** graph of 3 industries: vegetable oil, rice mill and sugar refinery. **muinew** covers 2017-2021 while **muiold** covers 2000-2015. The latter is tad more intersting as we see growing markups during the commodity boom of 2005-2011.

## Notes on regression

Regression is a panel data regression with fixed effect, where i=4 digit ISIC while t=year. In general, regression of the 2000-2015 looks better than 2017-2021 (the markups also look better in the older data). Here's file in the "reg" and what those means:

| Filename | What's that |
| --- | --------- |
| regacr4 | MU vs CR4, 2000-2015 |
| regawpi | WPI vs MU with lending rate at t, 2000-2015 |
| regawpil | WPI vs MU with lending rate at t-1, 2000-2015 |
| regawpibi | WPI vs MU with bi rate at t, 2000-2015 |
| regawpibil | WPI vs MU with bi rate at t-1, 2000-2015 |
| regbcr4 | MU vs CR4, 2017-2021 |
| regbwpi | WPI vs MU with lending rate at t, 2017-2021 |
| regbwpil | WPI vs MU with lending rate at t-1, 2017-2021 |
| regbwpibi | WPI vs MU with bi rate at t, 2017-2021 |
| regbwpibil | WPI vs MU with bi rate at t-1, 2017-2021 |

Some notes on the results:

1. In general, the two datasets behave very differently. The old dataset (2000-2015) follows conventional theory much more compared to the new one (2017-2021).
2. On markups:
   1. CR4 doesn't seem to drive industry markups. Only TFP industry increases markups. This is the case of the old dataset.
   2. Similarly, markups has a negative association with log WPI. However, again, industry concentration doesn't matter on log WPI (remember dlog WPI = inflation). Also in the case of the old dataset.
   3. This is an interesting results. We find ann evidence that industry concentration on the food industry doesn't seem to hurt. It's markups that's the problem, which doesn't seem to relate on industrial concentration for some reason.
   4. On the new dataset, TFP industry isn't significant to markups, while CR4 does (albet at a weaker 11% confidence level). Total opposite of the old dataset.
   5. On the new dataset, both markups and CR4 are not significant to log WPI.
3. On interest rate:
   1. Lending rate and BI rate behave similarly, with lending rate having a larger magnitude, as expected.
   2. On the old dataset, both are significant to log WPI, both at t and t-1 (1 year lag). interest rate do reduces WPI, as per the theory. Magnitude for current rate and lagged rate are the same.
   3. Interestingly, new dataset finds that current lending rate and BI rate to be positively related to log WPI. Meaning, increased interest rate actually increase WPI. Lagged values have no significance.