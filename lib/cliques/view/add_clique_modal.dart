import 'package:flutter/material.dart';

class AddCliqueModal extends StatefulWidget {
  const AddCliqueModal({super.key});

  @override
  State<StatefulWidget> createState() => _AddCliqueModalState();
}

class _AddCliqueModalState extends State<AddCliqueModal> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Create a new clique",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            TextFormField(
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "You can't have an empty name, please enter a name";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                labelText: 'Name',
                hintText: "Must not be empty",
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context, nameController.text);
                    }
                  },
                  child: const Text("Create"),
                ),
              ],
            ),
          ],

        ),
      ),
    );
  }

}