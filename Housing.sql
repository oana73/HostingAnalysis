-- claeaning data
SELECT *
FROM Housing

-- standardize date format
SELECT SaleDateConverted,CONVERT(Date,SaleDate)
FROM Housing

UPDATE Housing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Housing
ADD SaleDateConverted Date;

UPDATE Housing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--propert Address data
SELECT *
FROM Housing
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT h1.ParcelID, h1.PropertyAddress, h2.ParcelID, h2.PropertyAddress, ISNULL(h1.PropertyAddress, h2.PropertyAddress)
FROM Housing h1
JOIN Housing h2
	ON h1.ParcelID = h2.ParcelID
	AND h1.[UniqueID] <> h2.[UniqueID]
--WHERE h1.PropertyAddress is null

UPDATE h1
SET PropertyAddress = ISNULL(h1.PropertyAddress, h2.PropertyAddress)
FROM Housing h1
JOIN Housing h2
	ON h1.ParcelID = h2.ParcelID
	AND h1.[UniqueID] <> h2.[UniqueID]
WHERE h1.PropertyAddress is null

-- breaking out address into individual columns

SELECT PropertyAddress
From Housing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
FROM Housing

ALTER TABLE Housing
ADD PropertySplitAddress Nvarchar(50);

UPDATE Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE Housing
ADD PropertySplitCity Nvarchar(50);
UPDATE Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT *
FROM Housing

SELECT OwnerAddress
FROM Housing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',' ,'.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',' ,'.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',' ,'.'), 1)

FROM Housing

ALTER TABLE Housing
ADD OwnerSplitAddress Nvarchar(50);
UPDATE Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' ,'.'), 3)

ALTER TABLE Housing
ADD OwnerCity Nvarchar(50);
UPDATE Housing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',' ,'.'), 2)

ALTER TABLE Housing
ADD OwnerState Nvarchar(50);
UPDATE Housing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',' ,'.'), 1)

-- chanfe y and n to tes and no 

SELECT DISTINCT(SoldAsVacant)
FROM Housing

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM Housing

UPDATE Housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END


-- remove duplicates 
-- cte

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) row_num
	
FROM Housing
)
SELECT * --DELETE 
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


--delete columns
SELECT *
FROM Housing


ALTER TABLE Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Housing
DROP COLUMN SaleDate
