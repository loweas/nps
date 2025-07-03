## NPS Publication Replications
# Is a Photo Worth 1,000 Likes? The Influence of Instagram at National Parks
###### Ashley C. Lowe Mackenzie 
###### Steven J. Dundas 


### Analysis Code
Replicates the various data visualizations across manuscrpit. Multiple Data analytic lanaguages where used.

1. [Fig. 1](Data_Publications/Data/AnnualSummaryReport.xlsx) ~ Use  Data/Annual Summary Report (1904 - Last Calendar Year) (3).xlsx
![alt text](Data_Publications/Pictures/image.png)
2. [Fig. 2](Data_Publications/Pictures/FrameworkInstagram.pptx) ~ Diagram Pictures/FrameworkInstagram.tiff
![alt text](Data_Publications/Pictures/image-1.png)
3. [Fig 3.a](Data_Publications/Analysis_Code/Figure3a.do) ~ Use /Analysis_Code/Figure3a.do. This file requires Stata. Use Data/Figure3a.dta. **Note the dataset is to large for github - request datasets for running this code**
![alt text](Data_Publications/Pictures/image-2.png)
4. [Fig 3.b](Data_Publications/Analysis_Code/figure3b.ipynb) ~ Use Analysis_Code/figure3b.ipynb. We use the Jupyter Notebook to generate Figure 3.b and the associated Extended Figure 3. This code implements a Random Forest machine learning algorithm to perform both classification and regression tasks. The model analyzes how various input variables influence predictive accuracy of the number likes, and the resulting importance matrix (also called the feature importance plot) highlights which variables contribute most to the model's performance. This allows us to identify the most influential predictors for like on each photo and to better understand the underlying drivers in the dataset.

5. [Fig 3.c](Data_Publications/Analysis_Code/Figure3c.do) ~  Use Analysis_Code/Figure3c.do. These regression are coded in stata and produce figure c and extend table 3.
7. [Fig. 4](Data_Publications/Analysis_Code/Cluster.R) ~ Use Cluster.R in R. Recreates Figure 4 and extend figure 4,5 and 7. It first begins with Extend figure 7 with the clustering using  DBSCAN to identify major outlies. Then Silloute to cluster on the remaining using a kmedians which is sensitive to outliers. Combining this imformation we produce Figure 4.
![alt text](image-3.png)
8. [Fig 5](Data_Publications/Pictures/Graph.gph) ~ Use Pictures/Graph.gph. Stata file to pull up graph of grouping parks
![alt text](image-4.png)
9. [Fig6](Data_Publications/Pictures/Figure6.do) ~ Use Analysis_Code/Figure 6.do. Stata coefficient plots based on grouping from fig 4.
![alt text](Data_Publications/Pictures/image-5.png)




