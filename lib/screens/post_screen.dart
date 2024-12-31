import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_app/models/post_model.dart';
import 'package:flutter_crud_app/screens/post_detail_screen.dart';
import '../bloc/post_bloc.dart';

class PostListScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showAddPostDialog(context);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter user ID to filter",
                hintStyle: TextStyle(color: Colors.teal.shade300),
                prefixIcon: Icon(Icons.search, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.teal.shade200),
                ),
                filled: true,
                fillColor: Colors.teal.shade50,
              ),
              onChanged: (value) {
                final userId = int.tryParse(value);
                if (userId != null) {
                  context.read<PostBloc>().add(SearchPostsEvent(userId));
                } else if (value.isEmpty) {
                  context.read<PostBloc>().add(FetchPostsEvent());
                }
              },
            ),
          ),
        ),
      ),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostAddedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Post added successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is PostUpdatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Post updated successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is PostDeletedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Post deleted successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is PostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PostError) {
              return Center(child: Text(state.message));
            } else if (state is PostLoaded) {
              final posts = state.posts;
              return posts.isEmpty
                  ? Center(child: Text("No posts found for this user ID"))
                  : ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(15),
                                title: Text(
                                  post.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.teal.shade700,
                                  ),
                                ),
                                subtitle: Text(
                                  post.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PostDetailScreen(post: post),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.teal,
                                  child: Text(
                                    post.userId.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
            } else {
              return Center(child: Text("No posts available"));
            }
          },
        ),
      ),
    );
  }

  void showAddPostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.teal.shade50,
          title: Text("Add New Post", style: TextStyle(color: Colors.teal)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(color: Colors.teal),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(
                  labelText: "Body",
                  labelStyle: TextStyle(color: Colors.teal),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final body = bodyController.text;
                final userId = 1; // Example user ID, you can modify it

                if (title.isNotEmpty && body.isNotEmpty) {
                  final newPost = Post(
                    userId: userId,
                    title: title,
                    body: body,
                  );
                  context.read<PostBloc>().add(AddPostEvent(newPost));
                  titleController.clear();
                  bodyController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text("Add Post"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
