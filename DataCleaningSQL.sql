 /*

 SQL Queries to clean data

 */

SELECT * FROM portfolio_projects..DataCleaning


--Standardize Date Format

SELECT SaleDateConverted, CONVERT(Date, saledate)
FROM portfolio_projects..DataCleaning

UPDATE DataCleaning
SET SaleDate = CONVERT(Date, saledate)



ALTER TABLE DataCleaning
ADD SaleDateConverted Date,


UPDATE DataCleaning
SET SaleDateConverted = CONVERT(Date,SaleDate)


--Populate Property Address data


SELECT a.parcelID, a.propertyaddress, b.parcelID, b.Propertyaddress, ISNULL(a.propertyaddress, b.propertyaddress)
FROM portfolio_projects..DataCleaning a
JOIN portfolio_projects..DataCleaning b
	ON a.parcelID = b.parcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.propertyAddress IS NULL



UPDATE a
SET propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress)
FROM portfolio_projects..DataCleaning a
JOIN portfolio_projects..DataCleaning b
	ON a.parcelID = b.parcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.propertyAddress IS NULL





--BREAKING ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

SELECT propertyaddress
FROM portfolio_projects..DataCleaning


SELECT 
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) AS Address
, SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, LEN(propertyaddress)) AS Address
FROM portfolio_projects..DataCleaning




ALTER TABLE DataCleaning
ADD SplitPropertyAddress VARCHAR(255);


UPDATE DataCleaning
SET SplitPropertyAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1)


ALTER TABLE DataCleaning
ADD SplitPropertyCity VARCHAR(255);


UPDATE DataCleaning
SET SplitPropertyCity = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, LEN(propertyaddress))




SELECT OwnerAddress 
FROM portfolio_projects..DataCleaning


-- SPLITTING OWNER ADDRESS 

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM portfolio_projects..DataCleaning


ALTER TABLE DataCleaning
ADD SplitownerAddress VARCHAR(255);

UPDATE DataCleaning
SET SplitOwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


ALTER TABLE DataCleaning
ADD SplitOwnerCity VARCHAR(255);


UPDATE DataCleaning
SET SplitOwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2) 


ALTER TABLE DataCleaning
ADD SplitOwnerState VARCHAR(255);


UPDATE DataCleaning
SET SplitOwnerState = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1)





--CHANGING Y TO YES AND N TO NO IN SoleVacant


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM portfolio_projects..DataCleaning
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM portfolio_projects..DataCleaning

UPDATE DataCleaning
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM portfolio_projects..DataCleaning



--REMOVE DUPLICATES

WITH RowNumCTE AS (
	SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				LegalReference
				ORDER BY
					UniqueID
					) row_num			
	FROM portfolio_projects..DataCleaning
	)


SELECT *
FROM RowNumCTE
WHERE row_num > 1



--DELETE UNUSED COLUMNS



ALTER TABLE portfolio_projects..DataCleaning
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict



SELECT *
FROM portfolio_projects..DataCleaning








