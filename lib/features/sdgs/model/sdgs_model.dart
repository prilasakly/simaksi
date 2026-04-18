// lib/models/sdgs_model.dart
// ============================================================
// SIMAKSI - SDGs Model
// Model untuk data SDGs dari BPS API
// ============================================================

import 'package:simaksi/core/utils/clean_html.dart' show CleanHTML;

class SdgsModel {
  final String sdgsGoal;
  final String sdgsGoalName;
  final String sdgsId;
  final int varId;
  final String title;
  final int subId;
  final String subName;
  final String def;
  final String notes;
  final int vertical;
  final String unit;
  final int graphId;
  final String graphName;
  final String? metaActivity;
  final String? metaVar;

  const SdgsModel({
    required this.sdgsGoal,
    required this.sdgsGoalName,
    required this.sdgsId,
    required this.varId,
    required this.title,
    required this.subId,
    required this.subName,
    required this.def,
    required this.notes,
    required this.vertical,
    required this.unit,
    required this.graphId,
    required this.graphName,
    this.metaActivity,
    this.metaVar,
  });

  /// Nomor goal sebagai integer (1-17)
  int get goalNumber {
    final parts = sdgsGoal.replaceAll('sdgs_', '');
    return int.tryParse(parts) ?? 0;
  }

  String get cleanNotes => notes.cleanHtml();
  
  factory SdgsModel.fromJson(Map<String, dynamic> json) {
    return SdgsModel(
      sdgsGoal: json['sdgs_goal']?.toString() ?? '',
      sdgsGoalName: json['sdgs_goal_name']?.toString() ?? '',
      sdgsId: json['sdgs_id']?.toString() ?? '',
      varId: json['var_id'] is int
          ? json['var_id']
          : int.tryParse(json['var_id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      subId: json['sub_id'] is int
          ? json['sub_id']
          : int.tryParse(json['sub_id']?.toString() ?? '0') ?? 0,
      subName: json['sub_name']?.toString() ?? '',
      def: json['def']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      vertical: json['vertical'] is int
          ? json['vertical']
          : int.tryParse(json['vertical']?.toString() ?? '0') ?? 0,
      unit: json['unit']?.toString() ?? '',
      graphId: json['graph_id'] is int
          ? json['graph_id']
          : int.tryParse(json['graph_id']?.toString() ?? '0') ?? 0,
      graphName: json['graph_name']?.toString() ?? '',
      metaActivity: json['meta_activity']?.toString(),
      metaVar: json['meta_var']?.toString(),
    );
  }
}
