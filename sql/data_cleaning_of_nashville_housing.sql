/*

    Data Cleaning using SQL Queries

*/




-- For Selecting All Data from nashvillehousing
select * from portfolioproject.nashvillehousing;


-- For Selecting only particular column
select SaleDate from portfolioproject.nashvillehousing;


--------------------------------------------------------------------------------------------------------------------------
-- Standardize Date Format (i.e Converting String Date Format to actual Date Format)
SELECT SaleDate, DATE_FORMAT(STR_TO_DATE(SaleDate, '%M %d, %Y'), '%Y-%m-%d') AS formatted_date
FROM PortfolioProject.nashvillehousing;


-- To Actually make Changes/Update the existing saleDate column by Date Formatted column data
UPDATE PortfolioProject.nashvillehousing
SET SaleDate = DATE_FORMAT(STR_TO_DATE(SaleDate, '%M %d, %Y'), '%Y-%m-%d');






 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data





--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)







--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field





-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates







---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns





