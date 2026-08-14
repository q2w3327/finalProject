# Final Project - Soccer Management System

This is a Flutter application developed for the CST2335 Graphical Interface Programming course. The application provides a modular platform for managing soccer-related data, including players, teams, games, and stadiums.

## Features - Soccer Team List Page
The **Soccer Team List** section allows users to manage soccer teams with the following capabilities:
- **CRUD Operations**: Add, view, update, and delete teams.
- **Data Persistence**: Uses a Floor (SQLite) database to store team information.
- **Responsive Design**: Implements a Master-Detail pattern that adapts to Phone, Tablet, and Desktop screens.
- **Secure Storage**: Uses `EncryptedSharedPreferences` to save and restore the most recent team entry.
- **Localization**: Supports multiple languages (English US/UK and French).
- **Professional UI**: Clean Material 3 interface with helpful notifications (Snackbars and Dialogs).

## Requirements Satisfied
1.  **ListView**: Displays all teams stored in the database.
2.  **Insertion Interface**: Form with TextFields and a Submit button.
3.  **Database Storage**: Floor database ensures data persists across restarts.
4.  **Master-Detail View**: Adapts layout based on screen width.
5.  **Notifications**: Uses Snackbars for success messages and AlertDialogs for errors and instructions.
6.  **Encrypted Storage**: Securely stores temporary data for the "Copy Previous" feature.
7.  **ActionBar**: Features a help icon with usage instructions.
8.  **Multi-language Support**: Fully localized into English and French.
9.  **GitHub Integration**: Developed and merged using proper branching and pull request practices.
10. **Professional Layout**: GUI elements are properly aligned and laid out.
11. **Documentation**: Code is documented with Dartdoc comments, and generated documentation is available in the `Dartdoc` folder.

## Getting Started
To run the project locally:
1.  Clone the repository.
2.  Run `flutter pub get` to install dependencies.
3.  Run `dart run build_runner build` to generate database files.
4.  Run the app using `flutter run`.

## Team Members
- Pavel (Soccer Team List Page)
- Collaborators (Soccer Player Page, etc.)
