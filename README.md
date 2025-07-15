# Toy-Do 🧸

A beautiful Flutter application for managing your toy wishlist with seamless Firebase integration and GitHub image hosting.

## 📱 Features

- **📝 Wishlist Management**: Add, view, and organize your favorite toys
- **🖼️ Image Upload**: Upload toy images directly from your gallery
- **🔗 Product Links**: Store and access toy purchase links via integrated WebView
- **💰 Price Tracking**: Keep track of toy prices in Indian Rupees (₹)
- **✅ Purchase Status**: Mark toys as purchased/unpurchased with visual indicators
- **🗑️ Delete Functionality**: Remove toys from your wishlist
- **📱 Responsive Design**: Clean, modern UI with smooth animations
- **🌐 Web Integration**: Built-in WebView for seamless shopping experience

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.6.0 or higher)
- Dart SDK
- Firebase project setup
- GitHub repository for image hosting
- Android Studio/VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/toy-do.git
   cd toy-do
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Firebase Realtime Database
   - Add your `google-services.json` (Android) to `android/app/`
   - Add your `GoogleService-Info.plist` (iOS) to `ios/Runner/`

4. **Environment Configuration**
   Create a `.env` file in the root directory:
   ```env
   GITHUB_TOKEN=your_github_personal_access_token
   USERNAME=your_github_username
   REPO=your_image_repository_name
   FOLDER_PATH=images
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

## 🏗️ Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── screens/
│   └── home_screen.dart      # Main wishlist screen
└── services/
    └── imageWebViewPage.dart # WebView for product links
```

### Key Components

- **HomeScreen**: Main interface with dual view (wishlist/add toy)
- **ImageWebViewPage**: Integrated WebView for product links
- **Firebase Realtime Database**: Real-time data synchronization
- **GitHub API**: Image hosting and management

## 🔧 Configuration

### Firebase Realtime Database Rules
```json
{
  "rules": {
    "Toys": {
      ".read": true,
      ".write": true
    }
  }
}
```

### Data Structure
```json
{
  "Toys": {
    "toyId": {
      "toyName": "Toy Name",
      "toyPrice": "999",
      "toyLink": "https://example.com/toy",
      "toyImage": "https://raw.githubusercontent.com/user/repo/main/image.jpg",
      "toyPurchased": false
    }
  }
}
```

## 📸 Screenshots

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/2630b667-7309-4b12-b40c-fd533f592e6e" width="250" /></td>
    <td><img src="https://github.com/user-attachments/assets/36a39391-652e-4e47-a26f-38f7879309d7" width="250" /></td>
    <td><img src="https://github.com/user-attachments/assets/a55da923-4e60-4de7-ae78-c6235c498d10" width="250" /></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/0ce7c694-db8d-4bdb-ad8a-354f2614c7bf" width="250" /></td>
    <td><img src="https://github.com/user-attachments/assets/63e4d88f-1fbf-4b8e-94a6-6869a3cf1d5f" width="250" /></td>
    <td><img src="https://github.com/user-attachments/assets/8b7d1a85-0f0b-48aa-97a2-e014f3f82f4a" width="250" /></td>
  </tr>
</table>


---

**Made with ❤️ using Flutter**
