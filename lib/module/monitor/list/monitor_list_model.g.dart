// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitor_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Monitor _$MonitorFromJson(Map<String, dynamic> json) {
  return Monitor(
      monitorId: json['monitorId'] as int,
      enterName: json['enterpriseName'] as String,
      monitorName: json['disMonitorName'] as String,
      monitorAddress: json['disMonitorAddress'] as String,
      monitorType: json['disMonitorType'] as String,
      monitorCategoryStr: json['outletTypeStr'] as String);
}

Map<String, dynamic> _$MonitorToJson(Monitor instance) => <String, dynamic>{
      'monitorId': instance.monitorId,
      'enterpriseName': instance.enterName,
      'disMonitorName': instance.monitorName,
      'disMonitorAddress': instance.monitorAddress,
      'disMonitorType': instance.monitorType,
      'outletTypeStr': instance.monitorCategoryStr
    };
