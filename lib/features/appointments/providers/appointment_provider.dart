import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/appointment_model.dart';
import '../services/appointment_service.dart';

final appointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final appointmentService = ref.watch(appointmentServiceProvider);
  final result = await appointmentService.getAppointments();

  if (result.isSuccess) {
    return result.data!;
  } else {
    throw Exception(result.error);
  }
});
