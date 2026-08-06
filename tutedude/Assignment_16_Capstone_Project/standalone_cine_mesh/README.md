# Standalone Cine Mesh - Capstone Project
## Pre-requisites
The 10GB Firebase C++ SDK is excluded from Git to keep the repo light.
Please download it from this Drive link and extract it inside the 'native_dependencies' folder before building:
[Download Firebase C++ SDK here](YOUR_PUBLIC_GOOGLE_DRIVE_LINK_HERE)

# 🍿 CineMesh Lounge

A decentralized, AI-driven movie recommendation application designed to leverage secure cloud compute notebooks, multi-vector relational databases, and platform-agnostic client interfaces. CineMesh implements a custom dual-platform split architecture to deliver real-time, low-latency semantic movie discovery on both mobile and web builds without compromising infrastructure security.

---

## 🛠️ Architecture Tech Stack

* **Frontend Framework:** Flutter (Dart 3.x Engine Layout)
* **Backend Database & Storage:** Cloud Firestore (NoSQL User Configuration Metadata Profiles)
* **Authentication Engine:** Firebase Authentication (Secure OAuth State Validation)
* **Network & Crypto Pipelines:** HTTP Connection Pooling, AES Payload Encapsulation Protocol
* **Remote Compute Host Engine:** Kaggle Notebook Kernel Cluster Environments (Python FastAPI Web Server Sub-Funnels)

---

## 🗺️ System Architecture & Workflow Diagram

```text
========================================================================================================
                              CINEMESH LOUNGE - HYBRID PLATFORM ARCHITECTURE
========================================================================================================

    [ FLUTTER USER INTERFACE LAYER ]
      ├── lib/main.dart (Application Entry & WidgetsBindingObserver Lifecycle Hook)
      ├── lib/chat_panel.dart (Chat Bubbles, Scroll Controllers & Message View Nodes)
      └── lib/recommendation_grid.dart (Horizontal Movie Carousel Slider & Clamped Animations)
                 │
                 │ ─── (Taps Yellow Header Button) ───► DashboardActionsHandler.pasteAndApplyKaggleTunnel()
                 │                                        │
                 ├── [ IF kIsWeb == true ] ───────────────┼──► Opens WorkspaceSessionScreen (Direct Guide)
                 └── [ IF kIsWeb == false ] ──────────────┘──► Opens KaggleLinkDialog (.json File Picker)
                 │
                 ▼ (Dispatches User Chat Messages / Token Validation Handshakes)
    [ CORE APPLICATION UTILITY SERVICES ]
      ├── lib/services/network_service.dart (Persistent Timer.periodic 35s Keep-Alive Loop Gateway)
      ├── lib/services/crypto_service.dart (AES Client Packet Encryption & Server Decryption Matrix)
      ├── lib/services/notification_service.dart (Headless Free-Form Android Notification Actions)
      └── lib/services/kernel_validator_service.dart (Regex Telemetry Landmark Log Stream Sweeper)
                 │
                 ▼ (Forwards Token Payloads & Secure JSON Authorization Bundles)
    [ BACKEND DEPLOYMENT & DECENTRALIZED DATA PROXY ]
      ├── (Local Socket HTTP / TCP Calls) ──► Native Mobile App Build (Bypasses Browser CORS Completely)
      └── (Serverless Cloud Proxy Edge) ────► Flutter Web App Build (Cloudflare Worker / Firebase Function)
                 │                                │
                 │                                └──► Injects Access-Control-Allow-Origin Headers
                 ▼                                     Eliminating Same-Origin Violations
    [ REMOTE KAGGLE CLOUD COMPUTE ENGINE ]
      ├── api/v1/kernels/push (Node.js/HTTP Basic Auth Multi-Part Form Asset Allocation)
      └── api/v1/kernels/output (Asynchronous Python Container Stdout Telemetry Polling)
                 │
                 ▼ (Allocates CUDA Nodes & Launches FastAPI Web Server Frame inside Notebook Cluster)
    [ LOCAL TUNNEL WORKSPACE CONNECTOR ]
         Captures 'https://loca.lt' / 'https://*.trycloudflare.com' Forwarding URL String 
         via Scraper and Passes Proxy Stream Back Downstream to Complete Chat Pipeline
========================================================================================================
```

## 📂 Directory Routing Reference Manual

This directory roadmap explains where each core function lives, what it does, and how it interacts with the rest of the application ecosystem.

### 1. Application Orchestrator & Lifecycle
* **Directory Path:** `lib/main.dart`
* **Core Functions & Classes:**
  * `void main()`: Unlocks low-level native engine binary bindings via `WidgetsFlutterBinding.ensureInitialized()`, triggers your `Firebase.initializeApp()` profile configurations, and invokes asset caching resumption loops.
  * `_CineMeshAppLifecycleOrchestratorState`: Extends `WidgetsBindingObserver` to listen to global operating system signals.
  * `didChangeAppLifecycleState(AppLifecycleState state)`: Intercepts `AppLifecycleState.detached` and `AppLifecycleState.hidden` events. The instant a user swipes your mobile app away or puts it in the background, it runs `KaggleAutomationProvisioner.terminateActiveKaggleClusterLifecycle()` to cut background battery drain.
  * `AuthRouterSwitch`: Evaluates the runtime authorization state via `FirebaseAuth.instance.authStateChanges()` to switch between user states or mount the login module.

### 2. User Dashboard Interface Layer
* **Directory Path:** `lib/chat_panel.dart`
* **Core Functions & Classes:**
  * `_MeshChatPanelState`: Hosts the text box view framework and keeps track of terminal stream message heights.
  * `_scrollToBottom()`: Schedules rendering tick callbacks inside `WidgetsBinding.instance.addPostFrameCallback()` to keep the chat viewport pinned to the latest AI response bubble.
  * `ListView.builder()`: Maps individual chat role variables (`role == "gemini"` vs `"user"`), changes speech bubble background alignment, and embeds instances of `MeshRecommendationGrid` directly inside the message list if movie payloads are returned.

### 3. Optimized Layout Components
* **Directory Path:** `lib/recommendation_grid.dart`
* **Core Functions & Classes:**
  * `_MeshRecommendationGridState`: Renders a high-performance horizontal movie selection slider using explicit layout size boundaries (`itemExtent: strictItemExtent`) to keep memory allocation spikes low.
  * `_AnimatedMovieCardWrapperState`: Coordinates staggered fade-in animations for your movie banners. Uses `widget.index.clamp(0, 5)` to prevent infinite duration lag accumulation if the AI returns dozens of recommendations at once.

### 4. The Cross-Platform Branch Handler
* **Directory Path:** `lib/dashboard/dashboard_actions.dart`
* **Core Functions & Classes:**
  * `pasteAndApplyKaggleTunnel(BuildContext context, VoidCallback onUpdate)`: Manages the platform architecture split using a pure compilation condition (`kIsWeb`). On Web, it skips the file picker and routes directly to guidelines. On Android/iOS, it loads the native `KaggleLinkDialog` overlay layout to accept file system parameters.
  * `routeMovieInteraction()`: Decodes contextual taps from your movie cards to add items to a local list or sync them with Firestore via `FieldValue.arrayUnion()`.

### 5. Network Interface & Remote Proxy Channel
* **Directory Path:** `lib/services/network_service.dart`
* **Core Functions & Classes:**
  * `startTunnelKeepAliveLoop()`: Initializes an ongoing background loop timer via `Timer.periodic(Duration(seconds: 35))` to perform HTTP requests back to your serverless endpoint. This background activity mimics an active session, keeping the remote Kaggle compute instance warm and active.
  * `dispatchSecurePayload(String textQuery, String userUid)`: Encrypts chat text using AES parameters via `MeshCryptoService`, appends active Firebase authorization metadata tokens (`currentUser?.getIdToken(true)`), and transmits the request packet upstream.

### 6. Live Telemetry Stream Scraper
* **Directory Path:** `lib/services/kernel_validator_service.dart`
* **Core Functions & Classes:**
  * `inspectAndVerifyLogs()`: Connects to the Kaggle notebook standard output streams via secure access parameters. Converts lists of dynamic string values into flat lowercase blocks to scan for server milestones like `"server pipeline active"` or hardware compilation dropouts like `"cuda out of memory"`.

### 7. Headless Device Push Notification Manager
* **Directory Path:** `lib/services/notification_service.dart`
* **Core Functions & Classes:**
  * `initializeUnifiedNotificationPipeline()`: Uses `_fcm.getToken()` to save mobile push notification configurations directly inside your user records. Registers the `cinemesh_interactive_channel` channel with the Android operating system to prevent app crashes.
  * `displayLocalRetentionPing()`: Creates advanced, interactive notification actions (`AndroidNotificationAction` with `allowFreeFormInput: true` and `showsUserInterface: false`). This lets mobile users type replies into the system notification tray, which are handled in the background without needing to open the full app layout window.

---

## 🛠️ Low-RAM Offline Development Workflow Loop

Use this exact command line loop to build, run, and hot-reload changes without triggering network timeouts, `Metaspace` errors, or high RAM computer crashes:

```powershell
# 1. Route temporary paths and your cache registry directly to your D drive
\$env:TMP="D:\Temp"
\$env:TEMP="D:\Temp"
\$env:GRADLE_USER_HOME="D:\.gradle_cache_root"

# 2. Compile your new code modifications headlessly into a fresh APK bundle
flutter build apk --debug --android-skip-build-dependency-validation --no-pub

# 3. Push the compiled APK file over USB and start your lightweight live log stream
flutter run --debug --use-application-binary="build/outputs/flutter-apk/app-debug.apk" -d Device_Name
```

