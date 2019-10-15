import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/util/constant.dart';
import 'package:meta/meta.dart';

import 'order_detail.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  @override
  OrderDetailState get initialState => OrderDetailLoading();

  @override
  Stream<OrderDetailState> mapEventToState(OrderDetailEvent event) async* {
    try {
      if (event is OrderDetailLoad) {
        //加载报警管理单详情
        final orderDetail = await getOrderDetail(
          orderId: event.orderId,
        );
        yield OrderDetailLoaded(
          orderDetail: orderDetail,
        );
      }
    } catch (e) {
      yield OrderDetailError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }
  //获取报警管理单详情
  Future<OrderDetail> getOrderDetail({
    @required orderId,
  }) async {
    Response response = await DioUtils.instance
        .getDio()
        .get(HttpApi.orderDetail, queryParameters: {
      'orderId': orderId,
    });
    return OrderDetail.fromJson(response.data[Constant.responseDataKey]);
  }
}