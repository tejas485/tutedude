const admin = require('firebase-admin');
const serviceAccount = require('./service-account.json');

// Initialize the Google Administrative SDK loop
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// FIXED: Copy and paste your operational NPM config text parameters directly into this javascript object matrix
const npmFirebaseConfig = {
  apiKey: "AIzaSyA8iz0wu4mAi-m9n4IUqbx7YInWiMQEooM",
  authDomain: "todo-is-cool.firebaseapp.com",
  projectId: "todo-is-cool",
  storageBucket: "todo-is-cool.firebasestorage.app",
  messagingSenderId: "251038220230",
  appId: "1:251038220230:web:d73a04c085fcbcc7953cc7"
};

async function pushKeysToFirestore() {
  console.log("🚀 Initializing automated cloud key synchronization stream...");

  try {
    // Write directly into the strict document mapping required by our background Service Worker script
    await db.collection('system_config').doc('web_firebase_keys').set(npmFirebaseConfig);

    console.log("🏁 Success! Infrastructure credentials have been successfully published to Firestore.");
    process.exit(0);
  } catch (error) {
    console.error("❌ Critical: An error occurred during database writing transit: ", error);
    process.exit(1);
  }
}

pushKeysToFirestore();
