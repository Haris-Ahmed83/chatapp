import '../imports/imports.dart';

class UrlLauncherService {
  UrlLauncherService._();
  static final UrlLauncherService instance = UrlLauncherService._();

  FutureEither<void> launch(String url, {LaunchMode? mode}) async {
    return runTask(() async {
      final formattedUrl = _formatUrl(url);
      final uri = Uri.parse(formattedUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: mode ?? LaunchMode.externalApplication,
        );
      } else {
        throw Exception('Could not launch url: $formattedUrl');
      }
    });
  }

  String _formatUrl(String url) {
    if (url.isValidUrl && !url.contains('://')) {
      return 'https://$url';
    }
    if (url.isValidPhoneNumber) {
      if (kIsWeb) return 'https://wa.me/$url';
      return 'whatsapp://send?phone=$url';
    }
    return url;
  }
}
