import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:youtube_bloc/api.dart';
import 'package:youtube_bloc/models/video.dart';
import 'dart:async';

class VideosBloc implements BlocBase {
  //acesso a API
  Api _api;

  VideosBloc() {
    _api = Api();
    _searchController.stream.listen(_search);
  }
  List<Video> videos;
  //lista de videos de resultado
  final _streamController = StreamController<List<Video>>();
  //getter
  Stream get outVideos => _streamController.stream;

  //adicionando novas buscas no sink
  final _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink;

  @override
  void dispose() {
    // TODO: implement dispose
    _streamController.close();
    _searchController.close();
  }

  void _search(String search) async {
    if (search != null) {
      _streamController.sink.add([]);
      videos = await _api.search(search);
    } else {
      videos += await _api.nextPage();
    }
    _streamController.sink.add(videos);
  }
}
