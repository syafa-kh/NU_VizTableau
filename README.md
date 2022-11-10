# Tableau Visualization and Custom SQL Queries

This repository includes the initial datasets, the custom queries used to transform table, the resulting CSV file, the tableau workbook, and the exported PDF file.

1. **tableau1.csv** <br>
   Initial dataset which includes title, genres, tags, vote distribution, and average rating. This is taken from NovelUpdates using a web scraping script which can be accessed [here](https://github.com/syafa-kh/NU_WebScrap)
2. **tableau2.csv** <br>
   This dataset include the title, vote distribution, average rating, and one-hot encoded columns of every genre. The encoding is done in Python because of SQL's limitation
3. **tableausql_load data.sql** <br>
   Queries used to load data from tableau1.csv and tableau2.csv to local SQL server
4. **tableausql_custom query.sql** <br>
   These queries were used to normalize the genres and tags (**tableau_title,genres,tags.csv**), normalize the genres and include the performance mesures (**tableau_title,genres,performances.csv**), and the correlation coefficients between each genre-performance measure pair (**tableau_genre,perf,corr.csv**)