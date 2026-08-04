importScripts('https://gstatic.com');
importScripts('https://gstatic.com');

// FIXED: Enter your primary Project ID string here once so the background thread can target your REST endpoint.
const PROJECT_ID = "your-project-id";

// Public, unauthenticated Google REST API endpoint path matching your Firestore document structural path
const configUrl = `https://googleapis.com{PROJECT_ID}/databases/(default)/documents/system_config/web_firebase_keys`;

fetch(configUrl)
  .then(response => {
    if (!response.ok) {
      throw new Error(`REST API HTTP network failure: ${response.status}`);
    }
    return response.json();
  })
  .then(data => {
    const fields = data.fields;

    // Auto-Fetch Processor: Maps the Firestore JSON response payload map dynamically into memory
    const firebaseConfig = {
      apiKey: fields.apiKey.stringValue,
      authDomain: fields.authDomain.stringValue,
      projectId: fields.projectId.stringValue,
      storageBucket: fields.storageBucket.stringValue,
      messagingSenderId: fields.messagingSenderId.stringValue,
      appId: fields.appId.stringValue
    };

    // Initialize Firebase dynamically inside the background browser thread
    firebase.initializeApp(firebaseConfig);

    if (firebase.messaging.isSupported()) {
      const messaging = firebase.messaging();

      messaging.onBackgroundMessage((payload) => {
        console.log("Background message captured: ", payload);
        const title = payload.notification?.title || "Workspace Update";
        const options = {
          body: payload.notification?.body || "A collaborative state change occurred.",
          icon: "/icons/Icon-192.png"
        };
        return self.registration.showNotification(title, options);
      });
    }
  })
  .catch(err => console.error("⚠️ Background Service Worker Config Fetch Error: ", err));
