Expense Tracker

Overview:

Expense Tracker is an iOS application developed with SwiftUI and Firebase. This app allows users to manage their finances effectively by tracking their expenses, viewing their current balance, and adding new transactions. Key features include real-time updates and user authentication.

Features:

	•	Splash Screen: Displays for 3 seconds with “Expense Tracker” and “By Shivansh,” then navigates based on user authentication.
	•	User Authentication: Sign-in functionality managed through Firebase Authentication.
	•	Home View: Shows the current balance and recent transactions with options to add new transactions.
	•	Real-time Updates: Uses Firestore to provide real-time updates on transactions.

 Screenshots:
 
<img width<img width="318" alt="Screenshot 2024-08-05 at 5 35 59 PM" src="https://github.com/user-attachments/assets/ec12b504-0751-4e8a-9ef9-c7df5932bace">
="353" alt="Screenshot 2024-08-05 at 5 35 12 PM" src="https://github.com/user-attachments/assets/527d8926-7fbf-41ce-a205-55c4a6e272cc">
<img w<img width="323" alt="Screenshot 2024-08-05 at 5 38 09 PM" src="https://github.com/user-attachments/assets/2c7938c5-5569-434e-b07a-ed8ab024c73d">
idth="347" alt="Screenshot 2024-08-05 at 5 36 36 PM" src="https://github.com/user-attachments/assets/4a167b9c-1431-4284-8c53-b531d695baa2">

Installation:
1.	Clone the Repository: git clone https://github.com/ShivanshPande19/expense-tracker.git
2.	Open the Project in Xcode:
  •	Open ExpenseTracker.xcodeproj in Xcode.
3.	Install Dependencies:
  •	Ensure CocoaPods is installed. If not, install it using: sudo gem install cocoapods
  •	Install project dependencies: pod install
4.	Configure Firebase:
	•	Create a Firebase project in the Firebase Console.
	•	Download the GoogleService-Info.plist file from Firebase and add it to your Xcode project.
	•	Enable Firebase Authentication and Firestore in the Firebase Console.
5.	Run the App:
	•	Open the .xcworkspace file in Xcode.
	•	Select your target device or simulator and run the app.

Usage:
•	Splash Screen: The app begins with a splash screen displaying the app’s title and creator. It automatically navigates to the appropriate view based on user authentication.
•	Home View: Displays the user’s current balance and a list of recent transactions. Users can add new transactions by tapping the “plus” button.
•	Transaction Management: View, add, and manage transactions through the home view interface.

Contributing:
Feel free to open issues or submit pull requests. Please adhere to the following guidelines for contributions:

	•	Fork the repository and clone it to your local machine.
	•	Create a new branch for each feature or bug fix.
	•	Ensure code follows the project’s style and passes all tests.
	•	Submit a pull request with a clear description of the changes.


