import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/auth_or_home_page.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/products_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/utils/custom_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductList>(
            create: (_) => ProductList(),
            update: (ctx, auth, previous) {
              return ProductList(
                  auth.token ?? '', previous?.items ?? [], auth.userid ?? '');
            }),
        ChangeNotifierProxyProvider<Auth, OrderList>(
            create: (_) => OrderList(),
            update: (ctx, auth, previous) {
              return OrderList(
                  auth.token ?? '', auth.userid ?? '', previous?.items ?? []);
            }),
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.orange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder()
            })),
        //home: ProductsOverviewPage(),
        routes: {
          AppRoutes.AUTH_OR_HOME: (ctx) => AuthOrHomePage(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailPage(),
          AppRoutes.CART: (ctx) => CartPage(),
          AppRoutes.ORDERS: (ctx) => OrdersPage(),
          AppRoutes.PRODUCTS: (ctx) => ProductsPage(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormPage()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
