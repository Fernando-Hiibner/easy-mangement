class ExpensesModel {
  final int id;
  final int userId;
  final String period;
  final DateTime date;
  final double value;

  const ExpensesModel({
    required this.id,
    required this.userId,
    required this.period,
    required this.date,
    required this.value,
  });

  factory ExpensesModel.fromMap(Map<String, dynamic> json) => ExpensesModel(
      id: json['id'],
      userId: json['userId'],
      period: json['period'],
      date: DateTime.parse(json['date']),
      value: double.parse(json['value'].toString()));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'period': period,
      'date': date,
      'value': value
    };
  }
}
