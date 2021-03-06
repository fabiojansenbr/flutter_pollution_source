import 'package:equatable/equatable.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class ListLoad extends ListEvent {
  //是否刷新
  final bool isRefresh;
  final Map<String, dynamic> params;

  const ListLoad({this.isRefresh = false, this.params});

  @override
  List<Object> get props => [isRefresh, params];
}
