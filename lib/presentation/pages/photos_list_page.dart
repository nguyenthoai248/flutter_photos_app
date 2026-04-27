import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photos_app/bloc/photo_bloc.dart';
import 'package:photos_app/bloc/photo_state.dart';
import 'package:photos_app/injection_container.dart';
import 'package:photos_app/presentation/pages/photo_detail_page.dart';
import 'package:photos_app/viewmodels/photo_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhotosListPage extends StatefulWidget {
  @override
  State<PhotosListPage> createState() => _PhotosListPageState();
}

class _PhotosListPageState extends State<PhotosListPage> {
  late final PhotoBloc bloc;
  late final PhotoViewModel viewModel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc = PhotoBloc(getIt());
    viewModel = PhotoViewModel(bloc);

    viewModel.loadMore();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        viewModel.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photos List')),
      body: BlocBuilder<PhotoBloc, PhotoState>(
        bloc: bloc,
        builder: (context, state) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.photos.length + (state.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.photos.length) {
                return Center(child: CircularProgressIndicator());
              }

              final photo = state.photos[index];

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoDetailPage(photo: photo),
                      ),
                    );
                  },
                  child: Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: photo.thumbnailUrl.replaceAll(
                              'via.placeholder.com',
                              'dummyimage.com',
                            ),
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  width: 56,
                                  height: 56,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  width: 56,
                                  height: 56,
                                  alignment: Alignment.center,
                                  child: Icon(Icons.error, size: 18),
                                ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              photo.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
