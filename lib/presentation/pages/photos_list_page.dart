import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photos_app/bloc/photo_bloc.dart';
import 'package:photos_app/bloc/photo_state.dart';
import 'package:photos_app/injection_container.dart';
import 'package:photos_app/models/photo.dart';
import 'package:photos_app/presentation/pages/photo_detail_page.dart';
import 'package:photos_app/viewmodels/photo_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhotosListPage extends StatefulWidget {
  const PhotosListPage({super.key});

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

              return PhotoListItem(photo: photo);
            },
          );
        },
      ),
    );
  }
}

class PhotoListItem extends StatefulWidget {
  final Photo photo;

  const PhotoListItem({super.key, required this.photo});

  @override
  State<PhotoListItem> createState() => _PhotoListItemState();
}

class _PhotoListItemState extends State<PhotoListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 320),
    vsync: this,
  )..forward();

  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  late final Animation<Offset> _offset = Tween<Offset>(
    begin: const Offset(0, 0.08),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: OpenContainer(
          closedElevation: 0,
          openElevation: 0,
          closedColor: Theme.of(context).scaffoldBackgroundColor,
          openColor: Theme.of(context).scaffoldBackgroundColor,
          transitionType: ContainerTransitionType.fadeThrough,
          transitionDuration: const Duration(milliseconds: 350),
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          openShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          openBuilder: (context, openContainer) {
            return PhotoDetailPage(photo: widget.photo);
          },
          closedBuilder: (context, openContainer) {
            return Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: widget.photo.thumbnailUrl.replaceAll(
                        'via.placeholder.com',
                        'dummyimage.com',
                      ),
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 250),
                      placeholder:
                          (context, url) => Container(
                            width: 56,
                            height: 56,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            width: 56,
                            height: 56,
                            alignment: Alignment.center,
                            child: const Icon(Icons.error, size: 18),
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.photo.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
