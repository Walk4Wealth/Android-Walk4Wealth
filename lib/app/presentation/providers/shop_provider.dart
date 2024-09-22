import 'dart:developer';

import 'package:flutter/material.dart';

import '../../core/enum/request_state.dart';
import '../../domain/entity/product.dart';
import '../../domain/entity/vendor.dart';
import '../../domain/usecases/point/get_all_product.dart';
import '../../domain/usecases/point/get_all_vendor.dart';
import '../../domain/usecases/point/get_product_by_id.dart';
import '../../domain/usecases/point/get_vendor_by_id.dart';

class ShopProvider extends ChangeNotifier {
  // use case
  final GetAllVendor _getAllVendor;
  final GetAllProduct _getAllProduct;
  final GetVendorById _getVendorById;
  final GetProductById _getProductById;

  ShopProvider({
    required GetAllVendor getAllVendor,
    required GetAllProduct getAllProduct,
    required GetVendorById getVendorById,
    required GetProductById getProductById,
  })  : _getAllVendor = getAllVendor,
        _getAllProduct = getAllProduct,
        _getVendorById = getVendorById,
        _getProductById = getProductById;

  RequestState _getAllVendorState = RequestState.LOADING;
  RequestState get getAllVendorState => _getAllVendorState;

  RequestState _getVendorByIdState = RequestState.LOADING;
  RequestState get getVendorByIdState => _getVendorByIdState;

  RequestState _getAllProductState = RequestState.LOADING;
  RequestState get getAllProductState => _getAllProductState;

  RequestState _getProductByIdState = RequestState.LOADING;
  RequestState get getProductByIdState => _getProductByIdState;

  Vendor? _vendor;
  Vendor? get vendor => _vendor;

  Product? _product;
  Product? get product => _product;

  var _vendors = <Vendor>[];
  List<Vendor> get vendors => _vendors;

  var _products = <Product>[];
  List<Product> get products => _products;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int getProductExpiration(String? date) {
    if (date == null || date.isEmpty) {
      return 0;
    }
    final now = DateTime.now();
    final expDay = DateTime.parse(date);

    return expDay.difference(now).inDays;
  }

  void showProductTerms(BuildContext context, Product? product) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // title
            Text(
              'Terms',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // terms
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: product?.terms.length,
                itemBuilder: (context, index) {
                  final term = product?.terms[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 20,
                      child: Text('${term?.number ?? 0}'),
                    ),
                    title: Text(term?.description ?? ''),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  //* get all vendor
  Future<void> getAllVendor() async {
    // loading
    _getAllVendorState = RequestState.LOADING;
    notifyListeners();

    // get all vendor
    final allVendor = await _getAllVendor.call();

    // state
    allVendor.fold(
      (failure) {
        log('semua data vendor gagal di get');
        _getAllVendorState = RequestState.FAILURE;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (vendors) {
        log('semua data vendor berhasil di get');
        _getAllVendorState = RequestState.SUCCESS;
        _vendors = vendors;
        notifyListeners();
      },
    );
  }

  //* get vendor by id
  Future<void> getVendorById(int id) async {
    //loading
    _getVendorByIdState = RequestState.LOADING;
    notifyListeners();

    // get vendor by id
    final vendorById = await _getVendorById.call(id: id);

    // state
    vendorById.fold(
      (failure) {
        log('data vendor by id gagal di get');
        _getVendorByIdState = RequestState.FAILURE;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (vendor) {
        log('data vendor ${vendor.name} berhasil di get');
        _getVendorByIdState = RequestState.SUCCESS;
        _vendor = vendor;
        notifyListeners();
      },
    );
  }

  //* get all product
  Future<void> getAllProduct() async {
    // loading
    _getAllProductState = RequestState.LOADING;
    notifyListeners();

    // get all vendor
    final allProduct = await _getAllProduct.call();

    // state
    allProduct.fold(
      (failure) {
        log('semua data product gagal di get');
        _getAllProductState = RequestState.FAILURE;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (products) {
        log('semua data product berhasil di get');
        _getAllProductState = RequestState.SUCCESS;
        _products = products;
        notifyListeners();
      },
    );
  }

  //* get product by id
  Future<void> getProductById(int id) async {
    //loading
    _getProductByIdState = RequestState.LOADING;
    notifyListeners();

    // get product by id
    final productById = await _getProductById.call(id: id);

    // state
    productById.fold(
      (failure) {
        log('data product by id gagal di get');
        _getProductByIdState = RequestState.FAILURE;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (product) {
        log('data product ${_product?.name ?? '-'} berhasil di get');
        _getProductByIdState = RequestState.SUCCESS;
        _product = product;
        notifyListeners();
      },
    );
  }
}
