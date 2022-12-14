import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../screens/start_screen.dart';
import '../widgets/departments_options_widget.dart';
import '../screens/by_category_screen.dart';
import '../providers/products_provider.dart';

class DepartmentScreen extends StatefulWidget {
  static const routeName = '/department-screen';

  @override
  _DepartmentScreenState createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  var sendedArg = "departamentos";

  @override
  Widget build(BuildContext context) {
    final sizedBox = const SizedBox(height: 5);
    final productsData = Provider.of<ProductsProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popAndPushNamed(StartScreen.routeName);

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context)
                  .popAndPushNamed(StartScreen.routeName, arguments: '0');
            },
          ),
          title: Text(
            'Departamentos',
            style: GoogleFonts.openSans(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            //CART BUTTOn WITH NOTIFICATION
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                      CartScreen.routeName,
                      arguments: sendedArg);
                },
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          ByCategoryScreen.routeName,
                          arguments: 'Hortifruti');
                    },
                    child: DepartmentsOptions(
                        'Hortifruti', 'Legumes, Frutas, Verduras'),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          ByCategoryScreen.routeName,
                          arguments: 'A??ougue');
                    },
                    child: DepartmentsOptions(
                        'A??ougue', 'Bovinos, Su??nos, Frangos'),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          ByCategoryScreen.routeName,
                          arguments: 'Congelados');
                    },
                    child: DepartmentsOptions(
                        'Congelados', 'Peixes, Lasanhas, Hamb??rguer'),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          ByCategoryScreen.routeName,
                          arguments: 'Resfriados');
                    },
                    child: DepartmentsOptions(
                        'Resfriados', 'Iogurtes, Queijos, Manteigas'),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          ByCategoryScreen.routeName,
                          arguments: 'Padaria');
                    },
                    child:
                        DepartmentsOptions('Padaria', 'P??es, Salgados, Bolos'),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          ByCategoryScreen.routeName,
                          arguments: 'P??es e Bolos');
                    },
                    child: DepartmentsOptions('P??es e Bolos',
                        'P??o de forma, Bolos industrializados '),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          ByCategoryScreen.routeName,
                          arguments: 'Mercearia');
                    },
                    child: DepartmentsOptions(
                        'Mercearia', 'Arroz, Macarr??o, Enlatados, Farin??ceos'),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          ByCategoryScreen.routeName,
                          arguments: 'Matinais');
                    },
                    child:
                        DepartmentsOptions('Matinais', 'Caf??,  Leite, Cereais'),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          ByCategoryScreen.routeName,
                          arguments: 'Biscoitos');
                    },
                    child: DepartmentsOptions(
                        'Biscoitos', 'Salgadinhos,  Bolachas, Bombons'),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          ByCategoryScreen.routeName,
                          arguments: 'Bebidas');
                    },
                    child: DepartmentsOptions(
                        'Bebidas', 'Sucos, ??guas, Refrigerantes, Cervejas'),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          ByCategoryScreen.routeName,
                          arguments: 'Limpeza');
                    },
                    child: DepartmentsOptions(
                        'Limpeza', 'Sab??o em p??, Papel higi??nico, Amaciante'),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          ByCategoryScreen.routeName,
                          arguments: 'Perfumaria');
                    },
                    child: DepartmentsOptions(
                        'Perfumaria', 'Higiene, Shampoo, Sabonetes'),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          ByCategoryScreen.routeName,
                          arguments: 'Pet Shop');
                    },
                    child:
                        DepartmentsOptions('Pet Shop', 'C??es, Gatos, P??ssaros'),
                  ),
                  const SizedBox(height: 80)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
