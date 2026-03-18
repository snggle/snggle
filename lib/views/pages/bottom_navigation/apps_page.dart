import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:snggle/views/pages/bottom_navigation/native_credentials.dart';

@RoutePage()
class AppsPage extends StatefulWidget {
  const AppsPage({super.key});

  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _packageController = TextEditingController();

  bool _loading = false;
  String _status = 'Gotowe';
  List<NativeCredentials> _items = const <NativeCredentials>[];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _packageController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _status = 'Pobieranie rekordów...';
    });

    try {
      List<NativeCredentials> items = await NativeCredentialStore.getAllCredentials();

      if (!mounted) {
        return;
      }

      setState(() {
        _items = items;
        _status = 'Pobrano ${items.length} rekordów';
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Błąd pobierania: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _save() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;
    String packageName = _packageController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _status = 'Uzupełnij username i password';
      });
      return;
    }

    setState(() {
      _loading = true;
      _status = 'Zapisywanie rekordu...';
    });

    try {
      await NativeCredentialStore.saveCredentials(
        username: username,
        password: password,
        packageName: packageName.isEmpty ? null : packageName,
      );

      List<NativeCredentials> items = await NativeCredentialStore.getAllCredentials();

      if (!mounted) {
        return;
      }

      _usernameController.clear();
      _passwordController.clear();

      setState(() {
        _items = items;
        _status = 'Zapisano rekord. Łącznie: ${items.length}';
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Błąd zapisu: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _delete(String id) async {
    setState(() {
      _loading = true;
      _status = 'Usuwanie rekordu...';
    });

    try {
      await NativeCredentialStore.deleteCredential(id);
      List<NativeCredentials> items = await NativeCredentialStore.getAllCredentials();

      if (!mounted) {
        return;
      }

      setState(() {
        _items = items;
        _status = 'Usunięto rekord. Łącznie: ${items.length}';
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Błąd usuwania: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _clear() async {
    setState(() {
      _loading = true;
      _status = 'Czyszczenie wszystkich rekordów...';
    });

    try {
      await NativeCredentialStore.clearCredentials();

      if (!mounted) {
        return;
      }

      _usernameController.clear();
      _passwordController.clear();
      _packageController.clear();

      setState(() {
        _items = const <NativeCredentials>[];
        _status = 'Wyczyszczono wszystkie rekordy';
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Błąd czyszczenia: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native autofill storage debug'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username / email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _packageController,
                  decoration: const InputDecoration(
                    labelText: 'Target package name',
                    hintText: 'np. com.snggle.mobile',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _loading ? null : _save,
                        child: const Text('Add record'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _loading ? null : _refresh,
                        child: const Text('Refresh'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _loading ? null : _clear,
                    child: const Text('Clear all'),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Status: $_status'),
                const SizedBox(height: 24),
                Text(
                  'Zapisane rekordy (${_items.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (_items.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Brak zapisanych rekordów'),
                    ),
                  )
                else
                  ..._items.map(
                    (NativeCredentials item) => Card(
                      child: ListTile(
                        title: Text(item.username),
                        subtitle: Text(
                          'password=${item.password}\npackage=${item.packageName ?? "-"}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: _loading ? null : () => _delete(item.id),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}
