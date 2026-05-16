class UpdateInfo {
  final int latestVersionCode;
  final String latestVersionName;
  final String downloadUrl;
  final String? releaseNotes;
  final bool forceUpdate;

  const UpdateInfo({
    required this.latestVersionCode,
    required this.latestVersionName,
    required this.downloadUrl,
    this.releaseNotes,
    this.forceUpdate = false,
  });

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      latestVersionCode: json['version_code'] as int,
      latestVersionName: json['version_name'] as String,
      downloadUrl: json['download_url'] as String,
      releaseNotes: json['release_notes'] as String?,
      forceUpdate: json['force_update'] as bool? ?? false,
    );
  }
}
