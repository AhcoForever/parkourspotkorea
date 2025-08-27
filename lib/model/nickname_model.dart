class NicknameRequest {
  final String displayName;

  NicknameRequest({required this.displayName});

  bool get isValid => displayName.isNotEmpty && displayName.length >= 2;

  bool get isLengthValid => displayName.length >= 2 && displayName.length <= 10;

  bool get hasValidCharacters {
    final regex = RegExp(r'^[가-힣a-zA-Z0-9]+$');
    return regex.hasMatch(displayName);
  }
}

enum NicknameStatus { initial, checking, available, unavailable, loading, success, error }

class NicknameState {
  final NicknameStatus status;
  final String? errorMessage;
  final bool isAvailable;

  NicknameState({
    this.status = NicknameStatus.initial,
    this.errorMessage,
    this.isAvailable = false,
  });

  NicknameState copyWith({
    NicknameStatus? status,
    String? errorMessage,
    bool? isAvailable,
  }) {
    return NicknameState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}