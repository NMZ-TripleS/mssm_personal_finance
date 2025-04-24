import 'package:cash_book_mobile/src/transaction_page.dart';
import 'package:cash_book_mobile/store/models.dart';
import 'package:cash_book_mobile/store/objectbox.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cash_book_mobile/providers/objectbox_provider.dart';
import 'package:cash_book_mobile/providers/user_fetch_provider.dart';

class UserSelectionPage extends HookConsumerWidget {
  const UserSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch users from API
    final userListAsync = ref.watch(fetchUsersProvider);

    // Watch ObjectBox provider
    final objectBoxAsync = ref.watch(objectBoxProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select User'),
      ),
      body: userListAsync.when(
        data: (users) {
          // Async objectBox is required for saving
          return objectBoxAsync.when(
            data: (objectBox) => UserDropdown(
              users: users,
              objectBox: objectBox,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text('Error loading DB: $error'),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

class UserDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final ObjectBox objectBox;

  const UserDropdown({super.key, required this.users, required this.objectBox});
  @override
  State<UserDropdown> createState() => _UserDropdownState();
}

class _UserDropdownState extends State<UserDropdown> {
  Map<String, dynamic>? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<Map<String, dynamic>>(
          isExpanded: true,
          value: selectedUser,
          hint: const Text('Select a User'),
          items: widget.users.map((user) {
            return DropdownMenuItem(
              value: user,
              child: Text(user['name']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedUser = value;
            });
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: selectedUser == null
              ? null
              : () {
            // Confirmation Dialog
            _confirmUserSelection(context);
          },
          child: const Text('Confirm Selection'),
        ),
      ],
    );
  }

  void _confirmUserSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm User'),
        content: Text('Are you sure you want to select: ${selectedUser!['name']}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Save the selected user to ObjectBox
              widget.objectBox.saveUser(
                  User(selectedUser!['id'], selectedUser!['name'])
              );

              Navigator.of(context).pop(); // Close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User saved successfully!')),
              );

              // Navigate to TransactionPage without keeping navigation history
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      TransactionPage(user_id: selectedUser!['id']),
                ),
              );
              // Optionally navigate away or perform further actions
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}