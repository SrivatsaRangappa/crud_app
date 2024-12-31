import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_app/models/post_model.dart';
import 'package:flutter_crud_app/service/post_service.dart';

// Events
abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPostsEvent extends PostEvent {}

class SearchPostsEvent extends PostEvent {
  final int userId;

  SearchPostsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddPostEvent extends PostEvent {
  final Post post;

  AddPostEvent(this.post);

  @override
  List<Object> get props => [post];
}

class PostAdded extends PostState {
  final Post post;

  PostAdded(this.post);

  @override
  List<Object> get props => [post];
}

class UpdatePostEvent extends PostEvent {
  final Post post;

  UpdatePostEvent(this.post);

  @override
  List<Object> get props => [post];
}

class DeletePostEvent extends PostEvent {
  final int postId;

  DeletePostEvent(this.postId);

  @override
  List<Object> get props => [postId];
}

// States
abstract class PostState extends Equatable {
  @override
  List<Object> get props => [];
}
class PostAddedSuccess extends PostState {}

class PostUpdatedSuccess extends PostState {}

class PostDeletedSuccess extends PostState {} 

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;

  PostLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class PostError extends PostState {
  final String message;

  PostError(this.message);

  @override
  List<Object> get props => [message];
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostService postService;
  List<Post> allPosts = [];

  PostBloc(this.postService) : super(PostInitial()) {
    // Fetch Posts
    on<FetchPostsEvent>((event, emit) async {
      emit(PostLoading());
      try {
        final posts = await postService.fetchPosts();
        print("Fetched posts: ${posts.length}");
        allPosts = posts;
        emit(PostLoaded(posts)); // Emit the posts after fetching
      } catch (e) {
        emit(PostError("Failed to load posts"));
      }
    });

    // Search Posts by userId
    on<SearchPostsEvent>((event, emit) {
      print("Filtering posts for userId: ${event.userId}");

      // Ensure posts are available before filtering
      if (allPosts.isEmpty) {
        emit(PostError("No posts available for search"));
        return;
      }

      final filteredPosts =
          allPosts.where((post) => post.userId == event.userId).toList();
      print("Filtered posts count: ${filteredPosts.length}");

      // Emit filtered posts
      emit(PostLoaded(filteredPosts));
    });

    on<AddPostEvent>((event, emit) async {
      try {
        // Assuming the PostService has a method to add a post
        final newPost = await postService.addPost(event.post);
        allPosts.insert(0, newPost);
        emit(PostAdded(newPost)); // Emit the newly added post
          emit(PostAddedSuccess());
        emit(PostLoaded(allPosts)); // Emit the updated list of posts
      
      } catch (e) {
        emit(PostError("Failed to add post"));
      }
    });

    on<UpdatePostEvent>((event, emit) async {
      try {
        final updatedPost = await postService.updatePost(event.post);
        final posts = await postService.fetchPosts();
        print("Updated");
          emit(PostUpdatedSuccess()); 
        emit(PostLoaded(posts)); // Emit the updated list of posts
        //  emit(PostUpdatedSuccess());
      } catch (e) {
        emit(PostError("Failed to update post"));
      }
    });

    // Delete Post
    on<DeletePostEvent>((event, emit) async {
      try {
        await postService.deletePost(event.postId);
        final posts = await postService.fetchPosts();
           emit(PostDeletedSuccess());
        emit(PostLoaded(posts)); // Emit the updated list of posts
     
      } catch (e) {
        emit(PostError("Failed to delete post"));
      }
    });
  }
}
