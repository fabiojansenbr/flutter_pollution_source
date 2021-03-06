import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/common_model.dart';

part 'factor_report_detail_model.g.dart';

//因子异常申报单详情
@JsonSerializable()
class FactorReportDetail extends Equatable {
  @JsonKey(name: 'id')
  final int reportId; //排口异常申报ID
  final int enterId; //企业ID
  @JsonKey(name: 'outId')
  final int dischargeId; //排口ID
  final int monitorId; //监控点ID
  @JsonKey(name: 'enterpriseName')
  final String enterName; //企业名称
  @JsonKey(name: 'entAddress')
  final String enterAddress; //企业地址
  @JsonKey(name: 'disOutName')
  final String dischargeName; //排口名称
  @JsonKey(name: 'disMonitorName')
  final String monitorName; //监控点名称
  final String cityName; // 所属市
  final String areaName; // 所属区
  @JsonKey(name: 'updateTime')
  final String reportTimeStr; //申报时间
  @JsonKey(name: 'startTime')
  final String startTimeStr; //开始时间
  @JsonKey(name: 'endTime')
  final String endTimeStr; //结束时间
  final String alarmTypeStr; //报警类型
  final String exceptionReason; //异常原因
  @JsonKey(name: 'attachmentList')
  final List<Attachment> attachments; //证明材料

  const FactorReportDetail({
    this.reportId,
    this.enterId,
    this.dischargeId,
    this.monitorId,
    this.enterName,
    this.enterAddress,
    this.dischargeName,
    this.monitorName,
    this.cityName,
    this.areaName,
    this.reportTimeStr,
    this.startTimeStr,
    this.endTimeStr,
    this.alarmTypeStr,
    this.exceptionReason,
    this.attachments,
  });

  @override
  List<Object> get props => [
        reportId,
        enterId,
        dischargeId,
        monitorId,
        enterName,
        enterAddress,
        dischargeName,
        monitorName,
        cityName,
        areaName,
        reportTimeStr,
        startTimeStr,
        endTimeStr,
        alarmTypeStr,
        exceptionReason,
        attachments,
      ];

  // 所属区域
  String get districtName {
    return '${cityName ?? ''}${areaName ?? ''}';
  }

  factory FactorReportDetail.fromJson(Map<String, dynamic> json) =>
      _$FactorReportDetailFromJson(json);

  Map<String, dynamic> toJson() => _$FactorReportDetailToJson(this);
}
