import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/start_screen.dart';
import './providers/links_provider.dart';
import './screens/home_page_screen.dart';
import './screens/departments_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './data/product.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/payment_screen.dart';
import 'screens/finish_cards_screen.dart';
import 'screens/finish_money_screen.dart';
import './providers/payment_type.dart';
import './screens/orders_screen.dart';
import './screens/all_products_screen.dart';
import './screens/wats_screen.dart';
import './screens/auth_screen.dart';
import './screens/signup_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';
import './screens/account_screen.dart';
import './screens/add_adress_screen.dart';
import './providers/user.dart';
import './screens/choose_address_screen.dart';
import './screens/search_screen.dart';
import './screens/profile_screen.dart';
import './screens/by_category_screen.dart';
import './screens/start_screen_categories_screen.dart';
import './screens/our_shops_screen.dart';
import './providers/frete_provider.dart';
import './screens/forgot_password_screen.dart';

void main() => runApp(MyShopApp());

class MyShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => LinksProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FreteProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (ctx) => ProductsProvider('', []),
          update: (ctx, auth, previousProduct) => ProductsProvider(
            auth.token,
            previousProduct == null ? [] : previousProduct.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Product(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders('', '', []),
          update: (ctx, auth, previousProduct) => Orders(
            auth.token,
            auth.userId,
            previousProduct == null ? [] : previousProduct.orders,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, User>(
          create: (ctx) => User('', '', []),
          update: (ctx, auth, previousProduct) => User(
            auth.token,
            auth.userId,
            previousProduct == null ? [] : previousProduct.users,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Payment(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop APP',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: StartScreen(),
          routes: {
            StartScreen.routeName: (ctx) => StartScreen(),
            HomePageScreen.routeName: (ctx) => HomePageScreen(),
            DepartmentScreen.routeName: (ctx) => DepartmentScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            PaymentScreen.routeName: (ctx) => PaymentScreen(),
            FinishCardScreen.routeName: (ctx) => FinishCardScreen(),
            FinishMoneyScreen.routeName: (ctx) => FinishMoneyScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            AllProductsScreen.routeName: (ctx) => AllProductsScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            SignupScreen.routeName: (ctx) => SignupScreen(),
            SplashScreen.routeName: (ctx) => SplashScreen(),
            AccountScreen.routeName: (ctx) => AccountScreen(),
            AddAdressScreen.routeName: (ctx) => AddAdressScreen(),
            ChooseAddressScreen.routeName: (ctx) => ChooseAddressScreen(),
            SearchScreen.routeName: (ctx) => SearchScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            ByCategoryScreen.routeName: (ctx) => ByCategoryScreen(),
            StartScreenCategories.routeName: (ctx) => StartScreenCategories(),
            OurShopsScreens.routeName: (ctx) => OurShopsScreens(),
            WatsScreens.routeName: (ctx) => WatsScreens(),
            ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
          },
        ),
      ),
    );
  }
}
