Select *
From NashvilleHousing

Select SaleDate, CONVERT(date,SaleDate)
From NashvilleHousing

ALTER TABLE NashvilleHousing
ALTER COLUMN SaleDate DATE

Select PropertyAddress, ParcelID
From NashvilleHousing
Where PropertyAddress is null

Select Housing_1.ParcelID, Housing_1.PropertyAddress, Housing_2.ParcelID,Housing_2.PropertyAddress, ISNULL(Housing_1.PropertyAddress,Housing_2.PropertyAddress)
From NashvilleHousing AS Housing_1
JOIN NashvilleHousing AS Housing_2
	on Housing_1.ParcelID = Housing_2.ParcelID
	AND Housing_1.[UniqueID ]<> Housing_2.[UniqueID ]
Where Housing_1.PropertyAddress is null

Update housing_1
Set PropertyAddress = ISNULL(Housing_1.PropertyAddress,Housing_2.PropertyAddress)
From NashvilleHousing AS Housing_1
JOIN NashvilleHousing AS Housing_2
	on Housing_1.ParcelID = Housing_2.ParcelID
	AND Housing_1.[UniqueID ]<> Housing_2.[UniqueID ]
Where Housing_1.PropertyAddress is null



Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as City 
From NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertyNewAddress Nvarchar(250)

Update NashvilleHousing
Set PropertyNewAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) 


ALTER TABLE NashvilleHousing
ADD PropertyCity Nvarchar(250)

Update NashvilleHousing
Set PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

Select *
From NashvilleHousing


Select OwnerAddress
From NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerNewAddress Nvarchar(250)

Update NashvilleHousing
Set OwnerNewAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3) 


ALTER TABLE NashvilleHousing
ADD OwnerCity Nvarchar(250)

Update NashvilleHousing
Set OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerState Nvarchar(250)

Update NashvilleHousing
Set OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
Case When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant = 
Case When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END



WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY parcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY UniqueID
				) row_num
From NashvilleHousing
)
Delete
From RowNumCTE
Where row_num > 1 


Select *
From NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress

Select *
From NashvilleHousing