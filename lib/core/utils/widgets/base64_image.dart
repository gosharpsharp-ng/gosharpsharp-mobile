import 'package:gosharpsharp/core/utils/exports.dart';

class Base64Image extends StatelessWidget {
  final String base64String;

  Base64Image({required this.base64String});

  @override
  Widget build(BuildContext context) {
    Uint8List imageBytes = base64Decode(base64String);
    return Image.memory(
      imageBytes,
      fit: BoxFit.cover,
    );
  }
}

MemoryImage base64ToMemoryImage(String base64String) {
  String cleanBase64 = base64String.contains(',')
      ? base64String.split(',').last
      : base64String;
  Uint8List bytes = base64Decode(cleanBase64);
  return MemoryImage(bytes);
}

double getDeliveryProgress(String status) {
  switch (status.capitalizeFirst) {
    case 'Pending':
      return 0.0;
    case 'Confirmed':
      return 0.33;
    case 'Picked':
      return 0.67;
    case 'Delivered':
      return 1.0;
    case 'Accepted':
      return 0.2; // Assuming 'Accepted' is somewhere between 'Pending' and 'Confirmed'
    default:
      return 0.0; // Default case if status is unknown
  }
}