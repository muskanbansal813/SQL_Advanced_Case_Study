# SQL Case Study - Advanced

## Business Scenario

This project is based on the **"Cellphones Information"** database, which contains details on cell phone sales and transactions. The database includes information on manufacturers, cellphone models, customers, locations, and transactional data.

The structure is organized into the following tables:

- **DIM_MANUFACTURER**: Contains entries for various cellphone manufacturers.
- **DIM_MODEL**: Contains details about specific cellphone models.
- **DIM_CUSTOMER**: Stores customer information.
- **DIM_LOCATION**: Stores location data, including state and zip code.
- **FACT_TRANSACTIONS**: Records transactional data on cellphone sales, including dates, prices, quantities, and related information.

The main goal of this case study is to use SQL queries to answer complex business questions about sales trends, high-performing models, customer spending habits, and regional purchase patterns.

## Questions

The following queries were crafted to answer specific business questions:

1. **States with Customers Who Bought Cellphones Since 2005**  
   List all the states where customers have bought cellphones from 2005 to today.

2. **Top State Buying Samsung Cell Phones**  
   Identify the state in the US with the highest purchases of Samsung cell phones.

3. **Transaction Count per Model by Zip Code and State**  
   Show the number of transactions for each model, organized by zip code and state.

4. **Cheapest Cellphone Model**  
   Display the name and price of the cheapest cellphone model available.

5. **Average Price for Each Model by Top 5 Manufacturers**  
   Calculate the average price for each model produced by the top 5 manufacturers (based on sales quantity), and order the results by average price.

6. **High-Spending Customers in 2009**  
   List the names of customers and their average amount spent in 2009, where the average spending is higher than $500.

7. **Consistently High-Selling Models**  
   Identify any models that were in the top 5 by quantity sold in 2008, 2009, and 2010.

8. **Second-Highest Sales Manufacturer in 2009 and 2010**  
   Display the manufacturer with the second-highest sales in 2009 and the manufacturer with the second-highest sales in 2010.

9. **Manufacturers Selling in 2010 but Not in 2009**  
   List the manufacturers that sold cellphones in 2010 but had no sales in 2009.

10. **Top 100 Customers Analysis**  
    For the top 100 customers, show their average spend and average quantity per year. Also, calculate the year-over-year percentage change in their spending.

## Usage

Each query in this repository is designed to be run independently on the `Cellphones Information` database. Results can provide insights into customer purchase patterns, top-performing models and manufacturers, and trends in cellphone sales across different states and timeframes.

