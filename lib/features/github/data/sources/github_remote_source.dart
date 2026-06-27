import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

import '../../domain/entities/github_stats.dart';

/// Fetches GitHub contribution data from the public jogruber API.
///
/// Endpoint: https://github-contributions-api.jogruber.de/v4/{username}?y=last
///
/// This API is CORS-enabled and does not require a GitHub auth token.
/// Uses `package:web` (Fetch API) — Wasm-compatible and dart:html-free.
///
/// Response shape (simplified):
/// ```json
/// {
///   "total": { "lastYear": 342 },
///   "contributions": [
///     { "date": "2024-01-01", "count": 3, "level": 2 },
///     ...
///   ]
/// }
/// ```
class GitHubRemoteSource {
  const GitHubRemoteSource();

  static const _baseUrl = 'https://github-contributions-api.jogruber.de/v4';
  static const _timeout = Duration(seconds: 15);

  Future<GitHubStats> fetchStats(String username) async {
    final url = '$_baseUrl/$username?y=last';
    try {
      final body = await _get(url).timeout(_timeout);
      final data = jsonDecode(body) as Map<String, dynamic>;
      return _parse(username, data);
    } catch (e) {
      if (kDebugMode) debugPrint('[GitHubRemoteSource] error: $e');
      rethrow;
    }
  }

  /// GET request using the Fetch API via `package:web`.
  /// This is the Wasm-compatible replacement for `dart:html`'s
  /// `HttpRequest.getString()`.
  Future<String> _get(String url) async {
    final response = await web.window.fetch(url.toJS).toDart;
    if (!response.ok) {
      throw NetworkException(
        'HTTP ${response.status}: ${response.statusText}',
      );
    }
    final jsBody = await response.text().toDart;
    return jsBody.toDart;
  }

  GitHubStats _parse(String username, Map<String, dynamic> data) {
    final rawList = data['contributions'] as List<dynamic>;
    final totalMap = data['total'] as Map<String, dynamic>;
    final total = (totalMap['lastYear'] as int?) ?? 0;

    final days = rawList.map((e) {
      final m = e as Map<String, dynamic>;
      return ContributionDay(
        date: DateTime.parse(m['date'] as String),
        count: m['count'] as int,
        level: m['level'] as int,
      );
    }).toList();

    // Group into weeks of up to 7 days (matching GitHub's column layout).
    final weeks = <ContributionWeek>[];
    for (int i = 0; i < days.length; i += 7) {
      weeks.add(ContributionWeek(
        days: days.sublist(i, (i + 7).clamp(0, days.length)),
      ));
    }

    return GitHubStats(
      username: username,
      totalContributions: total,
      weeks: weeks,
    );
  }
}

class NetworkException implements Exception {
  const NetworkException(this.message);
  final String message;
  @override
  String toString() => 'NetworkException: $message';
}
