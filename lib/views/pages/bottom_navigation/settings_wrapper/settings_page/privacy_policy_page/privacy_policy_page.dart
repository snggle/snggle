import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';

@RoutePage()
class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  final ScrollController _scrollController = ScrollController();

  String _privacyPolicy = '';

  @override
  void initState() {
    super.initState();
    _loadPrivacyPolicy();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Privacy Policy',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _privacyPolicy.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SelectionArea(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Text(
                    _privacyPolicy,
                    style: const TextStyle(
                      height: 1.3,
                    ),
                    strutStyle: const StrutStyle(
                      height: 1.3,
                      forceStrutHeight: true,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _loadPrivacyPolicy() async {
    String privacyPolicy = await rootBundle.loadString(
      'assets/documents/privacy_policy.md',
    );

    if (mounted == false) {
      return;
    }

    setState(() {
      _privacyPolicy = privacyPolicy;
    });
  }
}
