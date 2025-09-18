import 'package:gosharpsharp/core/utils/exports.dart';

class TransactionsService extends CoreService {
  Future<TransactionsService> init() async => this;

  Future<APIResponse> getAllTransactions(dynamic data) async {
    return await fetch(
        "/restaurants/transactions?${data['page']}&page_size=${data['per_page']}");
  }
  Future<APIResponse> getTransactionById(dynamic data) async {
    return await fetch("/restaurants/transactions/${data['id']}");
  }



  
}
