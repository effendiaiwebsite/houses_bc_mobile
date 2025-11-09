import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/api_response.dart';
import '../models/appointment_model.dart';

final appointmentServiceProvider = Provider<AppointmentService>((ref) {
  return AppointmentService(ApiClient.instance);
});

class AppointmentService {
  final ApiClient _apiClient;

  AppointmentService(this._apiClient);

  /// Book a property viewing
  Future<Result<Appointment>> bookAppointment({
    required String zpid,
    required DateTime dateTime,
    required String type,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.post(
        '/appointments',
        data: {
          'zpid': zpid,
          'dateTime': dateTime.toIso8601String(),
          'type': type,
          'notes': notes,
        },
      );

      final appointment = Appointment.fromJson(response.data['appointment']);
      return Result.success(appointment);
    } catch (e) {
      return Result.failure('Failed to book appointment: ${e.toString()}');
    }
  }

  /// Get all appointments for current user
  Future<Result<List<Appointment>>> getAppointments() async {
    try {
      final response = await _apiClient.get('/appointments');

      final appointmentsList = (response.data['appointments'] as List)
          .map((json) => Appointment.fromJson(json))
          .toList();

      return Result.success(appointmentsList);
    } catch (e) {
      return Result.failure('Failed to fetch appointments: ${e.toString()}');
    }
  }

  /// Cancel an appointment
  Future<Result<void>> cancelAppointment(String appointmentId) async {
    try {
      await _apiClient.post(
        '/appointments/$appointmentId/cancel',
      );
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to cancel appointment: ${e.toString()}');
    }
  }
}
