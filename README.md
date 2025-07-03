## NPS Publication Replications
# Is a Photo Worth 1,000 Likes? The Influence of Instagram at National Parks!
##### Ashley C. Lowe Mackenzie 
##### Steven J. Dundas 


### Analysis Code
Replicates the various data visualizations across manuscrpit. Multiple Data analytic lanaguages where used.

1. Fig. 1 ~ Use  Data/Annual Summary Report (1904 - Last Calendar Year) (3).xlsx
2. Fig. 2 ~ Diagram Pictures/FrameworkInstagram.tiff
3. Fig 3.a ~ Use /Analysis_Code/Figure3a.do. This file requires Stata. Use Data/Figure3a.dta. ***Note the dataset is to large for github - request datasets for running this code ***
4. Fig 3.b ~ Use Analysis_Code/figure3b.ipynb. We use the Jupyter Notebook to generate Figure 3.b and the associated Extended Figure 3. This code implements a Random Forest machine learning algorithm to perform both classification and regression tasks. The model analyzes how various input variables influence predictive accuracy of the number likes, and the resulting importance matrix (also called the feature importance plot) highlights which variables contribute most to the model's performance. This allows us to identify the most influential predictors for like on each photo and to better understand the underlying drivers in the dataset.
5. Fig 3.c ~  Use Analysis_Code/Figure3c.do. These regression are coded in stata and produce figure c and extend table 3.
7. Fig. 4 ~ Use Cluster.R in R. Recreates Figure 4 and extend figure 4,5 and 7. It first begins with Extend figure 7 with the clustering using  DBSCAN to identify major outlies. Then Silloute to cluster on the remaining using a kmedians which is sensitive to outliers. Combining this imformation we produce Figure 4.
8. Fig 5 ~ Use Pictures/Graph.gph. Stata file to pull up graph of grouping parks
9. Fig6 ~ Use Analysis_Code/Figure 6.do. Stata coefficient plots based on grouping from fig 4.





