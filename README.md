# Data Cleaning Project (SQL)

## Overview
This project focuses on cleaning a dataset using SQL Server. The goal is to transform messy, inconsistent data into a well-structured, analysis-ready format by standardizing formats, splitting combined fields, handling missing values, and removing duplicates.

## Dataset
The dataset contains property sale records, including fields such as Parcel ID, Property Address, Owner Address, Sale Date, Sale Price, Legal Reference, and Sold As Vacant status.

## Steps
1. **Standardize Date Format** — Converted `SaleDate` from datetime to a clean `Date` format in a new `SaleDateConverted` column.
2. **Populate Missing Property Address Data** — Used a self-join on `ParcelID` to fill in missing `PropertyAddress` values by matching records with the same parcel ID.
3. **Break Address into Individual Columns** — Split `PropertyAddress` into separate `Address` and `City` columns using `SUBSTRING` and `CHARINDEX`. Split `OwnerAddress` into `Address`, `City`, and `State` columns using `PARSENAME`.
4. **Standardize Categorical Values** — Converted the `SoldAsVacant` column from inconsistent `Y`/`N` values to full `Yes`/`No` values using a `CASE` statement.
5. **Remove Duplicates** — Used a CTE with `ROW_NUMBER()`, partitioned by key fields (`ParcelID`, `PropertyAddress`, `SalePrice`, `SaleDate`, `LegalReference`), to identify and remove duplicate records.
6. **Remove Unused Columns** — Dropped redundant columns (`OwnerAddress`, `TaxDistrict`, original `PropertyAddress`, original `SaleDate`) after creating their cleaned replacements.

## Results
The cleaning process produced a standardized dataset with consistent date formats, complete address fields, split address components ready for geographic analysis, uniform Yes/No values for vacancy status, and no duplicate records, turning a raw, inconsistent export into a reliable dataset ready for further analysis or visualization.
