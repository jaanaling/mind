enum RouteValue {
  splash(path: '/'),
  mindMap(path: '/mind_map'),
  mindMapCreate(path: 'mind_map_create'),
  mindMapEdit(path: 'mind_map_edit'),
  privicy(
    path: '/privicy',
  ),
  coreScreen(
    path: '/coreScreen',
  ),
  unknown(path: '');

  final String path;

  const RouteValue({
    required this.path,
  });
}
