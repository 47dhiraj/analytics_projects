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

-- # 1st) For PropertyAddress

-- First adding new 'PropertyStreet' column
alter table portfolioproject.nashvillehousing
add PropertyStreet Nvarchar(255);

-- Secondly, adding new 'PropertyCity' column
alter table portfolioproject.nashvillehousing
add PropertyCity Nvarchar(255);


-- (For MySQL database) Actual query to save the seperated address to Street and City column
UPDATE portfolioproject.nashvillehousing
SET PropertyStreet = SUBSTRING_INDEX(PropertyAddress, ',', 1),
PropertyCity = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1));

-- (For Microsoft SQL Server) Actual query to save the seperated address to Street and City column
UPDATE portfolioproject.nashvillehousing
SET PropertyStreet = LEFT(PropertyAddress, CHARINDEX(',', PropertyAddress + ',') - 1),
PropertyCity = LTRIM(RTRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))));




-- # 2nd) For OwnerAddress

-- First adding new 'OwnerStreet' column
alter table portfolioproject.nashvillehousing
add OwnerStreet Nvarchar(255);

-- Second, adding new 'OwnerCity' column
alter table portfolioproject.nashvillehousing
add OwnerCity Nvarchar(255);

-- Third, adding new 'OwnerState' column
alter table portfolioproject.nashvillehousing
add OwnerState Nvarchar(255);


-- (For MySQL Database) Actual query to save the seperated address to Street, City and State columns
UPDATE portfolioproject.nashvillehousing
SET 
    OwnerStreet = SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', -3), '.', 1),
    OwnerCity = SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', -2), '.', 1),
    OwnerState = SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', -1);


```
    This MySQL query uses REPLACE to replace commas with dots and then SUBSTRING_INDEX to extract the desired parts.
    The negative values in SUBSTRING_INDEX represent counting from the end of the string. 
    The -1 gets the last part, the -2 gets the second last part and -2 gets the first part (i.e seperating in reverse order because we want to sepearte in reverse way).

    NOTE: MySQL uses 1-based indexing for SUBSTRING_INDEX.
```


-- (For Microsoft SQL Server) Actual query to save the seperated address to OwnerStreet, OwnerCity and OwnerState columns
UPDATE PortfolioProject.dbo.NashvilleHousing
SET 
    OwnerStreet = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
    OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);



--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "SoldAsVacant" field


-- First doing GroupBy counting  (For having better understanding before doing something)
SELECT distinct(SoldAsVacant), COUNT(SoldAsVacant) AS CountSoldAsVacant
FROM PortfolioProject.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY CountSoldAsVacant;


-- Now, (For MySQL) Actually changing Y to Yes and N to No, using CASE statment
UPDATE PortfolioProject.NashvilleHousing
SET SoldAsVacant = CASE 
                    WHEN SoldAsVacant = 'Y' THEN 'Yes'
                    WHEN SoldAsVacant = 'N' THEN 'No'
                    ELSE SoldAsVacant
                END;

-- Alternative(For Microsof SQL Server) Actually changing Y to Yes and N to No, using CASE statment
Update PortfolioProjectNashvilleHousing
SET SoldAsVacant = CASE 
                    When SoldAsVacant = 'Y' THEN 'Yes'
                    When SoldAsVacant = 'N' THEN 'No'
                    ELSE SoldAsVacant
                END;


-- Finally, u can see/visualize if changed properly or not like earlier
SELECT distinct(SoldAsVacant), COUNT(SoldAsVacant) AS CountSoldAsVacant
FROM PortfolioProject.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY CountSoldAsVacant;




-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates (i.e  keep a single instance of each set of duplicate rows and remove the rest)
-- Removing Duplicates is rarely used in SQL (and it is risky deleting data too)

-- MYSQL SYNTAX: 
```
    DELETE FROM your_table
    WHERE (column1, column2, column3) IN (
        SELECT column1, column2, column3
        FROM (
            SELECT
                column1,
                column2,
                column3,
                ROW_NUMBER() OVER (PARTITION BY column1, column2, column3 ORDER BY id) AS row_num
            FROM your_table
        ) AS t
        WHERE row_num > 1
    );
```

-- MySQL Example: 
DELETE FROM portfolioproject.nashvillehousing
WHERE (ParcelID, PropertyAddress, SalePrice, LegalReference) IN (
    SELECT ParcelID, PropertyAddress, SalePrice, LegalReference
    FROM (
        SELECT
            ParcelID,
            PropertyAddress,
            SalePrice,
            LegalReference,
            ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, LegalReference ORDER BY UniqueID) AS row_num
        FROM portfolioproject.nashvillehousing
    ) AS t
    WHERE row_num > 1
);




---------------------------------------------------------------------------------------------------------

-- Delete unnecessary/not required/unused Columns

-- Visualize all column before deleting
Select * From PortfolioProject.NashvilleHousing

-- Actual query to Drop/Delete multiple unrequired columns at once
ALTER TABLE PortfolioProject.NashvilleHousing
DROP COLUMN OwnerAddress,
DROP COLUMN PropertyAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN SaleDate;

-- see if the colulmns are deleted
Select * From PortfolioProject.NashvilleHousing
