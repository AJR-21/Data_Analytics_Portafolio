#Import libraries
import pandas as pd
from sqlalchemy import create_engine

#load the data
df = pd.read_csv('cutomer_behavior_analysis\Dataset\customer_shopping_behavior.csv')

#view the first 5 rows
print(df.head())

#view the shape
print(df.shape)

#View the info
print(df.info())

#Data summary
print(df.describe())

#review duplicates
print(df.duplicated().sum())

#review missing values
print(df.isnull().sum())

#Fill missing values in review rating column
df['Review Rating'] = df.groupby('Category')['Review Rating'].transform(lambda x: x.fillna(x.median()))

#Cheack again null values
print(df.isnull().sum())

#Standarize columns name
df.columns = df.columns.str.lower()
df.columns = df.columns.str.replace(' ', '_')
df = df.rename(columns = {'purchase_amount_(usd)': 'purchase_amount'})

#review columns name
print(df.columns)

#group the customers by age group
labels = ['Young Adult', 'Adult','Middle-aged', 'Senior']#four age groups label
df['age_group'] = pd.qcut(df['age'], q=4, labels=labels)

#review the new column
print(df[['age', 'age_group']].head(10))

#Create a column purchase frequency days
mapping_frequency = {
    'Fortnightly': 14,
    'Weekly': 7,
    'Monthly': 30,
    'Quarterly': 90,
    'Annually': 365,
    'Bi-Weekly': 14,
    'Every 3 Months': 90
}
df['purchase_frequency_days'] = df['frequency_of_purchases'].map(mapping_frequency)

#review the new column
print(df[['frequency_of_purchases', 'purchase_frequency_days']].head())

#Review discount_applied and promo_code_used columns
print(df[['discount_applied', 'promo_code_used']].head(10)) #look like the same

#Check if both columns are the same
print((df['discount_applied'] == df['promo_code_used']).all())

#Drop one column because are duplicated column
df = df.drop('promo_code_used', axis=1)

#check columns 
print(df.columns)

#Step 1: connect to PostgreSQL
#replace placeholders with current details
username = 'postgres'
password = 'sql2026'
host = 'localhost'
port = '5432'
database = 'customer_behavior'

engine = create_engine(f'postgresql://{username}:{password}@{host}:{port}/{database}')

#Step 2: load the dataframe into PostgreSQL
table_name = 'customer'
df.to_sql(table_name, engine, if_exists='replace', index=False)
print(f'Data successfully loaded into table {table_name} in database {database}.')


