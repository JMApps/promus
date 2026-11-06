import 'package:equatable/equatable.dart';

class SleekEntity extends Equatable {
  const SleekEntity({
    required this.name,
    required this.duration,
    required this.progress,
  });

  final String name;
  final Duration duration;
  final double progress;

  String get timeText {
    final h = duration.inHours.toString().padLeft(2, '0');
    final m = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  List<Object?> get props => [
    name,
    duration,
    progress,
  ];
}
