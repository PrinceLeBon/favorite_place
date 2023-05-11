import 'package:flutter/material.dart';

class UpdateFavoritePlace extends StatelessWidget {
  const UpdateFavoritePlace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final myController1 = TextEditingController();
    return AlertDialog(
      title: const Center(child: Text("Update Favorite Place")),
      content: Form(
          key: formKey,
          child: TextFormField(
            style: const TextStyle(fontSize: 13, color: Colors.black),
            controller: myController1,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter favorite place name";
              }
              return null;
            },
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_history),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                hintText: "Enter favorite place name"),
          )),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {},
        ),
        TextButton(
          child: const Text('Approve'),
          onPressed: () {},
        ),
      ],
    );
  }
}
