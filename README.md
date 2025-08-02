# E-Store Flutter Project

## Overview

E-Store is a Flutter Web-based e-commerce application designed to provide a smooth and responsive shopping experience on the web. The app allows for product browsing, cart management, and order checkout, with all data being dynamically loaded from local variables rather than external databases. This means that product information, cart contents, and order details are stored locally within the app, providing a simplified and fast experience. The app is fully integrated with Firebase for hosting, ensuring smooth deployment and access across devices. Built using modern architectural patterns like BLoC and repositories, E-Store is modular, easy to extend, and maintain. This open-source project aims to help developers learn and contribute to building a complete e-commerce solution using Flutter Web, with a focus on local data management.

---

## Table of Contents

1. [Project Structure Overview](#project-structure-overview)
2. [Clone the Project](#clone-the-project)
3. [Set Flutter Version](#set-flutter-version)
4. [Pre-Run Setup](#pre-run-setup)
5. [How to Use .env File for Environment Variables](#how-to-use-env-file-for-environment-variables)
6. [Create and Update Flutter Logo for Web](#create-and-update-flutter-logo-for-web)
7. [Change Project Name in Flutter Web](#change-project-name-in-flutter-web)
8. [Replace Firebase Options for Hosting](#replace-firebase-options-for-hosting)
9. [How to Add New Screens or Features](#how-to-add-new-screens-or-features)
10. [Working with Repositories and BLoC](#working-with-repositories-and-bloc)
11. [Contribution Guidelines](#contribution-guidelines)
12. [Conclusion and Next Steps](#conclusion-and-next-steps)

---

### Project Structure Overview

The project follows a modular structure with the following key directories and files:

- **lib/**: This directory contains the main app code.
  - **blocs/**: Contains the BLoC (Business Logic Components) files for managing app state.
  - **models/**: Contains the data models for the app, such as cart, product, and order.
  - **repositories/**: Responsible for managing data sources (e.g., APIs, Firebase).
  - **routes/**: Contains the routing logic for the app using the AutoRoute package.
  - **screens/**: The UI components/screens of the app.
  - **services/**: Service layer to manage business logic like Stripe, Firebase, etc.
  - **utils/**: Contains utility files for various helper functions.
  - **widgets/**: Contains reusable UI components.
- **test/**: Contains unit and widget tests for the app.
- **web/**: Contains the files specific to the Flutter Web build, including icons and manifest configurations.

---

### Clone the Project

To clone the project:

1. Open your terminal or command prompt.
2. Run the following command to clone the repository:

   ```bash
   git clone https://github.com/MuhammadSohaib-pro/E-Store
   ```

3. Navigate into the project directory:
   ```bash
   cd e-store
   ```

---

### **Set Flutter Version**

To ensure compatibility with the project, use Flutter version 3.29.3. Follow these steps to install the correct version:

1. Ensure you have [Flutter installed](https://flutter.dev/docs/get-started/install).
2. In the terminal, run the following to switch to version 3.29.3:

   ```bash
   flutter version 3.29.3
   ```

---

### **Pre-Run Setup**

Before running the project, ensure you've completed the following steps:

1. **Set Up Environment Variables:**

   - Copy the `.env.local` file to `.env` if not already present.
   - Uncomment the assets section in the `.env` file as required.
   - Add your API keys, Firebase configurations, and other environment-specific values in the `.env` file.

2. **Install Dependencies:**
   Run the following command to fetch all necessary dependencies:

   ```bash
   flutter pub get
   ```

3. **Before Running the project:**
   Make sure to search all to-dos and apply all those changings
   ```
   TODO::
   ```
   Search this word in whole project and update all changes.
4. **Run the Project:**
   After completing the setup, run the project:
   ```bash
   flutter run
   ```

---

### How to Use .env File for Environment Variables

1. **Create the .env File:**

   - Rename `.env.local` to `.env` in the root directory.
   - Add your environment variables such as API keys, Firebase configuration, etc.

2. **Access Variables in the Code:**

   - Use the `flutter_dotenv` package to load the `.env` file. This is already integrated into `main.dart`.
   - Access variables like this:

     ```dart
     String apiKey = dotenv.get('API_KEY');
     ```

3. **Important:**
   - Ensure to add your `.env` file to `.gitignore` to avoid sharing sensitive information.

---

### **Create and Update Flutter Logo for Web**

To update the Flutter logo for the web:

1. Visit the [Real Favicon Generator](https://realfavicongenerator.net/).
2. Upload your new logo (preferably a square image, ideally 512x512 px).
3. Customize the favicon settings as per your requirements.
4. Download the generated files and place them in the `web/icons` folder.
5. Ensure that the `manifest.json` and other necessary files are properly configured with the new icons. Icons "src": "value" is updated properly.

   ```
   {
       ..
       ..
       "icons": [
           {
               "src": "icons/Icon-192.png",
               "sizes": "192x192",
               "type": "image/png"
           },
           {
               "src": "icons/Icon-512.png",
               "sizes": "512x512",
               "type": "image/png"
           },
           {
               "src": "icons/Icon-maskable-192.png",
               "sizes": "192x192",
               "type": "image/png",
               "purpose": "maskable"
           },
           {
               "src": "icons/Icon-maskable-512.png",
               "sizes": "512x512",
               "type": "image/png",
               "purpose": "maskable"
           }
       ]
   }
   ```

---

### Change Project Name in Flutter Web

To change the project name for Flutter Web:

1. Open the `web/index.html` file.
2. Locate the `<title>` tag and update the name to your desired project name:

   ```html
   <title>Your New Project Name</title>
   ```

3. You can also update the `manifest.json` and `main.dart` for a consistent experience across the app and web.
   `manifest.json`

   ```
   {
       "name": "E-Store",
       "short_name": "E-Store",
       ...
   }
   ```

   `main.dart`

   ```
   MaterialApp.router(
       ...
       title: 'E-Store',
       ...
   )
   ```

---

### **Replace Firebase Options for Hosting**

Since Firebase is used only for hosting:

1. Replace the `firebase_options.dart` file in the `lib` directory with your Firebase configuration.
2. Ensure that you have the correct Firebase Hosting configurations in the Firebase Console.
3. To deploy the project on Firebase Hosting:

   - Run the following command:

     ```bash
     firebase deploy
     ```

4. Ensure that the Firebase Hosting configuration in `firebase.json` is set correctly to point to the build output.

---

### **How to Add New Screens or Features**

To add a new screen or feature to the app, follow these steps:

1. **Create a New Screen:**

   - In the `lib/screens/` directory, create a new folder for your feature (e.g., `new_feature/`).
   - Add the necessary Dart files inside this folder, including the main screen and any component files (e.g., `new_feature_screen.dart`).

2. **Add the Screen to the Router:**

   - Open `lib/routes/app_router.dart`.
   - Add a new route for the screen:

     ```dart
     AutoRoute(path: '/new-feature', page: NewFeatureRoute.page),
     ```

3. **Create BLoC for Managing State:**

   - Inside the `lib/blocs/` directory, create a new folder for your feature (e.g., `new_feature/`).
   - Implement the BLoC classes (event, state, bloc) to handle the business logic.

4. **Update the UI:**
   - Create reusable widgets in the `lib/widgets/` directory to manage the UI components of the screen.

---

### Working with Repositories and BLoC

This project follows the BLoC pattern for state management. Each feature has its own repository and BLoC.

1. **Repositories:**

   - Repositories are responsible for fetching data from different sources (Firebase, API, local storage).
   - They are located in the `lib/repositories/` folder, such as `cart_repository.dart`, `products_repository.dart`, etc.

2. **BLoC:**

   - Each screen or feature has a corresponding BLoC located in the `lib/blocs/` folder.
   - For example, the cart BLoC manages the state for the shopping cart, handling actions like adding or removing items.

   To add a new BLoC:

   - Create an event, state, and bloc file for the new feature.
   - Inject the BLoC into the widget tree using `BlocProvider` or `MultiBlocProvider`.

3. **Using a Repository in a BLoC:**

   - Repositories are injected into the BLoC via the constructor. For example:

     ```dart
     class CartBloc extends Bloc<CartEvent, CartState> {
       final CartRepository cartRepository;

       final CartRepository _cartRepository;

        CartBloc({required CartRepository cartRepository})
        : _cartRepository = cartRepository,
        super(CartInitial()) {
            on<CartLoadRequested>(_onCartLoadRequested);
            ...
        }

        Future<void> _onCartLoadRequested(
            CartLoadRequested event,
            Emitter<CartState> emit,
        ) async {
          emit(CartLoading());
          try {
            final items = await _cartRepository.getCartItems();
            final cartState = _calculateCartTotals(items);
            emit(cartState);
          } catch (e) {
            emit(CartError(message: 'Failed to load cart: ${e.toString()}'));
          }
        }
     }
     ```

4. **Accessing Data in the UI:**

   - In the UI layer, use `BlocBuilder` or `BlocListener` to listen to BLoC states and update the UI accordingly.

   Example:

   ```dart
   BlocBuilder<CartBloc, CartState>(
     builder: (context, state) {
       if (state is CartLoaded) {
         return Text('Items in cart: ${state.items.length}');
       }
       return CircularProgressIndicator();
     },
   );
   ```

   ***

### Contribution Guidelines

We welcome contributions from all developers. Please fork the repository, make your changes, and submit a pull request. When contributing, please ensure that:

- Your code follows the project's coding standards.
- You add tests for new features or bug fixes.
- The README is updated accordingly if any changes impact the setup or usage.

### Conclusion and Next Steps

This project is designed to be easily extendable and modular. You can add more features by following the instructions for creating new screens, BLoCs, and updating the routing and repositories.

Next steps for contributors:

- Add new features or fix existing bugs.
- Improve the UI for mobile and web.
- Make contributions to documentation.

Feel free to fork this project, submit issues, and create pull requests. Contributions are always welcome!
