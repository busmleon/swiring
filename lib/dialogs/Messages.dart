class Messages {
  static final EmailVerificationMessage emailVerificationMessage =
      EmailVerificationMessage();
  static final EmailNotVerifiedMessage emailNotVerifiedMessage =
      EmailNotVerifiedMessage();
  static final UserAlreadyExistsMessage userAlreadyExistsMessage =
      UserAlreadyExistsMessage();
  static final UnknownErrorMessage unknownErrorMessage = UnknownErrorMessage();
  static final PasswordResetedMessage passwordResetedMessage =
      PasswordResetedMessage();
  static final WrongCredentialsMessage wrongCredentialsMessage =
      WrongCredentialsMessage();
  static final LogoutMessage logoutMessage = LogoutMessage();
  static final DeleteInternshipMessage deleteInternshipMessage = DeleteInternshipMessage();
}

abstract class Message {
  String title;
  String content;
}

class WrongCredentialsMessage implements Message {
  @override
  String title = 'Wrong credentials';
  @override
  String content = 'Wrong username or password';
}

class EmailVerificationMessage implements Message {
  @override
  String title = 'Email verification required';
  @override
  String content =
      'Please verify your account by clicking the link provided in the email we sent you.';
}

class EmailNotVerifiedMessage implements Message {
  @override
  String title = 'Email not verified';
  @override
  String content = 'Please verify your email before you sign-in.';
}

class UserAlreadyExistsMessage implements Message {
  @override
  String title = 'User duplicate';
  @override
  String content =
      'This email has already been assigned an account. You can reset your password on the login-page.';
}

class UnknownErrorMessage implements Message {
  @override
  String title = 'Unexpected error!';
  @override
  String content = 'Something went horribly wrong.';
}

class PasswordResetedMessage implements Message {
  @override
  String title = 'Password has been reseted';
  @override
  String content =
      'An email to reset your password has been sent to the provided email-address.';
}

class LogoutMessage implements Message {
  @override
  String title = 'Sign out';
  @override
  String content = 'Do you want to sign out?';
}

class DeleteInternshipMessage implements Message {
  @override
  String title = 'Delete Placement';
  @override
  String content =
      'Are you sure that you want to delete this placement ?';
}
