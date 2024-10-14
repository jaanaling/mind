String applyMacros(String targetUrl, Map<String, dynamic> params) {
  params.forEach((key, value) {
    targetUrl = targetUrl.replaceAll('{$key}', value.toString());
  });

  targetUrl = targetUrl.replaceAllMapped(RegExp(r'\{[^}]*\}'), (match) {
    return '';
  });

  targetUrl = targetUrl.replaceAll(RegExp(r'\s'), '');

  return targetUrl;
}
