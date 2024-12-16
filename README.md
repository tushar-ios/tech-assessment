# TechAssessment

## Overview

TechAssessment is an iOS application built with **SwiftUI**. The app allows users to view and add products, with all data stored locally in a persistent database using **SwiftData** API. It follows the MVVM (Model-View-ViewModel) architecture pattern for clean code separation and maintainability.

## Key Features
- **Pagination**: Implements pagination to efficiently fetch products, ensuring the app does not fetch all items at once.
- **Concurrency**: Utilized for offloading database operations (save/fetch) from the main thread for improved performance.
- **Modularization**: Swift Package Manager (SPM) used to modularize the codebase.
- **Localization**: Supports English and French languages for wider accessibility.

## Unit Testing
- ViewModels: Unit tests are written for each ViewModel to ensure that business logic is handled correctly.
- ProductsService: A set of unit tests is written for the ProductsService module to ensure data is fetched and stored correctly.
- **UI Testing**: An end-to-end UI test ensures the smooth operation of the full app flow, including adding a product and viewing the list.

## Languages Supported
- English
- French

## Screenshots

Here are a couple of screenshots showcasing the app:
<p float="left">
  <img src="Screenshots/Products%20List%20View.png" width="272" height="449.5"/>
   <img src="Screenshots/Add%20Product%20View.png" width="272" height="457"/>
</p>

## Contributors
- [Tushar Agarwal](https://www.linkedin.com/in/tusharagarwal10)
