library('cluster')
library(dplyr)
library(patchwork)
library(dbscan)
library(ggplot2)
library(viridis)
library(ggrepel)
library(scales)
library(hrbrthemes)
library(dbscan)
library(readr)
library(factoextra)

viral_colors <- c('#fde725','#21918c','#440154')

#Identify cluster 

set.seed(123)

#################


## Concerned with choice of clusters check to see if outliers without choice
max_likesComments <- read_csv("~/Data_Publications/Data/max_likesComments.csv")

df=max_likesComments
df=df[c(5,9)]

# Normalize inddicators to compare between measurements 
df$likes=(df$likes-min(df$likes))/(max(df$likes)-min(df$likes))
df$infuencers=(df$infuencers-min(df$infuencers))/(max(df$infuencers)-min(df$infuencers))


Dbscan_cl <- dbscan(df, eps =.25, MinPts = 2) 
Dbscan_cl 

# Checking cluster 
Dbscan_cl$cluster 

df <- cbind(df, cluster = Dbscan_cl$cluster)
df <- cbind(df, ParkName = max_likesComments$ParkName)

max_likesComments1=merge(max_likesComments, df, by=c("ParkName"), all.x = TRUE)

ggplot(max_likesComments1,aes(x=infuencers.x, y=likes.x, size=`mean(RecreationVisits)`/10000, color=cluster)) +
  geom_point(alpha=0.3) + scale_size(range = c(.1, 20)) +geom_text_repel(size = 3,colour = "black",
                                          family = "Times New Roman",
                                          label=max_likesComments1$ParkName, 
                                          alpha =1,
                                          segment.size = .5,
                                          segment.alpha = .8,
                                          force =10)+
  coord_cartesian(clip = "off")+
  
  scale_color_viridis( name = "SD of Likes") +scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6))+
  scale_x_continuous(labels = unit_format(unit = "K", scale = 1e-3))+ 
  labs(y= "Likes on Parks Most Liked Photo",
       x= "Comments on Parks Most Commonted Photo") +theme_ipsum(base_size=10, base_family='Times New Roman')+
  theme(legend.position="none",text = element_text(family = "Times New Roman"))
ggsave('cluster2.png', dpi = 300, height = 8, width = 8, unit = 'in')


## Indicator of three levels as Zion and Yosemite appear to be outliers 
df=max_likesComments
df=df[c(5,9)]
df$likes=(df$likes-min(df$likes))/(max(df$likes)-min(df$likes))
df$infuencers=(df$infuencers-min(df$infuencers))/(max(df$infuencers)-min(df$infuencers))


df=df[1:38,]
fviz_nbclust(df, pam, method = "silhouette") +
  geom_vline(xintercept = 2, linetype = 2)+
  labs(subtitle = "Silhouette method")
ggsave('Silhouette.png', dpi = 300, height = 8, width = 8, unit = 'in')

#Manhattan More robust to outliers and sparse data
k2 <- pam(df[1:38,], metric = "manhattan", k = 2, stand =TRUE)
df <- cbind(df[1:38,], cluster = k2$cluster)
df <- cbind(df[1:38,], ParkName = max_likesComments[1:38,]$ParkName)

max_likesComments1=merge(max_likesComments, df, by=c("ParkName"), all.x = TRUE)
ggplot(max_likesComments1,aes(x=infuencers.x, y=likes.x, size=`mean(RecreationVisits)`/10000, color=cluster)) +
  geom_point(alpha=0.5)  +geom_text_repel(size = 3,colour = "black",
                                          family = "Times New Roman",
                                          label=max_likesComments1$ParkName, 
                                          alpha =1,
                                          segment.size = .5,
                                          segment.alpha = .8,
                                          force =10)+
  coord_cartesian(clip = "off")+
  
  scale_color_viridis( name = "") +scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6))+
  scale_x_continuous(labels = unit_format(unit = "K", scale = 1e-3))+ 
  labs(y= "Likes on Parks Most Liked Photo",
       x= "Sum of Post from Influencer at Park") +theme_ipsum(base_size=10, base_family='Times New Roman')+
  theme(legend.position="none",text = element_text(family = "Times New Roman"))



parkcluster <- read_csv("~/Data_Publications/Data/parkcluster.csv")
View(parkcluster)


likes=ggplot(parkcluster, aes(x = Year, y = max_likes/1000000, group = ParkName, colour = Viral)) +geom_line() +
  facet_wrap(~ ParkName)+theme_bw() + labs(x = 'Year',
                                           y = 'Most Viral Post by Likes in Millions') +
  theme(axis.text.x = element_text(size = 8, angle = 90, hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(size = 8),
        text = element_text(family = "Times New Roman", size = 10)) +
  scale_x_continuous(breaks = ~ axisTicks(., log = FALSE))+scale_color_manual(values = viral_colors)
ggsave('maxlikes.png', dpi = 300, height = 8, width = 8, unit = 'in')

influ=ggplot(parkcluster, aes(x = Year, y = max_influ/1000, group = ParkName, colour = Viral)) +geom_line() +
  facet_wrap(~ ParkName)+theme_bw() + labs(x = 'Year',
                                           y = 'Number of Influencers Present in Thousands') +
  theme(axis.text.x = element_text(size = 8, angle = 90, hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(size = 8),
        text = element_text(family = "Times New Roman", size = 10)) +
  scale_x_continuous(breaks = ~ axisTicks(., log = FALSE))+scale_color_manual(values = viral_colors)
ggsave('maxinflu.png', dpi = 300, height = 8, width = 8, unit = 'in')

