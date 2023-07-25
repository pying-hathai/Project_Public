-- Cleansing Data in SQL Quesry

select 
	*
from NashvilleHousing

-- Standardize Data Format

select 
	SaleDate,
	convert(Date,SaleDate)
from NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

select 
	SaleDateConverted,
	CONVERT(Date, SaleDate)
from NashvilleHousing

-- Populate Propoty Address data

Select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select 
	a.UniqueID,
	a.ParcelID,
	a.PropertyAddress,
	b.UniqueID,
	b.ParcelID,
	b.PropertyAddress,
	ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
--where a.propertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID

-- Breaking out Address into Individual Columns (Address, City, State)
Select
	PropertyAddress,
	PropertySplitAddress,
	PropertySplitCity
from NashvilleHousing

select
	substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
	CHARINDEX(',',PropertyAddress),
	substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address,
	LEN(PropertyAddress)
from NashvilleHousing

ALTER Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255),
	PropertySplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) 

UPDATE NashvilleHousing
SET PropertySplitCity = substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

-- Owneraddress

Select Owneraddress
from NashvilleHousing

Select
	Owneraddress,
	PARSENAME(REPLACE(OwnerAddress,',','.'),3),
	PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from NashvilleHousing

ALTER Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255),
	OwnerSplitCity nvarchar(255),
	OwnerSplitState nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select 
	OwnerSplitAddress,
	OwnerSplitCity,
	OwnerSplitState
from NashvilleHousing

-- Change Y and N to Yes and No in "Sold and Vacant" field
Select Distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2

select 
	SoldAsVacant,
	case
		when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
	end
from NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = 
	case
		when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
	end

-- Remove Duplicate
WITH RowNumCTE as (
	Select *,
		ROW_NUMBER() over (
		PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY
						UniqueID
						) row_num
	from NashvilleHousing
)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress
-----
WITH RowNumCTE as (
	Select *,
		ROW_NUMBER() over (
		PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY
						UniqueID
						) row_num
	from NashvilleHousing
)
DELETE
from RowNumCTE
where row_num > 1


-- Delete Unused Columns
select *
from NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN 
	OwnerAddress,
	TaxDistrict,
	PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate

-- 