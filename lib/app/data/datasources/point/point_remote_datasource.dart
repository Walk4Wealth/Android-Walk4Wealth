import 'package:dio/dio.dart';

import '../../../core/network/device_connection.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/error/error_type.dart';
import '../../../domain/entity/product.dart';
import '../../../domain/entity/vendor.dart';
import '../../../domain/usecases/auth/get_token.dart';
import '../../models/history_model.dart';
import '../../models/product_model.dart';
import '../../models/vendor_model.dart';

abstract interface class PointRemoteDatasource {
  Future<List<VendorModel>> getAllVendor();
  Future<Vendor> getVendorById(int id);
  Future<List<ProductModel>> getAllProduct();
  Future<Product> getProductById(int id);

  Future<void> reedemPoint({
    required int userId,
    required int productId,
  });

  Future<List<HistoryModel>> getTransactionHistory();
}

class PointRemoteDatasourceImpl implements PointRemoteDatasource {
  final GetToken _getToken;
  final DioClient _dioClient;
  final DeviceConnection _connection;

  PointRemoteDatasourceImpl({
    required GetToken getToken,
    required DioClient dioClient,
    required DeviceConnection connection,
  })  : _getToken = getToken,
        _dioClient = dioClient,
        _connection = connection;

  @override
  Future<List<VendorModel>> getAllVendor() async {
    if (await _connection.hasConnection()) {
      try {
        final response = await _dioClient.get(endpoint: '/vendor');

        // parsing data
        final vendros = (response.data['data'] as List<dynamic>)
            .map((data) => VendorModel.fromRemote(data))
            .toList();

        return vendros;
      } on DioException catch (e) {
        throw AppException.handle(e);
      } catch (e) {
        throw AppException.handle(e);
      }
    } else {
      throw ErrorType.NO_INTERNET_CONNECTION.getException();
    }
  }

  @override
  Future<Vendor> getVendorById(int id) async {
    if (await _connection.hasConnection()) {
      try {
        final response = await _dioClient.get(endpoint: '/vendor/$id');

        // parsing data
        final vendor = VendorModel.fromRemote(response.data['data']);

        return vendor;
      } on DioException catch (e) {
        throw AppException.handle(e);
      } catch (e) {
        throw AppException.handle(e);
      }
    } else {
      throw ErrorType.NO_INTERNET_CONNECTION.getException();
    }
  }

  @override
  Future<List<ProductModel>> getAllProduct() async {
    if (await _connection.hasConnection()) {
      try {
        final response = await _dioClient.get(endpoint: '/product');

        // parsing data
        final products = (response.data['data'] as List<dynamic>)
            .map((data) => ProductModel.fromRemote(data))
            .toList();

        return products;
      } on DioException catch (e) {
        throw AppException.handle(e);
      } catch (e) {
        throw AppException.handle(e);
      }
    } else {
      throw ErrorType.NO_INTERNET_CONNECTION.getException();
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    if (await _connection.hasConnection()) {
      try {
        final response = await _dioClient.get(endpoint: '/product/$id');

        // parsing data
        final product = ProductModel.fromRemote(response.data['data']);

        return product;
      } on DioException catch (e) {
        throw AppException.handle(e);
      } catch (e) {
        throw AppException.handle(e);
      }
    } else {
      throw ErrorType.NO_INTERNET_CONNECTION.getException();
    }
  }

  @override
  Future<void> reedemPoint({
    required int userId,
    required int productId,
  }) async {
    if (await _connection.hasConnection()) {
      try {
        // token
        final token = _getToken.call().token;

        // reedem poin
        await _dioClient.post(
          endpoint: '/transaction',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {'user_id': userId, 'vendor_product_id': productId},
        );
      } on DioException catch (e) {
        throw AppException.handle(e);
      } catch (e) {
        throw AppException.handle(e);
      }
    } else {
      throw ErrorType.NO_INTERNET_CONNECTION.getException();
    }
  }

  @override
  Future<List<HistoryModel>> getTransactionHistory() async {
    if (await _connection.hasConnection()) {
      try {
        // token
        final token = _getToken.call().token;

        // get transaction
        final response = await _dioClient.get(
          endpoint: '/transaction/history',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        // parsing data
        final histories = (response.data['data'] as List<dynamic>)
            .map((data) => HistoryModel.fromRemote(data))
            .toList();

        return histories;
      } on DioException catch (e) {
        throw AppException.handle(e);
      } catch (e) {
        throw Exception(e);
      }
    } else {
      throw ErrorType.NO_INTERNET_CONNECTION.getException();
    }
  }
}
