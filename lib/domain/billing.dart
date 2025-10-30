import 'patient.dart';

class Billing {
  int? billId;
  Patient? patient;
  double total;
  double paid;
  String status;

  Billing({
    this.billId,
    this.patient,
    required this.total,
    required this.paid,
    required this.status,
  });

  factory Billing.fromJson(Map<String, dynamic> json) => Billing(
        billId: json['bill_id'],
        patient: json['patient'] != null
            ? Patient.fromJson(json['patient'])
            : null,
        total: (json['total'] as num).toDouble(),
        paid: (json['paid'] as num).toDouble(),
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'bill_id': billId,
        'patient': patient?.toJson(),
        'total': total,
        'paid': paid,
        'status': status,
      };
}
