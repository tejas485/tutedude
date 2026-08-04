// lib/models/anomaly_report.dart
class AnomalyReport {
  final bool isHealthy;
  final int criticalErrorsCount;
  final List<String> errorSnippets;
  final String diagnosticSummary;

  const AnomalyReport({
    required this.isHealthy,
    required this.criticalErrorsCount,
    required this.errorSnippets,
    required this.diagnosticSummary,
  });
}
