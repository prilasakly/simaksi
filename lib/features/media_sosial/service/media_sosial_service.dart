// lib/features/media_sosial/service/media_sosial_service.dart
// ============================================================
// SIMAKSI - Media Sosial Service
// Menyediakan data sosmed & kontak dari AppConfig
// ============================================================

import 'package:flutter/material.dart';
import '../../../core/config/app_config.dart';
import '../model/media_sosial_model.dart';

class MediaSosialService {
  MediaSosialService._();

  // ── Daftar akun media sosial ──────────────────────────────
  static List<MediaSosialItem> getSosialMedia() {
    return const [
      MediaSosialItem(
        platform: SosialPlatform.instagram,
        label: 'Instagram',
        handle: '@bpskabsukabumi',
        url: AppConfig.instagramUrl,
        icon: Icons.camera_alt_rounded,
        color: Color(0xFFFCE4EC),
        iconColor: Color(0xFFAD1457),
      ),
      MediaSosialItem(
        platform: SosialPlatform.twitter,
        label: 'X (Twitter)',
        handle: '@BPS_Sukabumi',
        url: AppConfig.twitterUrl,
        icon: Icons.alternate_email_rounded,
        color: Color(0xFFE3F2FD),
        iconColor: Color(0xFF1565C0),
      ),
      MediaSosialItem(
        platform: SosialPlatform.youtube,
        label: 'YouTube',
        handle: '@bpskabsukabumi',
        url: AppConfig.youtubeUrl,
        icon: Icons.play_circle_filled_rounded,
        color: Color(0xFFFFEBEE),
        iconColor: Color(0xFFC62828),
      ),
    ];
  }

  // ── Daftar info kontak ────────────────────────────────────
  static List<MediaSosialItem> getKontak() {
    return const [
      MediaSosialItem(
        platform: SosialPlatform.website,
        label: 'Website Resmi',
        handle: 'sukabumikab.bps.go.id',
        url: AppConfig.websiteUrl,
        icon: Icons.language_rounded,
        color: Color(0xFFE8EAF6),
        iconColor: Color(0xFF283593),
      ),
      MediaSosialItem(
        platform: SosialPlatform.email,
        label: 'Email',
        handle: AppConfig.email,
        url: 'mailto:${AppConfig.email}',
        icon: Icons.mail_rounded,
        color: Color(0xFFF3E5F5),
        iconColor: Color(0xFF6A1B9A),
      ),
      MediaSosialItem(
        platform: SosialPlatform.whatsapp,
        label: 'Telepon',
        handle: AppConfig.phone,
        url: 'tel:${AppConfig.phone}',
        icon: Icons.phone_rounded,
        color: Color(0xFFE8F5E9),
        iconColor: Color(0xFF2E7D32),
      ),
      MediaSosialItem(
        platform: SosialPlatform.maps,
        label: 'Lokasi',
        handle: 'Lihat di Google Maps',
        url: AppConfig.googleMapsUrl,
        icon: Icons.location_on_rounded,
        color: Color(0xFFFFF3E0),
        iconColor: Color(0xFFE65100),
      ),
    ];
  }
}