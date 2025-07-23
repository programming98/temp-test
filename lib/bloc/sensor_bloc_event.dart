import 'package:interview_project/model/sensor.dart';

sealed class SensorBlocEvent {}

class InitializeSensorEvent extends SensorBlocEvent {}

class SearchSensorsEvent extends SensorBlocEvent {
  final String query;
  SearchSensorsEvent(this.query);
}

class ClearSearchEvent extends SensorBlocEvent {}

class UpdateSensorEvent extends SensorBlocEvent {
  final Sensor sensor;
  UpdateSensorEvent(this.sensor);
}
