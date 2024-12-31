import 'dart:convert';
import 'package:flutter_crud_app/models/post_model.dart';
import 'package:http/http.dart' as http;

class PostService {
  final String baseUrl = "https://jsonplaceholder.typicode.com";

  // Fetch posts from API
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse("$baseUrl/posts"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception("Failed to load posts");
    }
  }

  Future<Post> addPost(Post post) async {
    final response = await http.post(
      Uri.parse("$baseUrl/posts"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': post.title,
        'body': post.body,
        'userId': post.userId,
      }),
    );
    print("response${response.statusCode}");
    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to add post");
    }
  }

  Future<Post> updatePost(Post post) async {
    final response = await http.put(
      Uri.parse("$baseUrl/posts/${post.id}"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': post.title,
        'body': post.body,
        'userId': post.userId,
      }),
    );
   
    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to update post");
    }
  }

  // Delete a post
  Future<void> deletePost(int postId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/posts/$postId"),
    );
     print("${response.statusCode}");
    if (response.statusCode != 200) {
      throw Exception("Failed to delete post");
    }
  }
}
