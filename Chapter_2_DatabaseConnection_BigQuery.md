## CONNECT DATABASE WITH BIGQUERY

*If you skipped chapter-1*: the database can be directly set up in Google BigQuery just by importing the .csv

<br>

*If you did not skipped chapter-1*, follow below instructions:

1. Connect Google BigQuery to Google Cloud SQL [(guide)](https://cloud.google.com/bigquery/docs/connect-to-sql)
    - Go to [IAM](https://cloud.google.com/sql/docs/mysql/users) (Information Access Management) 
    ![Alt text](6.2-1.png)
    - Grant your user Cloud SQL admin and user rights
    ![Alt text](6.3-1.png)
    ![Alt text](6.4-1.png)
    -  Go to BigQuery 
    ![Alt text](7-1.png)
    - Click on Add>Connections to external data sources
    ![Alt text](8-1.png)
    ![Alt text](9-1.png)
    - Configure the external data source connection as shown below:
    ![Alt text](<Screenshot 2023-07-26 at 17.02.38.png>)
    - Now you can start querying the tables!
    ![Alt text](10-1.png)



