class GitHubUser {
  final String login; // Username
  final String avatarUrl; // User's avatar URL
  final int publicRepos; // Number of public repositories

  GitHubUser({
    required this.login,
    required this.avatarUrl,
    required this.publicRepos,
  });

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    print('Public Repos: ${json['public_repos']}'); // Debug statement
    return GitHubUser(
      login: json['login'],
      avatarUrl: json['avatar_url'],
      publicRepos: json['public_repos'] ?? 0, // Ensure correct parsing
    );
  }
}
