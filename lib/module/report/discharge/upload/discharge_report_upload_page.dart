import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/dict/data_dict_bloc.dart';
import 'package:pollution_source/module/common/dict/data_dict_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_repository.dart';
import 'package:pollution_source/module/common/page/page_bloc.dart';
import 'package:pollution_source/module/common/page/page_event.dart';
import 'package:pollution_source/module/common/page/page_state.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';
import 'package:pollution_source/module/report/discharge/upload/discharge_report_upload_model.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/system_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';
import 'package:pollution_source/widget/data_dict_widget.dart';

class DischargeReportUploadPage extends StatefulWidget {
  final String enterId;

  DischargeReportUploadPage({@required this.enterId}) : assert(enterId != null);

  @override
  _DischargeReportUploadPageState createState() =>
      _DischargeReportUploadPageState();
}

class _DischargeReportUploadPageState extends State<DischargeReportUploadPage> {
  PageBloc _pageBloc;
  UploadBloc _uploadBloc;
  DataDictBloc _stopTypeBloc;
  TextEditingController _stopReasonController;

  @override
  void initState() {
    super.initState();
    _pageBloc = BlocProvider.of<PageBloc>(context);
    //初始化界面
    _pageBloc.add(PageLoad(model: DischargeReportUpload()));
    _uploadBloc = BlocProvider.of<UploadBloc>(context);
    _stopTypeBloc = DataDictBloc(
        dataDictRepository:
            DataDictRepository(HttpApi.dischargeReportStopTypeList));
    _stopTypeBloc.add(DataDictLoad());
    _stopReasonController = TextEditingController();
  }

  @override
  void dispose() {
    //释放资源
    _stopReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      body: EasyRefresh.custom(
        slivers: <Widget>[
          UploadHeaderWidget(
            title: '排口异常申报上报',
            subTitle: '''1、异常申报一天，起止时间写同一天；
2、异常申报两天（如2号、3号），开始写2号，结束写3号；
3、在尊重事实的情况下，尽量将预计结束时间设置大的范围； 
4、异常解决之后，可以根据实际情况申请更改实际结束时间；
5、申报证明材料加盖企业公章。''',
            imagePath: 'assets/images/discharge_report_upload_header_image.png',
            backgroundColor: Colors.lightBlueAccent,
          ),
          MultiBlocListener(
            listeners: [
              BlocListener<UploadBloc, UploadState>(
                listener: uploadListener,
              ),
              BlocListener<UploadBloc, UploadState>(
                listener: (context, state) {
                  //提交成功后重置界面
                  if (state is UploadSuccess) {
                    _stopReasonController.text = '';
                    _pageBloc.add(PageLoad(model: DischargeReportUpload()));
                  }
                },
              ),
            ],
            child: BlocBuilder<PageBloc, PageState>(
              builder: (context, state) {
                if (state is PageLoaded) {
                  return _buildPageLoadedDetail(state.model, state);
                } else {
                  return ErrorSliver(
                      errorMessage: 'BlocBuilder监听到未知的的状态！state=$state');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedDetail(
      DischargeReportUpload reportUpload, PageLoaded pageLoadedState) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                EditRowWidget(
                  title: '排口名称',
                  hintText: '请选择排口',
                  readOnly: true,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      // 设置内容
                      text: '${reportUpload?.discharge?.dischargeName ?? ''}',
                    ),
                  ),
                  onTap: () async {
                    Discharge discharge = await Application.router.navigateTo(
                        context,
                        '${Routes.dischargeList}?enterId=${widget.enterId}&type=1');
                    //重新选择排口后重置已经选择的监控点
                    _pageBloc.add(
                      PageLoad(
                        model: reportUpload.copyWith(
                            discharge: discharge, monitor: null),
                      ),
                    );
                  },
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '监控点名',
                  hintText: '请选择监控点',
                  readOnly: true,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      // 设置内容
                      text: '${reportUpload?.monitor?.monitorName ?? ''}',
                    ),
                  ),
                  onTap: () async {
                    Monitor monitor = await Application.router.navigateTo(
                        context,
                        '${Routes.monitorList}?enterId=${widget.enterId}&type=1');
                    _pageBloc.add(
                      PageLoad(
                        model: reportUpload.copyWith(monitor: monitor),
                      ),
                    );
                  },
                ),
                Gaps.hLine,
                DataDictWidget(
                  title: '停产类型',
                  content: reportUpload?.stopType?.name,
                  dataDictBloc: _stopTypeBloc,
                  onSelected: (DataDict result) {
                    _pageBloc.add(
                      PageLoad(
                        model: reportUpload.copyWith(stopType: result),
                      ),
                    );
                  },
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '申报时间',
                  hintText: '请选择申报时间',
                  readOnly: true,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      // 设置内容
                      text:
                          '${DateUtil.formatDate(reportUpload?.reportTime, format: 'yyyy-MM-dd')}',
                    ),
                  ),
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        locale: DateTimePickerLocale.zh_cn,
                        onClose: () {}, onConfirm: (dateTime, selectedIndex) {
                      _pageBloc.add(
                        PageLoad(
                          model: reportUpload.copyWith(reportTime: dateTime),
                        ),
                      );
                    });
                  },
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '开始时间',
                  hintText: '请选择开始时间',
                  readOnly: true,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      // 设置内容
                      text:
                          '${DateUtil.formatDate(reportUpload?.startTime, format: 'yyyy-MM-dd HH:mm:ss')}',
                    ),
                  ),
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        locale: DateTimePickerLocale.zh_cn,
                        pickerMode: DateTimePickerMode.datetime,
                        onClose: () {}, onConfirm: (dateTime, selectedIndex) {
                      _pageBloc.add(
                        PageLoad(
                          model: reportUpload.copyWith(startTime: dateTime),
                        ),
                      );
                    });
                  },
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '结束时间',
                  hintText: '请选择结束时间',
                  readOnly: true,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      // 设置内容
                      text:
                          '${DateUtil.formatDate(reportUpload?.endTime, format: 'yyyy-MM-dd HH:mm:ss')}',
                    ),
                  ),
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        locale: DateTimePickerLocale.zh_cn,
                        pickerMode: DateTimePickerMode.datetime,
                        onClose: () {}, onConfirm: (dateTime, selectedIndex) {
                      _pageBloc.add(
                        PageLoad(
                          model: reportUpload.copyWith(endTime: dateTime),
                        ),
                      );
                    });
                  },
                ),
                Gaps.hLine,
                TextAreaWidget(
                  title: '停产描述',
                  hintText: '请使用一句话简单概括停产的原因',
                  controller: _stopReasonController,
                ),
              ],
            ),
          ),
          Gaps.vGap5,
          Offstage(
            offstage: reportUpload?.attachments == null ||
                reportUpload.attachments.length == 0,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              childAspectRatio: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              children: List.generate(
                reportUpload?.attachments == null
                    ? 0
                    : reportUpload.attachments.length,
                (index) {
                  Asset asset = reportUpload.attachments[index];
                  return AssetThumb(
                    asset: asset,
                    width: 300,
                    height: 300,
                  );
                },
              ),
            ),
          ),
          Gaps.vGap5,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                ClipButton(
                  text: '选择图片',
                  icon: Icons.image,
                  color: Colors.green,
                  onTap: () async {
                    _pageBloc.add(
                      PageLoad(
                        model: reportUpload.copyWith(
                          attachments: await SystemUtils.loadAssets(
                              reportUpload.attachments),
                        ),
                      ),
                    );
                  },
                ),
                Gaps.hGap20,
                ClipButton(
                  text: '提交',
                  icon: Icons.file_upload,
                  color: Colors.lightBlue,
                  onTap: () {
                    _uploadBloc.add(Upload(
                        data: reportUpload.copyWith(
                      enterId: widget.enterId,
                      stopReason: _stopReasonController.text,
                    )));
                  },
                ),
              ],
            ),
          ),
          Gaps.vGap20,
        ],
      ),
    );
  }
}
