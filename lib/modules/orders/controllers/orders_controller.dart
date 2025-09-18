
import 'package:gosharpsharp/core/models/order_model.dart';
import 'package:gosharpsharp/core/services/restaurant/orders/orders_service.dart';
import '../../../core/utils/exports.dart';

class OrdersController extends GetxController {
  // Orders Service Instance
  final OrdersService _ordersService = serviceLocator<OrdersService>();

  // Loading states
  bool isLoading = false;
  bool isLoadingOrders = false;

  void setLoadingState(bool val) {
    isLoading = val;
    update();
  }

  setOrdersLoadingState(bool val) {
    isLoadingOrders = val;
    update();
  }

  // Orders list
  List<OrderModel> allOrders = [];
  List<OrderModel> filteredOrders = [];

  // Current selected order
  OrderModel? selectedOrder;

  // Order status filter - Updated to match API statuses
  String selectedOrderStatus = 'pending';
  List<String> orderStatuses = ['pending', 'preparing', 'ready', 'in_transit', 'completed'];

  setSelectedOrderStatus(String status) {
    selectedOrderStatus = status;
    filterOrdersByStatus();
    update();
  }

  // Set selected order for details screen
  setSelectedOrder(OrderModel order) {
    selectedOrder = order;
    update();
  }

  // Filter orders by status
  void filterOrdersByStatus() {
    filteredOrders = allOrders
        .where((order) => order.status.toLowerCase() == selectedOrderStatus.toLowerCase())
        .toList();
  }

  // Get orders from API - UPDATED WITH API INTEGRATION
  getOrders() async {
    setOrdersLoadingState(true);

    try {
      final response = await _ordersService.getAllOrders({
        'page': 'page=1',
        'per_page': 50,
      });

      if (response.status=="success" && response.data != null) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> ordersData = responseData['data'] ?? [];

        allOrders = ordersData.map((json) => OrderModel.fromJson(json)).toList();
        filterOrdersByStatus();
      } else {
        // Keep existing sample data as fallback
        if (allOrders.isEmpty) {
          filterOrdersByStatus();
        }

        if (response.message.isNotEmpty && response.message.isNotEmpty) {
          showToast(
            message: response.message,
            isError: true,
          );
        }
      }
    } catch (e) {
      // Keep existing sample data as fallback
      if (allOrders.isEmpty) {
        filterOrdersByStatus();
      }
      showToast(
        message: "Error loading orders: ${e.toString()}",
        isError: true,
      );
    } finally {
      setOrdersLoadingState(false);
    }
  }



  // Update order status - UPDATED WITH API INTEGRATION
  updateOrderStatus(int orderId, String newStatus) async {
    setLoadingState(true);

    try {
      // Prepare data in the required format
      final Map<String, dynamic> statusData = {
        "status": newStatus.toLowerCase(),
      };

      // Call the API
      final response = await _ordersService.updateOrder(statusData, orderId);

      if (response.status=="success") {
        // Update in local list
        int index = allOrders.indexWhere((order) => order.id == orderId);
        if (index != -1) {
          DateTime now = DateTime.now();

          allOrders[index] = allOrders[index].copyWith(
            status: newStatus,
            updatedAt: now,
            // Set status-specific timestamps based on the new status
            confirmedAt: newStatus.toLowerCase() == 'preparing' && allOrders[index].confirmedAt == null
                ? now
                : allOrders[index].confirmedAt,
            completedAt: newStatus.toLowerCase() == 'completed' && allOrders[index].completedAt == null
                ? now
                : allOrders[index].completedAt,
            cancelledAt: newStatus.toLowerCase() == 'cancelled' && allOrders[index].cancelledAt == null
                ? now
                : allOrders[index].cancelledAt,
          );

          // Update selected order if it's the same
          if (selectedOrder?.id == orderId) {
            selectedOrder = allOrders[index];
          }
        }

        filterOrdersByStatus();
        showToast(
          message: "Order status updated to ${_getStatusDisplayText(newStatus)}",
          isError: false,
        );
      } else {
        showToast(
          message: response.message ?? "Failed to update order status",
          isError: true,
        );
      }
    } catch (e) {
      showToast(
        message: "Error updating order status: ${e.toString()}",
        isError: true,
      );
    } finally {
      setLoadingState(false);
    }
  }

  // Alternative method if you prefer to update by order reference
  updateOrderStatusByRef(String orderRef, String newStatus) async {
    // Find order by reference first
    final order = allOrders.firstWhereOrNull((order) => order.ref == orderRef);
    if (order != null) {
      await updateOrderStatus(order.id, newStatus);
    } else {
      showToast(message: "Order not found", isError: true);
    }
  }

  // Helper method for status display text
  String _getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'preparing':
        return 'Preparing';
      case 'ready':
        return 'Ready';
      case 'in_transit':
        return 'In Transit';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.toUpperCase();
    }
  }

  // Enhanced method with status transition validation
  updateOrderStatusWithValidation(int orderId, String newStatus) async {
    setLoadingState(true);

    try {
      // Find the order
      int index = allOrders.indexWhere((order) => order.id == orderId);
      if (index == -1) {
        showToast(message: "Order not found", isError: true);
        return;
      }

      String currentStatus = allOrders[index].status.toLowerCase();
      String targetStatus = newStatus.toLowerCase();

      // Validate status transition (optional - customize based on your business logic)
      if (!_isValidStatusTransition(currentStatus, targetStatus)) {
        showToast(message: "Invalid status transition from $currentStatus to $targetStatus", isError: true);
        return;
      }

      // Call the regular update method
      await updateOrderStatus(orderId, newStatus);
    } catch (e) {
      showToast(message: "Error updating order status: ${e.toString()}", isError: true);
    } finally {
      setLoadingState(false);
    }
  }

  // Helper method to validate status transitions
  bool _isValidStatusTransition(String currentStatus, String newStatus) {
    // Define valid transitions based on your business logic
    Map<String, List<String>> validTransitions = {
      'pending': ['preparing', 'cancelled'],
      'preparing': ['ready', 'cancelled'],
      'ready': ['in_transit', 'completed', 'cancelled'],
      'in_transit': ['completed'],
      'completed': [], // No transitions from completed
      'cancelled': [], // No transitions from cancelled
    };

    return validTransitions[currentStatus]?.contains(newStatus) ?? false;
  }

  // Specific order action methods - UPDATED WITH NEW STATUSES
  acceptOrder(int orderId) async {
    await updateOrderStatus(orderId, "preparing");
  }

  // Start processing order (renamed from startProcessingOrder for clarity)
  startPreparingOrder(int orderId) async {
    await updateOrderStatus(orderId, "preparing");
  }

  // Mark order as ready
  markOrderReady(int orderId) async {
    await updateOrderStatus(orderId, "ready");
  }

  // Mark order as in transit
  markOrderInTransit(int orderId) async {
    await updateOrderStatus(orderId, "in_transit");
  }

  // Complete order
  completeOrder(int orderId) async {
    await updateOrderStatus(orderId, "completed");
  }

  // Cancel order
  cancelOrder(int orderId) async {
    await updateOrderStatus(orderId, "cancelled");
  }

  // Reject order (for pending orders)
  rejectOrder(int orderId) async {
    await cancelOrder(orderId);
    Get.back(); // Go back if on order details screen
  }

  // Get single order by ID - NEW METHOD
  getOrderById(int orderId) async {
    setLoadingState(true);

    try {
      final response = await _ordersService.getOrderById({'id': orderId});

      if (response.status=="success" && response.data != null) {
        final orderData = response.data;
        final order = OrderModel.fromJson(orderData);

        // Update the order in local list if it exists
        int index = allOrders.indexWhere((o) => o.id == orderId);
        if (index != -1) {
          allOrders[index] = order;
        }

        setSelectedOrder(order);
        return order;
      } else {
        showToast(
          message: response.message ?? "Failed to load order details",
          isError: true,
        );
        return null;
      }
    } catch (e) {
      showToast(
        message: "Error loading order details: ${e.toString()}",
        isError: true,
      );
      return null;
    } finally {
      setLoadingState(false);
    }
  }

  // Get order count by status
  int getOrderCountByStatus(String status) {
    return allOrders.where((order) => order.status.toLowerCase() == status.toLowerCase()).length;
  }

  // Format order time
  String formatOrderTime(DateTime orderDate) {
    final now = DateTime.now();
    final difference = now.difference(orderDate);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else {
      return "${difference.inDays}d ago";
    }
  }

  // Format currency
  String formatCurrency(double amount) {
    return "₦${amount.toStringAsFixed(2)}";
  }

  // Get next action for order based on current status - UPDATED
  String getNextAction(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'pending':
        return 'Accept Order';
      case 'preparing':
        return 'Mark as Ready';
      case 'ready':
        return 'Mark In Transit';
      case 'in_transit':
        return 'Complete Order';
      default:
        return 'View Order';
    }
  }

  // Get next status for order - UPDATED
  String getNextStatus(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'pending':
        return 'preparing';
      case 'preparing':
        return 'ready';
      case 'ready':
        return 'in_transit';
      case 'in_transit':
        return 'completed';
      default:
        return currentStatus;
    }
  }

  // Refresh orders
  refreshOrders() async {
    await getOrders();
  }

  @override
  void onInit() {
    super.onInit();
    // getOrders();
  }

  @override
  void onClose() {
    super.onClose();
  }
}