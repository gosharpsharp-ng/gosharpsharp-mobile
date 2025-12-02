import 'package:flutter/material.dart';

/// Service type enum representing different types of services
/// available in the GoSharpSharp customer app
enum ServiceType {
  /// Food delivery from restaurants
  restaurant,

  /// Parcel/package delivery
  parcel,

  /// Pharmacy and beauty products
  pharmacy,

  /// Grocery shopping
  grocery,

  /// General shopping/retail
  shopping,
}

/// Extension to provide service-specific configurations and labels
extension ServiceTypeExtension on ServiceType {
  /// Whether this service is currently available in the app
  bool get isAvailable {
    switch (this) {
      case ServiceType.restaurant:
      case ServiceType.parcel:
        return true;
      case ServiceType.pharmacy:
      case ServiceType.grocery:
      case ServiceType.shopping:
        return false; // Coming soon
    }
  }

  /// API endpoint prefix for this service type
  String get apiEndpoint {
    switch (this) {
      case ServiceType.restaurant:
        return 'restaurants';
      case ServiceType.parcel:
        return 'deliveries';
      case ServiceType.pharmacy:
        return 'pharmacies';
      case ServiceType.grocery:
        return 'grocery-stores';
      case ServiceType.shopping:
        return 'shops';
    }
  }

  /// Display name for this service type (singular)
  String get displayName {
    switch (this) {
      case ServiceType.restaurant:
        return 'Restaurant';
      case ServiceType.parcel:
        return 'Parcel Delivery';
      case ServiceType.pharmacy:
        return 'Pharmacy';
      case ServiceType.grocery:
        return 'Grocery Store';
      case ServiceType.shopping:
        return 'Shop';
    }
  }

  /// Display name for this service type (plural)
  String get displayNamePlural {
    switch (this) {
      case ServiceType.restaurant:
        return 'Restaurants';
      case ServiceType.parcel:
        return 'Parcel Deliveries';
      case ServiceType.pharmacy:
        return 'Pharmacies';
      case ServiceType.grocery:
        return 'Grocery Stores';
      case ServiceType.shopping:
        return 'Shops';
    }
  }

  /// Short display name for UI elements
  String get shortName {
    switch (this) {
      case ServiceType.restaurant:
        return 'Food';
      case ServiceType.parcel:
        return 'Parcel';
      case ServiceType.pharmacy:
        return 'Pharmacy';
      case ServiceType.grocery:
        return 'Groceries';
      case ServiceType.shopping:
        return 'Shopping';
    }
  }

  /// Label for vendor/business in this service type
  String get vendorLabel {
    switch (this) {
      case ServiceType.restaurant:
        return 'Restaurant';
      case ServiceType.parcel:
        return 'Courier';
      case ServiceType.pharmacy:
        return 'Pharmacy';
      case ServiceType.grocery:
        return 'Store';
      case ServiceType.shopping:
        return 'Shop';
    }
  }

  /// Label for vendors/businesses (plural) in this service type
  String get vendorLabelPlural {
    switch (this) {
      case ServiceType.restaurant:
        return 'Restaurants';
      case ServiceType.parcel:
        return 'Couriers';
      case ServiceType.pharmacy:
        return 'Pharmacies';
      case ServiceType.grocery:
        return 'Stores';
      case ServiceType.shopping:
        return 'Shops';
    }
  }

  /// Label for product/item in this service type
  String get productLabel {
    switch (this) {
      case ServiceType.restaurant:
        return 'Menu Item';
      case ServiceType.parcel:
        return 'Package';
      case ServiceType.pharmacy:
        return 'Medicine';
      case ServiceType.grocery:
        return 'Product';
      case ServiceType.shopping:
        return 'Item';
    }
  }

  /// Label for products/items (plural) in this service type
  String get productLabelPlural {
    switch (this) {
      case ServiceType.restaurant:
        return 'Menu Items';
      case ServiceType.parcel:
        return 'Packages';
      case ServiceType.pharmacy:
        return 'Medicines';
      case ServiceType.grocery:
        return 'Products';
      case ServiceType.shopping:
        return 'Items';
    }
  }

  /// Label for the catalog/menu section
  String get catalogLabel {
    switch (this) {
      case ServiceType.restaurant:
        return 'Menu';
      case ServiceType.parcel:
        return 'Services';
      case ServiceType.pharmacy:
        return 'Inventory';
      case ServiceType.grocery:
        return 'Products';
      case ServiceType.shopping:
        return 'Catalog';
    }
  }

  /// Category type label for this service
  String get categoryTypeLabel {
    switch (this) {
      case ServiceType.restaurant:
        return 'Cuisine Type';
      case ServiceType.parcel:
        return 'Delivery Type';
      case ServiceType.pharmacy:
        return 'Pharmacy Type';
      case ServiceType.grocery:
        return 'Store Type';
      case ServiceType.shopping:
        return 'Shop Type';
    }
  }

  /// Order statuses specific to this service type
  List<String> get orderStatuses {
    switch (this) {
      case ServiceType.restaurant:
        return [
          'pending',
          'confirmed',
          'preparing',
          'ready',
          'picked_up',
          'delivered',
          'cancelled',
        ];
      case ServiceType.parcel:
        return [
          'pending',
          'confirmed',
          'picked_up',
          'in_transit',
          'delivered',
          'cancelled',
        ];
      case ServiceType.pharmacy:
        return [
          'pending',
          'confirmed',
          'processing',
          'ready',
          'picked_up',
          'delivered',
          'cancelled',
        ];
      case ServiceType.grocery:
        return [
          'pending',
          'confirmed',
          'packing',
          'ready',
          'picked_up',
          'delivered',
          'cancelled',
        ];
      case ServiceType.shopping:
        return [
          'pending',
          'confirmed',
          'processing',
          'ready',
          'picked_up',
          'delivered',
          'cancelled',
        ];
    }
  }

  /// Preparation status label for this service type
  String get preparationStatusLabel {
    switch (this) {
      case ServiceType.restaurant:
        return 'Preparing';
      case ServiceType.parcel:
        return 'Processing';
      case ServiceType.pharmacy:
        return 'Processing';
      case ServiceType.grocery:
        return 'Packing';
      case ServiceType.shopping:
        return 'Processing';
    }
  }

  /// Whether this service type has preparation time for items
  bool get hasPreparationTime {
    switch (this) {
      case ServiceType.restaurant:
        return true;
      case ServiceType.parcel:
      case ServiceType.pharmacy:
      case ServiceType.grocery:
      case ServiceType.shopping:
        return false;
    }
  }

  /// Whether this service type uses portion/plate sizes
  bool get hasPortionSizes {
    switch (this) {
      case ServiceType.restaurant:
        return true;
      case ServiceType.parcel:
      case ServiceType.pharmacy:
      case ServiceType.grocery:
      case ServiceType.shopping:
        return false;
    }
  }

  /// Whether this service type supports add-ons
  bool get supportsAddons {
    switch (this) {
      case ServiceType.restaurant:
        return true;
      case ServiceType.parcel:
      case ServiceType.pharmacy:
      case ServiceType.grocery:
      case ServiceType.shopping:
        return false;
    }
  }

  /// Whether this service type supports delivery
  bool get supportsDelivery => true;

  /// Whether this service type has a cart/checkout flow
  bool get hasCartFlow {
    switch (this) {
      case ServiceType.restaurant:
      case ServiceType.pharmacy:
      case ServiceType.grocery:
      case ServiceType.shopping:
        return true;
      case ServiceType.parcel:
        return false; // Parcel has its own flow
    }
  }

  /// Label for the preparation time field
  String get preparationTimeLabel {
    switch (this) {
      case ServiceType.restaurant:
        return 'Prep Time';
      case ServiceType.parcel:
        return 'Delivery Time';
      case ServiceType.pharmacy:
      case ServiceType.grocery:
      case ServiceType.shopping:
        return 'Processing Time';
    }
  }

  /// Icon for this service type
  IconData get icon {
    switch (this) {
      case ServiceType.restaurant:
        return Icons.restaurant_menu;
      case ServiceType.parcel:
        return Icons.local_shipping;
      case ServiceType.pharmacy:
        return Icons.local_pharmacy;
      case ServiceType.grocery:
        return Icons.local_grocery_store;
      case ServiceType.shopping:
        return Icons.shopping_bag;
    }
  }

  /// Parse service type from string (API response)
  static ServiceType fromString(String? value) {
    if (value == null) return ServiceType.restaurant;

    switch (value.toLowerCase()) {
      case 'restaurant':
      case 'food':
        return ServiceType.restaurant;
      case 'parcel':
      case 'delivery':
      case 'parcel_delivery':
        return ServiceType.parcel;
      case 'pharmacy':
        return ServiceType.pharmacy;
      case 'grocery':
      case 'grocery_store':
      case 'grocerystore':
      case 'grocery-store':
        return ServiceType.grocery;
      case 'shopping':
      case 'shop':
      case 'retail':
        return ServiceType.shopping;
      default:
        return ServiceType.restaurant;
    }
  }

  /// Convert to string for API requests
  String toApiString() {
    switch (this) {
      case ServiceType.restaurant:
        return 'restaurant';
      case ServiceType.parcel:
        return 'parcel';
      case ServiceType.pharmacy:
        return 'pharmacy';
      case ServiceType.grocery:
        return 'grocery';
      case ServiceType.shopping:
        return 'shopping';
    }
  }
}

/// Global service configuration manager for the customer app
class ServiceConfigManager {
  static final ServiceConfigManager _instance = ServiceConfigManager._internal();
  factory ServiceConfigManager() => _instance;
  ServiceConfigManager._internal();

  /// Current active service type - defaults to restaurant
  ServiceType _currentServiceType = ServiceType.restaurant;

  /// Get the current service type
  ServiceType get currentServiceType => _currentServiceType;

  /// Set the current service type
  void setServiceType(ServiceType type) {
    _currentServiceType = type;
  }

  /// Initialize service type from string (API response)
  void initialize(String? serviceTypeString) {
    _currentServiceType = ServiceTypeExtension.fromString(serviceTypeString);
  }

  /// Reset to default service type (restaurant)
  void reset() {
    _currentServiceType = ServiceType.restaurant;
  }

  /// Check if the current service is available
  bool get isCurrentServiceAvailable => _currentServiceType.isAvailable;

  /// Get the API endpoint prefix for the current service
  String get apiEndpoint => _currentServiceType.apiEndpoint;

  /// Get display name for current service type
  String get displayName => _currentServiceType.displayName;

  /// Get display name plural
  String get displayNamePlural => _currentServiceType.displayNamePlural;

  /// Get short name for UI
  String get shortName => _currentServiceType.shortName;

  /// Get vendor label
  String get vendorLabel => _currentServiceType.vendorLabel;

  /// Get vendor label plural
  String get vendorLabelPlural => _currentServiceType.vendorLabelPlural;

  /// Get product label
  String get productLabel => _currentServiceType.productLabel;

  /// Get product label plural
  String get productLabelPlural => _currentServiceType.productLabelPlural;

  /// Get catalog label
  String get catalogLabel => _currentServiceType.catalogLabel;

  /// Get category type label
  String get categoryTypeLabel => _currentServiceType.categoryTypeLabel;

  /// Get order statuses
  List<String> get orderStatuses => _currentServiceType.orderStatuses;

  /// Get preparation status label
  String get preparationStatusLabel => _currentServiceType.preparationStatusLabel;

  /// Get preparation time label
  String get preparationTimeLabel => _currentServiceType.preparationTimeLabel;

  /// Check if current service supports add-ons
  bool get supportsAddons => _currentServiceType.supportsAddons;

  /// Check if current service has preparation time
  bool get hasPreparationTime => _currentServiceType.hasPreparationTime;

  /// Check if current service has portion sizes
  bool get hasPortionSizes => _currentServiceType.hasPortionSizes;

  /// Check if current service supports delivery
  bool get supportsDelivery => _currentServiceType.supportsDelivery;

  /// Check if current service has cart flow
  bool get hasCartFlow => _currentServiceType.hasCartFlow;

  /// Get icon for current service type
  IconData get icon => _currentServiceType.icon;

  // ============ UI Label Helpers ============

  /// Get browse label (e.g., "Browse Restaurants", "Send Parcel")
  String get browseLabel {
    if (_currentServiceType == ServiceType.parcel) {
      return 'Send Parcel';
    }
    return 'Browse $vendorLabelPlural';
  }

  /// Get search placeholder
  String get searchPlaceholder {
    if (_currentServiceType == ServiceType.parcel) {
      return 'Track your parcel...';
    }
    return 'Search $vendorLabelPlural...';
  }

  /// Get empty state message
  String get emptyStateMessage {
    if (_currentServiceType == ServiceType.parcel) {
      return 'No deliveries yet';
    }
    return 'No $vendorLabelPlural found nearby';
  }

  /// Get coming soon message for unavailable services
  static String getComingSoonMessage(ServiceType type) {
    return '${type.displayName} is coming soon!';
  }
}

/// Convenience getter for service config manager
ServiceConfigManager get serviceConfig => ServiceConfigManager();
