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

-- Select/Populate Property Address data
select PropertyAddress from portfolioproject.nashvillehousing;


--------------------------------------------------------------------------------------------------------------------------

-- Finding if there is NULL value in any sepecific column(eg: PropertyAddress) or not
select PropertyAddress from portfolioproject.nashvillehousing where PropertyAddress is null;


-- Excellent way to find if there is NULL in any column due to repetation of data in subsequent another row
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
COALESCE(a.PropertyAddress, b.PropertyAddress)                          -- COALESCE() vannale isnull ho i.e a.PropertyAddress null cha vani, b.PropertyAdress ko value le replace garni vaneko
FROM PortfolioProject.NashvilleHousing a
JOIN PortfolioProject.NashvilleHousing b ON a.ParcelID = b.ParcelID     -- Self Join (i.e join operation on same table)   -- yedi different row vako bela ma pani, ParcelID same cha vani, join gar vanna khojeko
AND a.`UniqueID` <> b.`UniqueID`                                        -- <> vannale, not equals to -- Unique ID same nahos vannale, same row lai join nagar vanna khojeko
WHERE a.PropertyAddress IS NULL;                                        -- a.PropertyAddress NULL pani vako case huna paryo, ball join garni, natra nagarni

-- Actually updating/making the changes
UPDATE PortfolioProject.NashvilleHousing a
JOIN PortfolioProject.NashvilleHousing b ON a.ParcelID = b.ParcelID
AND a.`UniqueID` <> b.`UniqueID`
SET a.PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)  --  MySQL ko COALESCE() is equivalent to ISNULL() in SQL Server 
WHERE a.PropertyAddress IS NULL;

--------------------------------------------------------------------------------------------------------------------------

-- Breaking/Seperating out Property Address into seperate/individual Columns like (Street, City) 

SELECT 
    SUBSTRING_INDEX(PropertyAddress, ',', 1) AS Street,
    TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)) AS City
FROM 
    portfolioproject.nashvillehousing;

```
    Here's a breakdown of the query:
    SUBSTRING_INDEX(PropertyAddress, ',', 1): This extracts the part of the address before the first comma.
    TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)): This extracts the part of the address after the last comma and removes any leading or trailing spaces using the TRIM() function.
```

-- Update/Changes by keeping previous Address column untouched and creating two new columns Street and City

-- First adding new 'Street' column
alter table portfolioproject.nashvillehousing
add Street Nvarchar(255);

-- Secondly, adding new 'City' column
alter table portfolioproject.nashvillehousing
add City Nvarchar(255);


-- Actual query to save the seperated address to Street and City column
UPDATE portfolioproject.nashvillehousing
SET Street = SUBSTRING_INDEX(PropertyAddress, ',', 1),
City = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1));



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field





-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates







---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns





