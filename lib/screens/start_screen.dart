import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home_page_screen.dart';
import '../providers/products_provider.dart';
import '../screens/departments_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/all_products_screen.dart';
import '../screens/splash_screen.dart';
import '../providers/auth.dart';
import '../screens/profile_screen.dart';
import '../screens/auth_screen.dart';

class StartScreen extends StatefulWidget {
  static const routeName = '/start-screen';

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int index = 0;
  var _isInit = true;

  final screens = [
    HomePageScreen(),
    AllProductsScreen(),
    DepartmentScreen(),
    CartScreen(),
    Consumer<Auth>(
      builder: (ctx, auth, _) => auth.isAuth
          ? ProfileScreen()
          : FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (ctx, authResult) =>
                  authResult.connectionState == ConnectionState.waiting
                      ? SplashScreen()
                      : AuthScreen(),
            ),
    ),
  ];

  Future<void> _refresProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).loadProducts();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final pageId = ModalRoute.of(context)!.settings.arguments;
      if (pageId != null) {
        setState(() {
          index = int.parse(pageId.toString());
        });
      }
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: RefreshIndicator(
        onRefresh: () => _refresProducts(context),
        child: screens[index],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        child: NavigationBar(
          height: 60,
          backgroundColor: Colors.white,
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() {
            this.index = index;
            if (index == 1) {
              productsData.showAll();
            }
          }),
          destinations: [
            NavigationDestination(
              selectedIcon: Icon(Icons.store_mall_directory_rounded,
                  color: Colors.blue.shade800),
              icon: const Icon(Icons.store_mall_directory_outlined,
                  color: Colors.black),
              label: 'Início',
            ),
            NavigationDestination(
              selectedIcon:
                  Icon(Icons.shopping_bag_rounded, color: Colors.blue.shade800),
              icon:
                  const Icon(Icons.shopping_bag_outlined, color: Colors.black),
              label: 'Produtos',
            ),
            NavigationDestination(
              selectedIcon:
                  Icon(Icons.menu_open_rounded, color: Colors.blue.shade800),
              icon: const Icon(Icons.menu_rounded, color: Colors.black),
              label: 'Setores',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.shopping_cart_rounded,
                  color: Colors.blue.shade800),
              icon:
                  const Icon(Icons.shopping_cart_outlined, color: Colors.black),
              label: 'Carrinho',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person, color: Colors.blue.shade800),
              icon: const Icon(Icons.person_outline_outlined,
                  color: Colors.black),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
