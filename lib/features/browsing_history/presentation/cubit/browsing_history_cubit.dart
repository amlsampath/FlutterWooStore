import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/browsing_history_item.dart';
import '../../domain/usecases/add_product_to_history_usecase.dart';
import '../../domain/usecases/get_browsing_history_usecase.dart';

class BrowsingHistoryCubit extends Cubit<List<BrowsingHistoryItem>> {
  final AddProductToHistoryUseCase addProductToHistoryUseCase;
  final GetBrowsingHistoryUseCase getBrowsingHistoryUseCase;

  BrowsingHistoryCubit({
    required this.addProductToHistoryUseCase,
    required this.getBrowsingHistoryUseCase,
  }) : super([]);

  Future<void> loadBrowsingHistory() async {
    final history = await getBrowsingHistoryUseCase.execute();
    emit(history);
  }

  Future<void> addProductToHistory(BrowsingHistoryItem item) async {
    await addProductToHistoryUseCase.execute(item);
    await loadBrowsingHistory();
  }
}
