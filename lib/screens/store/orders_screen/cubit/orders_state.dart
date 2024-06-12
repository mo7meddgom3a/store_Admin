
import 'package:anwer_shop_admin/screens/store/orders_screen/models/order_model.dart';
import 'package:equatable/equatable.dart';

class OrdersState extends Equatable{
  final List<OrderModel> orders;
  OrdersState(this.orders);


  OrdersState copyWith({
    List<OrderModel>? orders,
  }) {
    return OrdersState(
      orders ?? this.orders,
    );
  }
  @override
  // TODO: implement props
  List<Object?> get props => [orders];

}

class OrdersLoading extends OrdersState {
  OrdersLoading(List<OrderModel> orders) : super(orders);
}

class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;

  OrdersLoaded(this.orders) : super(orders);
}

class OrdersError extends OrdersState {
  final String errorMessage;

  OrdersError(this.errorMessage) : super([]);
}
