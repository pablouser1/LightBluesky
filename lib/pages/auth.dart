import 'package:bluesky/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lightbluesky/common.dart';
import 'package:lightbluesky/helpers/ui.dart';
import 'package:lightbluesky/l10n/app_localizations.dart';

/// Authentication page
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;
  bool _needsFactor = false;

  final _serviceController = TextEditingController(text: 'bsky.social');
  final _identityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authFactorController = TextEditingController();

  // Run login attempt
  void _handleSession(AppLocalizations locale) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await api.login(
        _serviceController.text,
        _identityController.text,
        _passwordController.text,
        _authFactorController.text != '' ? _authFactorController.text : null,
      );
      await api.initPreferences();

      if (!mounted) return;
      // Redirect to home
      context.go('/');
    } on XRPCException catch (e) {
      // Something went wrong
      if (e.response.data.error == 'AuthFactorTokenRequired') {
        // Server is asking for 2FA
        Ui.snackbar(context, e.response.data.message ?? locale.auth_2fa_sent);

        setState(() {
          _needsFactor = true;
          _isLoading = false;
        });
        return;
      }

      // Unexpected error happened
      Ui.dialog(
        context,
        e.response.data.error,
        e.response.data.message ?? locale.unknown_error,
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text("OK")),
        ],
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(locale.auth_title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _serviceController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: locale.auth_service,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _identityController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: locale.auth_handle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: locale.auth_password,
                ),
              ),
            ),
            // 2FA field, hidden by default
            if (_needsFactor)
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _authFactorController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: locale.auth_2fa,
                  ),
                ),
              ),
            // Login button
            OutlinedButton.icon(
              onPressed: !_isLoading ? () => _handleSession(locale) : null,
              icon: const Icon(Icons.login),
              label: Text(locale.auth_login),
            ),
          ],
        ),
      ),
    );
  }
}
