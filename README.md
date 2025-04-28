# OpenWeatherTCAApp

## Overview

**OpenWeatherTCAApp** is an iOS application built using **SwiftUI** and **The Composable Architecture (TCA)**. The app demonstrates Clean Architecture principles, focusing on modularity, testability, and adherence to SOLID principles. It consists of two main features:

1. **Weather Screen**: Displays the current temperature and city name based on the user's location.
2. **Instagram Story-Like View**: Mimics Instagram stories with auto-progressing and swipeable random images.

---

## Features

### 1. **Weather Screen**
- Fetches and displays the current temperature and city name using CoreLocation and a weather API (e.g., OpenWeatherMap).
- Handles loading states and errors gracefully.
- Provides a button to navigate to the Instagram story-like view.

### 2. **Instagram Story-Like View**
- Displays a series of random images, which auto-progress every 3 seconds.
- Allows users to manually swipe between images.
- Includes a progress bar at the top to indicate the auto-progress status of each image.
- **Uses Unsplash API**: Fetches a collection of city-related random images from the Unsplash API to provide dynamic and visually appealing content.

### 3. **The Composable Architecture (TCA) Integration**
- State management for both features is implemented using TCA, ensuring modularity and testability.
- Uses dependency injection for external services (e.g., weather API, random image service).

---

## Project Structure

The project follows the **Clean Architecture** pattern:

```
OpenWeatherTCAApp/
├── APP/
│   ├── APIKeys.swift
│   ├── AppReducer.swift
│   ├── AppViews.swift
│   ├── OpenWeatherTCATestApp.swfit
│   ├── Info.plist
│   ├── Resources/
│   │   ├── Assets
│   │   ├── SplashScreen.swift
│   │   └── LaunchScreen.storyboard
├── Core/
│   ├── Infrastructure/
│   │   └── Networking/
│   │       ├── DefaultDataTransferService.swift
│   │       ├── HTTPClient.swift
│   │       └── URLSessionHTTPClient.swift
│   ├── Domain/
│   │   ├── Entities/
│   │   │    ├── Weather.swift
│   │   │    └── Story.swift
│   │   └── UseCases/
│   │        └── DataTransferService.swift
│   ├── Presentation/
│   │   ├── DeviceOrientation/
│   │   │   └── DeviceOrientation.swift
│   │   ├── DeviceOrientation/
│   │   │   ├── WeatherSkeletonView.swift
│   │   │   └── SkeletonView.swift
│   │   ├── LocationFeature/
│   │   │   └── LocationReducer.swift
│   │   ├── WeatherFeature/
│   │   │   ├── Views
│   │   │   │   ├── WeatherView.swift
│   │   │   │   ├── WeatherMetric.swift
│   │   │   │   ├── WeatherMetricsView.swift
│   │   │   │   ├── WeatherMainInfoView.swift
│   │   │   │   └── RetryButton.swift
│   │   │   ├── WeatherReducer.swift
│   │   │   └── WeatherViewModel.swift
│   │   └── StoriesFeature/
│   │       ├── StoriesReducer.swift
│   │       └── StoriesView.swift
│   └── Data/
│       ├── DTOs/
│       │   └── WeatherResponseDTO.swift
│       ├── Repositories/
│       │   ├── LocationRepository.swift
│       │   ├── WeatherRepository.swift
│       │   └── StoryRepository.swift
│       └── Services/
│           ├── LocationManager/
│           │   ├── LocationManagerDelegate.swift
│           │   └── LocationManager.swift
│           ├── MockServices/
│           │   ├── MockStoryService.swift
│           │   ├── MockLocationService.swift
│           │   └── MockWeatherService.swift
│           ├── LocationService.swift
│           ├── WeatherService.swift
│           └── StoryService.swift
├── Extention/
│   ├── UIDeviceExtension/
│   ├── DateExtension/
│   └── ColorExtension/

```

### Layers:
- **Core/Domain**: Business logic and core entities (e.g., `Weather`, `Story`).
- **Core/Presentation**: SwiftUI views and reducers for state management and UI rendering.
- **Core/Data**: Repositories and services for interacting with external APIs.

---

### How the Weather Data is Fetched and Displayed

The app's weather feature works as follows:

1. **Fetching Location**:
   - The app uses **CoreLocation** to fetch the user's current location.
   - If location permissions are denied, a user-friendly error message is displayed.

2. **Fetching Weather Data**:
   - The `WeatherService` interacts with the OpenWeatherMap API (or another weather API) to fetch weather data based on the user's latitude and longitude.

3. **Mapping and Business Logic**:
   - The raw weather data from the API is mapped into the `Weather` entity using a **Data Transfer Object (DTO)** (`WeatherResponseDTO`).
   - The `FetchWeatherUseCase` handles business logic, such as formatting temperature and handling errors.

4. **Displaying Weather Data**:
   - The `WeatherReducer` manages the state of the weather screen, including loading, success, and error states.
   - The weather information (e.g., temperature and city name) is displayed in the `WeatherView` using SwiftUI.

---

### How the Story View Was Implemented

The Instagram story-like view feature was implemented as follows:

1. **Fetching Images**:
   - The `StoryService` fetches a collection of random city-related images from the Unsplash API.
   - The images are mapped into `Story` entities for use in the UI.

2. **State Management**:
   - The `StoriesReducer` manages the state of the story view, including the current story, auto-progress status, and user interactions (e.g., swiping manually).

3. **UI Implementation**:
   - The `StoriesView` uses SwiftUI to render the story interface.
   - A progress bar at the top indicates the auto-progress status of each image.
   - Auto-progress is implemented with a timer that transitions to the next image every 3 seconds.
   - Users can manually swipe between images, which resets the timer.

4. **Dynamic Content**:
   - The use of the Unsplash API ensures that the story view displays fresh and visually appealing images each time it is accessed.

---

## Installation

### Prerequisites:
- iOS 18.0+
- Xcode 16+
- Swift Package Manager (SPM) supported.

### Steps:
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/OpenWeatherTCAApp.git
   cd OpenWeatherTCAApp
   ```
2. Open the project in Xcode:
   ```bash
   open OpenWeatherTCAApp.xcodeproj
   ```
3. Resolve dependencies using Swift Package Manager.
4. Build and run the app on your simulator or device.

---

## Dependencies

The app uses the following dependencies:
- [The Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture): For state management and modular architecture.
- [SwiftUI](https://developer.apple.com/xcode/swiftui/): For building the user interface.
- [CoreLocation](https://developer.apple.com/documentation/corelocation): To fetch the user's current location.
- [OpenWeatherMap API](https://openweathermap.org/api): To fetch weather data (or any other free weather API).
- [Unsplash API](https://unsplash.com/developers): To fetch random city-related images for the Instagram story-like view.

---

## Usage

### Weather Screen:
1. Upon app launch, the screen fetches the user's location and displays the current temperature and city name.
2. If there are any errors (e.g., location permissions denied), a user-friendly error message is shown.

### Instagram Story-Like View:
1. Navigate to this screen using the button on the Weather Screen.
2. View random city-related images fetched from the Unsplash API that auto-progress every 3 seconds.
3. Swipe manually to switch between images.
4. Observe the progress bar at the top for each image.

---

## Clean Architecture Principles

This app is built with the following principles in mind:
- **Separation of Concerns**: Each layer (Domain, Data, Presentation) has a single responsibility.
- **Dependency Injection**: Services and repositories are injected into use cases and reducers for flexibility and testability.
- **Modularity**: Features are split into reusable reducers and views.
- **SOLID Principles**: Ensures scalability and maintainability.
- **DRY (Don't Repeat Yourself)**: Shared logic (e.g., API calls, error handling) is centralized in reusable components.

---

## Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bug fix:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Description of changes"
   ```
4. Push your branch and create a pull request.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgements

- [Point-Free](https://www.pointfree.co/) for The Composable Architecture.
- [OpenWeatherMap](https://openweathermap.org/) for weather data.
- [Unsplash](https://unsplash.com/) for providing free high-quality images.
