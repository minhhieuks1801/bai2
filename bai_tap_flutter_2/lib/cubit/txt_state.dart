part of 'txt_cubit.dart';

enum TxtStatus {init, start, success, error}
class TxtState extends Equatable {

  final List<Txt> txts;
  final Enum status;
  const TxtState({this.txts = const [], this.status = TxtStatus.init});

  TxtState copyWith({List<Txt>? txts, Enum? status}) {
    return TxtState(
      txts: txts ?? this.txts,
      status: status?? this.status,
    );
  }
  @override
  List<Object> get props => [txts, status];
}
