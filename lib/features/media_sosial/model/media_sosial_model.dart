// lib/features/media_sosial/model/media_sosial_model.dart
// ============================================================
// SIMAKSI - Media Sosial Model
// ============================================================

import 'package:flutter/material.dart';

enum SosialPlatform {
  instagram,
  twitter,
  youtube,
  website,
  email,
  whatsapp,
  maps,
}

class MediaSosialItem {
  final SosialPlatform platform;
  final String label;
  final String handle;
  final String url;
  final IconData icon;
  final Color color;
  final Color iconColor;

  const MediaSosialItem({
    required this.platform,
    required this.label,
    required this.handle,
    required this.url,
    required this.icon,
    required this.color,
    required this.iconColor,
  });
}