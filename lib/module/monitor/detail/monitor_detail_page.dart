import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/monitor/table/monitor_table_page.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'monitor_detail.dart';

class MonitorDetailPage extends StatefulWidget {
  final String monitorId;

  MonitorDetailPage({@required this.monitorId}) : assert(monitorId != null);

  @override
  _MonitorDetailPageState createState() => _MonitorDetailPageState();
}

class _MonitorDetailPageState extends State<MonitorDetailPage> {
  MonitorDetailBloc _monitorDetailBloc;

  @override
  void initState() {
    super.initState();
    _monitorDetailBloc = BlocProvider.of<MonitorDetailBloc>(context);
    // TODO 测试写死monitorId
    _monitorDetailBloc.add(MonitorDetailLoad(monitorId: '10755'));
  }

  @override
  void dispose() {
    super.dispose();
  }

  //用来显示SnackBar
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: EasyRefresh.custom(
        slivers: <Widget>[
          BlocBuilder<MonitorDetailBloc, MonitorDetailState>(
            builder: (context, state) {
              String enterName = '';
              String enterAddress = '';
              Widget popupMenuButton = Gaps.empty;
              if (state is MonitorDetailLoaded) {
                enterName = state.monitorDetail.enterName;
                enterAddress = state.monitorDetail.enterAddress;
                final bool isCurved = state.isCurved;
                final bool showDotData = state.showDotData;
                popupMenuButton = PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<String>>[
                    UIUtils.getSelectView(
                        Icons.message, isCurved ? '折线图' : '曲线图', '1'),
                    UIUtils.getSelectView(
                        Icons.group_add, showDotData ? '隐藏点' : '显示点', '2'),
                  ],
                  onSelected: (String action) {
                    // 点击选项的时候 持久化储存并更新配置
                    switch (action) {
                      case '1':
                        SpUtil.putBool(Constant.spIsCurved, !isCurved);
                        _monitorDetailBloc.add(UpdateChartConfig(
                            isCurved: !isCurved, showDotData: showDotData));
                        break;
                      case '2':
                        SpUtil.putBool(Constant.spShowDotData, !showDotData);
                        _monitorDetailBloc.add(UpdateChartConfig(
                            isCurved: isCurved, showDotData: !showDotData));
                        break;
                    }
                  },
                );
              }
              return DetailHeaderWidget(
                title: '在线数据详情',
                subTitle1: '$enterName',
                subTitle2: '$enterAddress',
                imagePath: 'assets/images/monitor_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_red.png',
                popupMenuButton: popupMenuButton,
              );
            },
          ),
          BlocBuilder<MonitorDetailBloc, MonitorDetailState>(
            builder: (context, state) {
              if (state is MonitorDetailLoading) {
                return LoadingSliver();
              } else if (state is MonitorDetailEmpty) {
                return EmptySliver();
              } else if (state is MonitorDetailError) {
                return ErrorSliver(errorMessage: state.errorMessage);
              } else if (state is MonitorDetailLoaded) {
                return _buildPageLoadedDetail(context, state.monitorDetail, state.isCurved, state.showDotData);
              } else {
                return ErrorSliver(errorMessage: 'BlocBuilder监听到未知的的状态');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedDetail(BuildContext context,MonitorDetail monitorDetail, bool isCurved, bool showDotData) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          //基本信息
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '基本信息',
                  imagePath: 'assets/images/icon_enter_baseinfo.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '监控点名：${monitorDetail.monitorName}',
                      icon: Icons.linked_camera,
                      flex: 7,
                    ),
                    Gaps.hGap20,
                    IconBaseInfoWidget(
                      content: '监控类型：${monitorDetail.monitorTypeStr}',
                      icon: Icons.videocam,
                      flex: 5,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '监控类别：${monitorDetail.monitorCategoryStr}',
                      icon: Icons.nature,
                      flex: 7,
                    ),
                    Gaps.hGap20,
                    IconBaseInfoWidget(
                      content: '网络类型：${monitorDetail.networkTypeStr}',
                      icon: Icons.network_wifi,
                      flex: 5,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '监控位置：${monitorDetail.monitorAddress}',
                      icon: Icons.location_on,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '数采编号：${monitorDetail.mnCode}',
                      icon: Icons.insert_drive_file,
                    ),
                  ],
                ),
              ],
            ),
          ),
          //历史数据
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '监测数据',
                  content: DateUtil.formatDateMs(monitorDetail.chartDataList[0].maxX.toInt(), format: 'yyyy-MM-dd HH:mm:ss'),
                  imagePath: 'assets/images/icon_monitor_statistics.png',
                ),
                GridView.count(
                  //设置padding 防止item阴影被裁剪
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    top: 10,
                  ),
                  primary: false,
                  shrinkWrap: true,
                  mainAxisSpacing: 10.0,
                  crossAxisCount: 4,
                  crossAxisSpacing: 10.0,
                  children: monitorDetail.chartDataList.map((chartData) {
                    return FactorValueWidget(
                      chartData: chartData,
                      onTap: () {
                        if(chartData.points ==null || chartData.points.length==0){
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${chartData.factorName}没有数据'),
                              action: SnackBarAction(
                                  label: '我知道了', textColor: Colours.primary_color, onPressed: () {}),
                            ),
                          );
                          return;
                        }
                        _monitorDetailBloc.add(
                          UpdateChartData(
                            chartData: chartData.copyWith(
                              checked: !chartData.checked,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                LineChartWidget(
                  chartDataList: monitorDetail.chartDataList,
                  isCurved: isCurved,
                  showDotData: showDotData,
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    ClipButton(
                      text: '排放标准',
                      icon: Icons.business_center,
                      color: Colors.lightBlueAccent,
                      onTap: () {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content:const Text('排放标准功能开发中'),
                            action: SnackBarAction(
                                label: '我知道了', textColor: Colours.primary_color, onPressed: () {}),
                          ),
                        );
                      },
                    ),
                    Gaps.hGap20,
                    ClipButton(
                      text: '历史数据',
                      icon: Icons.table_chart,
                      color: Colors.orange,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return MonitorTablePage();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          //报警管理单
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '报警管理单',
                  imagePath: 'assets/images/icon_alarm_manage.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    InkWellButton5(
                      ratio: 1.2,
                      onTap: () {
                        Application.router.navigateTo(
                            context, '${Routes.orderList}?monitorId=${monitorDetail.monitorId}&state=5');
                      },
                      meta: Meta(
                        color: Color(0xFF45C4FF),
                        title: '已办结',
                        content: '${monitorDetail.orderCompleteCount}',
                        imagePath:
                        'assets/images/icon_alarm_manage_complete.png',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton5(
                      ratio: 1.2,
                      onTap: () {
                        Application.router.navigateTo(
                            context, '${Routes.orderList}?monitorId=${monitorDetail.monitorId}');
                      },
                      meta: Meta(
                        color: Color(0xFFFFB709),
                        title: '全部',
                        content: '${monitorDetail.orderTotalCount}',
                        imagePath: 'assets/images/icon_alarm_manage_all.png',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //异常申报信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '异常申报信息',
                  imagePath: 'assets/images/icon_outlet_report.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    InkWellButton7(
                      titleFontSize: 13,
                      contentFontSize: 19,
                      onTap: () {
                        Application.router.navigateTo(context,
                            '${Routes.dischargeReportList}?monitorId=${monitorDetail.monitorId}');
                      },
                      meta: Meta(
                        title: '排口异常申报总数',
                        content: '${monitorDetail.dischargeReportTotalCount}',
                        imagePath: 'assets/images/button_image1.png',
                        backgroundPath: 'assets/images/button_bg_green.png',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton7(
                      titleFontSize: 13,
                      contentFontSize: 19,
                      onTap: () {
                        Application.router.navigateTo(context,
                            '${Routes.factorReportList}?monitorId=${monitorDetail.monitorId}');
                      },
                      meta: Meta(
                        title: '因子异常申报总数',
                        content: '${monitorDetail.factorReportTotalCount}',
                        imagePath: 'assets/images/button_image4.png',
                        backgroundPath: 'assets/images/button_bg_pink.png',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //快速链接
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '快速链接',
                  imagePath: 'assets/images/icon_fast_link.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    InkWellButton7(
                      meta: Meta(
                          title: '企业信息',
                          content: '查看监控点所属的企业信息',
                          backgroundPath:
                              'assets/images/button_bg_lightblue.png',
                          imagePath:
                              'assets/images/image_enter_statistics1.png'),
                      onTap: () {
                        Application.router.navigateTo(context,
                            '${Routes.enterDetail}/${monitorDetail.enterId}');
                      },
                    ),
                    Gaps.hGap10,
                    InkWellButton7(
                      meta: Meta(
                          title: '排口信息',
                          content: '查看该监控点所属的排口信息',
                          backgroundPath: 'assets/images/button_bg_yellow.png',
                          imagePath:
                              'assets/images/image_enter_statistics2.png'),
                      onTap: () {
                        Application.router.navigateTo(context,
                            '${Routes.dischargeDetail}/${monitorDetail.dischargeId}');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
