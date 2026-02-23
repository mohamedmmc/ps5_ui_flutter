class UserProfile {
  final String name;
  final String? avatarAssetPath;
  final bool isAddButton;

  const UserProfile({
    required this.name,
    this.avatarAssetPath,
    this.isAddButton = false,
  });
}

