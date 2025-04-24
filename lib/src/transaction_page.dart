import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key,this.user_id});
  final user_id;
  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final StreamController<List<dynamic>> _transactionStreamController =
  StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    final fetchedTransactions = await fetchTransactions();
    _transactionStreamController.add(fetchedTransactions);
  }

  Future<List<dynamic>> fetchTransactions() async {
    // Simulate fetching data from an API or database
    final response = await http.get(
      Uri.parse('https://fm.hcf-itsolution.com/api/v1/transaction'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  void createTransaction() {
    // Logic to create a new transaction
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController amountController = TextEditingController();
        final TextEditingController dateController = TextEditingController(
          text: DateTime.now().toIso8601String().split('T').first,
        );
        String type = 'Credit';
        String status = 'Complete';

        return AlertDialog(
          title: const Text('Create Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Type:'),
                  Radio<String>(
                    value: 'Debit',
                    groupValue: type,
                    onChanged: (value) {
                      if (value != null) {
                        type = value;
                      }
                    },
                  ),
                  const Text('Debit'),
                  Radio<String>(
                    value: 'Credit',
                    groupValue: type,
                    onChanged: (value) {
                      if (value != null) {
                        type = value;
                      }
                    },
                  ),
                  const Text('Credit'),
                ],
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              DropdownButtonFormField<String>(
                value: status,
                items: const [
                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'Complete', child: Text('Complete')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    status = value;
                  }
                },
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Transaction Date (YYYY-MM-DD)',
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    dateController.text =
                        selectedDate.toIso8601String().split('T').first;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text) ?? 0;
                final transactionDate = dateController.text;

                if (type.isNotEmpty &&
                    amount > 0 &&
                    status.isNotEmpty &&
                    transactionDate.isNotEmpty) {
                  final response = await http.post(
                    Uri.parse(
                      'https://fm.hcf-itsolution.com/api/v1/transaction/create',
                    ),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'user_id': widget.user_id,
                      'type': type,
                      'amount': amount,
                      'status': status,
                      'transaction_date': transactionDate,
                    }),
                  );

                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    Navigator.pop(context);
                    await _fetchTransactions();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Transaction created successfully'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to create transaction: ${response.reasonPhrase}',
                        ),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields correctly'),
                    ),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void updateTransaction(int id) {
    // Logic to update the specified transaction
    // You can navigate to another screen or show a dialog for transaction editing
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Transaction $id'),
          content: Text('This is where you edit transaction $id.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void deleteTransaction(int id) {
    // Logic to delete the specified transaction
    // You can show a confirmation dialog before deleting
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Transaction'),
          content: Text('Are you sure you want to delete transaction $id?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel action
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.delete(
                  Uri.parse(
                    'https://fm.hcf-itsolution.com/api/v1/transaction/$id',
                  ),
                );

                Navigator.pop(context); // Close the dialog

                if (response.statusCode == 204) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Transaction $id deleted successfully'),
                    ),
                  );
                  await _fetchTransactions();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete transaction $id')),
                  );
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Transactions"),
      ),
      body: StreamBuilder(
        stream: _transactionStreamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final transactions = snapshot.data as List<dynamic>;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                title: Text(
                  'Type: ${transaction['type']} | Amount: \$${transaction['amount']}',
                ),
                subtitle: Text(
                  'Status: ${transaction['status']} | Date: ${transaction['transaction_date']}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => updateTransaction(transaction['id']),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteTransaction(transaction['id']),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createTransaction,
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }
}