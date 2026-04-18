// lib/core/asset_patch/asset_patch_service.dart
// ============================================================
// SIMAKSI - Asset Patch / Dynamic Delivery Service
// Update konten (gambar, teks statis, dsb) tanpa rilis baru
// ============================================================

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../config/app_config.dart';

/// Model untuk manifest patch
class PatchManifest {
  final int version;
  final List<PatchAsset> assets;

  const PatchManifest({required this.version, required this.assets});

  factory PatchManifest.fromJson(Map<String, dynamic> json) {
    return PatchManifest(
      version: json['version'] as int,
      assets: (json['assets'] as List)
          .map((e) => PatchAsset.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PatchAsset {
  final String key; // e.g. "banner_1.jpg"
  final String url; // download URL
  final String checksum; // MD5/SHA for verification
  final String type; // image | json | text

  const PatchAsset({
    required this.key,
    required this.url,
    required this.checksum,
    required this.type,
  });

  factory PatchAsset.fromJson(Map<String, dynamic> json) {
    return PatchAsset(
      key: json['key'] as String,
      url: json['url'] as String,
      checksum: json['checksum'] as String,
      type: json['type'] as String,
    );
  }
}

class AssetPatchService {
  AssetPatchService._();
  static final AssetPatchService instance = AssetPatchService._();

  final Dio _dio = Dio();
  late Directory _patchDir;
  bool _initialized = false;

  // ── Initialize ─────────────────────────────────────────────
  Future<void> initialize() async {
    if (_initialized) return;
    final appDir = await getApplicationDocumentsDirectory();
    _patchDir = Directory('${appDir.path}/patches');
    if (!await _patchDir.exists()) await _patchDir.create(recursive: true);
    _initialized = true;
  }

  // ── Check & Apply Patch ────────────────────────────────────
  Future<bool> checkAndApplyPatch() async {
    try {
      await initialize();
      final prefs = await SharedPreferences.getInstance();
      final localVersion = prefs.getInt(AppConfig.assetPatchVersionKey) ?? 0;

      // Download manifest
      final response = await _dio.get(
        '${AppConfig.assetPatchBaseUrl}/manifest.json',
        options: Options(receiveTimeout: const Duration(seconds: 10)),
      );
      final manifest = PatchManifest.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (manifest.version <= localVersion) return false;

      // Download & save each asset
      for (final asset in manifest.assets) {
        await _downloadAsset(asset);
      }

      // Update version
      await prefs.setInt(AppConfig.assetPatchVersionKey, manifest.version);
      return true;
    } catch (e) {
      // Silently fail — use existing assets
      return false;
    }
  }

  Future<void> _downloadAsset(PatchAsset asset) async {
    final file = File('${_patchDir.path}/${asset.key}');
    await _dio.download(asset.url, file.path);
  }

  // ── Get Asset ──────────────────────────────────────────────
  /// Coba ambil dari patch dulu, fallback ke bundle assets
  Future<String?> getImagePath(String key) async {
    await initialize();
    final patched = File('${_patchDir.path}/$key');
    if (await patched.exists()) return patched.path;
    return null; // fallback ke assets bundled
  }

  Future<String?> getJsonContent(String key) async {
    await initialize();
    final patched = File('${_patchDir.path}/$key');
    if (await patched.exists()) {
      return await patched.readAsString();
    }
    // Fallback ke asset bundled
    try {
      return await rootBundle.loadString('assets/patches/$key');
    } catch (_) {
      return null;
    }
  }

  // ── Check if patch exists ──────────────────────────────────
  Future<bool> hasPatch(String key) async {
    await initialize();
    return File('${_patchDir.path}/$key').exists();
  }

  // ── Clear all patches (untuk reset) ───────────────────────
  Future<void> clearPatches() async {
    await initialize();
    if (await _patchDir.exists()) {
      await _patchDir.delete(recursive: true);
      await _patchDir.create(recursive: true);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.assetPatchVersionKey);
  }
}
