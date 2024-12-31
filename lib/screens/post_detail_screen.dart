import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_app/bloc/post_bloc.dart';
import 'package:flutter_crud_app/models/post_model.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  PostDetailScreen({required this.post});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.post.title;
    bodyController.text = widget.post.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.white), // Set back button color to white
          onPressed: () {
            Navigator.pop(context); // Navigate back when pressed
          },
        ),
        backgroundColor: Colors.teal, // Consistent with the previous screen
        title: Text("Post Details", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              // Trigger delete post event
              context.read<PostBloc>().add(DeletePostEvent(widget.post.id));
              Navigator.pop(context); // Navigate back after deletion
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
             decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  borderSide: BorderSide(
                      color: Colors.teal, width: 2), // Border color and width
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors.tealAccent,
                      width: 2), // Focused border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors.teal,
                      width: 2), // Border color when enabled
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: bodyController,
             decoration: InputDecoration(
                labelText: "Body",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  borderSide: BorderSide(
                      color: Colors.teal, width: 2), // Border color and width
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors.tealAccent,
                      width: 2), // Focused border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors.teal,
                      width: 2), // Border color when enabled
                ),
              ),
              maxLines: 5, // Allow multiple lines for the body text
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedPost = Post(
                  userId: widget.post.userId,
                  id: widget.post.id,
                  title: titleController.text,
                  body: bodyController.text,
                );

                // Trigger update post event
                context.read<PostBloc>().add(UpdatePostEvent(updatedPost));
                Navigator.pop(context); // Navigate back after updating
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal, // Consistent button color
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Update Post", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
