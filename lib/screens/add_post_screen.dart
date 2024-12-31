// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_crud_app/bloc/post_bloc.dart';
// import 'package:flutter_crud_app/models/post_model.dart';


// class AddPostScreen extends StatelessWidget {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _bodyController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Add Post")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(labelText: "Title"),
//             ),
//             TextField(
//               controller: _bodyController,
//               decoration: InputDecoration(labelText: "Body"),
//               maxLines: 5,
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//              onPressed: () {
//                 final newPost = Post(
//                   userId: 1, // Replace with actual user ID
//                   title: _titleController.text,
//                   body: _bodyController.text,
//                 );
//                 context.read<PostBloc>().add(AddPostEvent(newPost));
//                 Navigator.pop(context);
//               },
//               child: Text("Submit"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
