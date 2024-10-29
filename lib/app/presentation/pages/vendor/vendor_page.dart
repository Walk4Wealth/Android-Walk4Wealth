import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/enums/request_state.dart';
import '../../../core/utils/components/w_tab_bar.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import '../../providers/shop_provider.dart';
import 'vendor_description_view.dart';
import 'vendor_home_view.dart';

class VendorPage extends StatefulWidget {
  const VendorPage({super.key, required this.vendorId});

  final int vendorId;

  @override
  State<VendorPage> createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await context.read<ShopProvider>().getVendorById(widget.vendorId);
  }

  @override
  Widget build(BuildContext context) {
    double barHeight = 50;
    double headerHeight =
        MediaQuery.of(context).padding.top + kToolbarHeight + barHeight;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: kToolbarHeight + barHeight,
          title: Row(
            children: [
              //* logo vendor
              _vendorLogo(context),
              const SizedBox(width: 16),

              //* nama vendor
              _vendorName(context),
            ],
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: Column(
          children: [
            //* header background vendor
            _header(headerHeight),

            //* tabbar
            _tabBar(),

            //* vendor view
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  //* list product
                  VendorHomeView(_loadData),

                  //* desktripsi vendor
                  const VendorDescriptionView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBar() {
    return const Material(
      color: Colors.white,
      child: WTabBar([
        Tab(text: 'Produk'),
        Tab(text: 'Tentang'),
      ]),
    );
  }

  Widget _header(double headerHeight) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: headerHeight,
          child: Consumer<ShopProvider>(builder: (ctx, c, _) {
            if (c.getVendorByIdState == RequestState.LOADING) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: double.infinity,
                  height: headerHeight,
                  color: Colors.grey.shade300,
                ),
              );
            }
            return CachedNetworkImage(
              imageUrl: c.vendor?.logoUrl ?? '',
              errorWidget: (_, __, ___) => Image.asset(AssetImg.error),
              fit: BoxFit.cover,
            );
          }),
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              height: headerHeight,
              color: Colors.black26.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _vendorName(BuildContext context) {
    return Consumer<ShopProvider>(builder: (ctx, c, _) {
      if (c.getVendorByIdState == RequestState.LOADING) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 60,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        );
      } else {
        return Text(
          c.vendor?.name ?? '',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        );
      }
    });
  }

  Widget _vendorLogo(BuildContext context) {
    return Consumer<ShopProvider>(builder: (ctx, c, _) {
      return CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundImage: (c.getVendorByIdState == RequestState.SUCCESS)
            ? CachedNetworkImageProvider(c.vendor?.logoUrl ?? '')
            : null,
      );
    });
  }
}
