# 🛒 E-commerce Sales Analysis

This project focuses on cleaning and analyzing an e-commerce dataset, addressing data quality issues such as missing values, inconsistent categories, and transaction logic.

## 🎯 Objective

- Clean and preprocess raw e-commerce data
- Ensure consistency across transactions
- Prepare the dataset for analysis and visualization

## 📊 Dataset

The dataset contains transactional data with the following columns:

- ID : id of each row
- Customer_name: name of the clients
- Orde_ID: id of each order
- Order_Date: date of the order
- Product: products name
- Category: category of products
- Quantity: number of products ordered
- Price: price of each product
- Payment_Method: payment method used
- Status: status of the order
- Total: total price of the order

Note: The dataset was cleaned to fix inconsistencies and missing values.

## 🧹 Data Cleaning Process

- Remove spaces from the columns name
- Removed duplicates
- Converted each column in their respective data types
- Standardized product categories (resolved inconsistencies)
- Handled missing values:
  - Quantity: inferred from business logic
  - Price: fill the missing values by the mean price of the product
- Corrected inconsistent product-category relationships
- Converted text-based numbers (e.g., "four hundred") into numeric values
- Replace the total by the product of Quantity and Price

## 🧠 Key Assumptions

- Missing quantity values with valid price were assumed as 1
- Misising Price values was assumed as the mean price of the product
- Product categories were standardized using the most frequent category per product

## 🛠 Tools & Technologies

- Python (Pandas, NumPy)
- Jupyter Notebook
- Git & GitHub

## 📂 Project Structure

project/
│── Dataset/
│── Notebooks/
│── README.md