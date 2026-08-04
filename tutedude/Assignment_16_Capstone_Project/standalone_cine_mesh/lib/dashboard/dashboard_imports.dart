// lib/dashboard/dashboard_imports.dart

// Core Framework and Platform Libraries
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:url_launcher/url_launcher.dart';
export 'dart:convert';

// Project Component Layer Overlays - Absolute Mapping Matrix
export 'package:standalone_cine_mesh/components/history_drawer.dart';
export 'package:standalone_cine_mesh/components/favorites_drawer.dart';
export 'package:standalone_cine_mesh/components/watch_later_drawer.dart';
export 'package:standalone_cine_mesh/components/theme_drawer.dart';
export 'package:standalone_cine_mesh/components/ui_dialogs.dart';

// Services Layer Utilities
export 'package:standalone_cine_mesh/services/network_service.dart';
export 'package:standalone_cine_mesh/services/crypto_service.dart';
export 'package:standalone_cine_mesh/services/notification_service.dart';
export 'package:standalone_cine_mesh/services/kernel_validator_service.dart';

// Core Framework Configurations and App Panels
export 'package:standalone_cine_mesh/config/theme_config.dart';
export 'package:standalone_cine_mesh/config/firebase_config.dart';
export 'package:standalone_cine_mesh/chat_panel.dart';
export 'package:standalone_cine_mesh/main.dart';

// Internal Subfolder Feature Handlers - Explicit Absolute Export
export 'package:standalone_cine_mesh/dashboard/dashboard_actions.dart';
