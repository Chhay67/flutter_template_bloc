import 'package:go_router/go_router.dart';

const String fromQueryParam = 'from';

String encodeFrom(GoRouterState state) {
  return Uri.encodeComponent(state.uri.toString());
}

String loginLocationWithFrom({
  required String loginPath,
  required GoRouterState state,
  String queryParam = fromQueryParam,
}) {
  return Uri(
    path: loginPath,
    queryParameters: {
      queryParam: state.uri.toString(),
    },
  ).toString();
}

String? safeFrom({
  required GoRouterState state,
  Set<String> allowedRedirectPaths = const {},
  Set<String> blockedRedirectPaths = const {},
  String queryParam = fromQueryParam,
}) {
  return safeFromQueryParams(
    state.uri.queryParameters,
    allowedRedirectPaths: allowedRedirectPaths,
    blockedRedirectPaths: blockedRedirectPaths,
    queryParam: queryParam,
  );
}

String? safeFromQueryParams(
  Map<String, String> queryParameters, {
  Set<String> allowedRedirectPaths = const {},
  Set<String> blockedRedirectPaths = const {},
  String queryParam = fromQueryParam,
}) {
  final value = queryParameters[queryParam];

  if (value == null || value.isEmpty) {
    return null;
  }

  final uri = Uri.tryParse(value);

  if (uri == null || uri.hasScheme || uri.hasAuthority) {
    return null;
  }

  if (!uri.path.startsWith('/')) {
    return null;
  }

  if (allowedRedirectPaths.isNotEmpty &&
      !allowedRedirectPaths.contains(uri.path)) {
    return null;
  }

  if (blockedRedirectPaths.contains(uri.path)) {
    return null;
  }

  return uri.toString();
}
