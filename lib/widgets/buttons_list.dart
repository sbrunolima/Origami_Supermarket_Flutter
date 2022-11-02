import 'package:flutter/material.dart';
import '../widgets/sectors_buttom.dart';
import 'package:provider/provider.dart';

import '../screens/start_screen_categories_screen.dart';
import '../providers/products_provider.dart';

class ButtonsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizedBox = const SizedBox(width: 15);
    final productsData = Provider.of<ProductsProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).popAndPushNamed(
                    StartScreenCategories.routeName,
                    arguments: 'Hortifruti');
              },
              child: SectorsButtom('assets/hortifruti.png', 'Hortifruti'),
            ),
            sizedBox,
            GestureDetector(
              onTap: () {
                Navigator.of(context).popAndPushNamed(
                    StartScreenCategories.routeName,
                    arguments: 'Açougue');
              },
              child: SectorsButtom('assets/acougue.png', 'Açougue'),
            ),
            sizedBox,
            GestureDetector(
              onTap: () {
                Navigator.of(context).popAndPushNamed(
                    StartScreenCategories.routeName,
                    arguments: 'Congelados');
              },
              child: SectorsButtom('assets/congelados.png', 'Congelados'),
            ),
            sizedBox,
            GestureDetector(
              onTap: () {
                Navigator.of(context).popAndPushNamed(
                    StartScreenCategories.routeName,
                    arguments: 'Resfriados');
              },
              child: SectorsButtom('assets/resfriados.png', 'Resfriados'),
            ),
            sizedBox,
            GestureDetector(
              onTap: () {
                Navigator.of(context).popAndPushNamed(
                    StartScreenCategories.routeName,
                    arguments: 'Padaria');
              },
              child: SectorsButtom('assets/padaria.png', 'Padaria'),
            ),
            sizedBox,
            GestureDetector(
              onTap: () {
                Navigator.of(context).popAndPushNamed(
                    StartScreenCategories.routeName,
                    arguments: 'Pães e Bolos');
              },
              child: SectorsButtom('assets/paesebolos.png', 'Pães e Bolos'),
            ),
            sizedBox,
            GestureDetector(
              onTap: () {
                Navigator.of(context).popAndPushNamed(
                    StartScreenCategories.routeName,
                    arguments: 'Mercearia');
              },
              child: SectorsButtom('assets/Mercearia.png', 'Mercearia'),
            ),
            sizedBox,
            GestureDetector(
              onTap: () {
                Navigator.of(context).popAndPushNamed(
                    StartScreenCategories.routeName,
                    arguments: 'Matinais');
              },
              child: SectorsButtom('assets/Matinais.png', 'Matinais'),
            ),
            sizedBox,
            GestureDetector(
              onTap: () {
                Navigator.of(context).popAndPushNamed(
                    StartScreenCategories.routeName,
                    arguments: 'Biscoitos');
              },
              child: SectorsButtom('assets/Biscoitos.png', 'Biscoitos'),
            ),
            sizedBox,
            GestureDetector(
              onTap: () {
                Navigator.of(context).popAndPushNamed(
                    StartScreenCategories.routeName,
                    arguments: 'Bebidas');
              },
              child: SectorsButtom('assets/bebidas.png', 'Bebidas'),
            ),
            sizedBox,
            GestureDetector(
              onTap: () {
                Navigator.of(context).popAndPushNamed(
                    StartScreenCategories.routeName,
                    arguments: 'Limpeza');
              },
              child: SectorsButtom('assets/Limpeza.png', 'Limpeza'),
            ),
            sizedBox,
            GestureDetector(
              onTap: () {
                Navigator.of(context).popAndPushNamed(
                    StartScreenCategories.routeName,
                    arguments: 'Perfumaria');
              },
              child: SectorsButtom('assets/Perfumaria.png', 'Perfumaria'),
            ),
            sizedBox,
            GestureDetector(
              onTap: () {
                Navigator.of(context).popAndPushNamed(
                    StartScreenCategories.routeName,
                    arguments: 'Pet Shop');
              },
              child: SectorsButtom('assets/pet.png', 'Pet Shop'),
            ),
          ],
        ),
      ),
    );
  }
}
