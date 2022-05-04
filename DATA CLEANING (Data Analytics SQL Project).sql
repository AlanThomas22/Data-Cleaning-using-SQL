USE housing;
-- Cleansing data in SQL Queries
SELECT *
FROM nashville_housing;

-- Standardize date format
ALTER TABLE nashville_housing
MODIFY SaleDate Date;

-- Populate Property Address Data
SELECT *
FROM nashville_housing
ORDER BY parcelID; 

SELECT a.parcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress)
FROM nashville_housing a
JOIN nashville_housing b
ON a.ParcelID = b.parcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE nashville_housing
SET PropertyAddress = "No Address"
WHERE PropertyAddress IS NULL;

-- Breaking Out Address Into individual Coulmns ( Address, City, State)
SELECT PropertyAddress
FROM nashville_housing;

SELECT
substring(PropertyAddress, 1 , locate(',',PropertyAddress)-1) AS Address,
substring(PropertyAddress, locate(',',PropertyAddress)+1, LENGTH(PropertyAddress) ) AS Address
FROM nashville_housing;

ALTER TABLE nashville_housing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE  nashville_housing
SET PropertySplitAddress = substring(PropertyAddress, 1 , locate(',',PropertyAddress)-1);

ALTER TABLE nashville_housing
ADD PropertySplitCity NVARCHAR(255);

UPDATE  nashville_housing
SET PropertySplitCity = substring(PropertyAddress, locate(',',PropertyAddress)+1, LENGTH(PropertyAddress) );


SELECT OwnerAddress
FROM nashville_housing;


SELECT 
substring(OwnerAddress, locate(',',OwnerAddress)+1, LENGTH(OwnerAddress) ) AS StreetCity
FROM nashville_housing;

ALTER TABLE nashville_housing
ADD StreetCity NVARCHAR(255);

UPDATE  nashville_housing
SET StreetCity = substring(OwnerAddress, locate(',',OwnerAddress)+1, LENGTH(OwnerAddress) );

SELECT
substring(StreetCity, locate(',',StreetCity)+1, LENGTH(StreetCity)) AS City
FROM nashville_housing;

ALTER TABLE nashville_housing
ADD City nvarchar(255);

UPDATE nashville_housing
SET City = substring(StreetCity, locate(',',StreetCity)+1, LENGTH(StreetCity));

SELECT
substring(OwnerAddress, 1 , locate(',',OwnerAddress)-1) AS Address
FROM nashville_housing;

SELECT StreetCity
FROM nashville_housing;

SELECT 
substring(StreetCity, 1, locate(',',StreetCity)-1) AS City
FROM nashville_housing;

ALTER TABLE nashville_housing
ADD OwnerSplitAddress nvarchar(255);

UPDATE nashville_housing
SET OwnerSplitAddress = substring(OwnerAddress, 1 , locate(',',OwnerAddress)-1);


ALTER TABLE nashville_housing
ADD OwnerSplitCity nvarchar(255);

UPDATE nashville_housing
SET OwnerSplitCity = substring(StreetCity, 1, locate(',',StreetCity)-1);

SELECT *
FROM nashville_housing;

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsvacant), COUNT(SoldAsVacant)
FROM nashville_housing
GROUP BY SoldAsVacant
ORDER BY COUNT(SoldAsVacant) ASC;

SELECT SoldAsVacant,
CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes' 
WHEN SoldAsVacant = 'N' THEN 'No' 
ELSE SoldAsVacant
END
FROM nashville_housing;

UPDATE nashville_housing
SET SoldAsVacant = CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes' 
WHEN SoldAsVacant = 'N' THEN 'No' 
ELSE SoldAsVacant
END;

-- Remove Duplicates
WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			 PropertyAddress, 
             SalePrice,
             SaleDate,
             LegalReference
             ORDER BY UniqueID
             ) row_num
 FROM nashville_housing
 )
 DELETE
 FROM RowNumCTE 
 WHERE row_num > 1;


-- DELETE Unused Columns
SELECT *
FROM nashville_housing;
 
 ALTER TABLE nashville_housing
 DROP COLUMN TaxDistrict;
 
 ALTER TABLE nashville_housing
 DROP COLUMN OwnerAddress;

ALTER TABLE nashville_housing
 DROP COLUMN PropertyAddress;

 
             
 
             