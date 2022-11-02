import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/start_screen.dart';
import '../widgets/products_overview.dart';
import '../providers/products_provider.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

class ByCategoryScreen extends StatefulWidget {
  static const routeName = '/by-catedory-screen';

  @override
  State<ByCategoryScreen> createState() => _ByCategoryScreenState();
}

class _ByCategoryScreenState extends State<ByCategoryScreen> {
  var _isInit = true;
  var title;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final pageId = ModalRoute.of(context)!.settings.arguments;
      if (pageId != null) {
        setState(() {
          title = pageId.toString();
        });
      }
      switch (title.toString()) {
        case 'Hortifruti':
          Provider.of<ProductsProvider>(context).showHortifruti();
          break;
        case 'Açougue':
          Provider.of<ProductsProvider>(context).showAcouge();
          break;
        case 'Congelados':
          Provider.of<ProductsProvider>(context).showCongelados();
          break;
        case 'Resfriados':
          Provider.of<ProductsProvider>(context).showResfriados();
          break;
        case 'Padaria':
          Provider.of<ProductsProvider>(context).showPadaria();
          break;
        case 'Pães e Bolos':
          Provider.of<ProductsProvider>(context).showPaeseBolos();
          break;
        case 'Mercearia':
          Provider.of<ProductsProvider>(context).showMercearia();
          break;
        case 'Matinais':
          Provider.of<ProductsProvider>(context).showMatinais();
          break;
        case 'Biscoitos':
          Provider.of<ProductsProvider>(context).showBiscoitos();
          break;
        case 'Bebidas':
          Provider.of<ProductsProvider>(context).showBebidas();
          break;
        case 'Limpeza':
          Provider.of<ProductsProvider>(context).showLimpeza();
          break;
        case 'Perfumaria':
          Provider.of<ProductsProvider>(context).showPerfumaria();
          break;
        case 'Pet Shop':
          Provider.of<ProductsProvider>(context).showPetShop();
          break;
        default:
          Provider.of<ProductsProvider>(context).showAll();
          break;
      }
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  Future<void> searchProduct(String query) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .findedProducts(query);
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .popAndPushNamed(StartScreen.routeName, arguments: "2");

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              collapsedHeight: 120,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 30,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .popAndPushNamed(StartScreen.routeName, arguments: "2");
                },
              ),
              title: Text(
                title.toString(),
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
                      Navigator.of(context).popAndPushNamed(
                          StartScreen.routeName,
                          arguments: '3');
                    },
                  ),
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          productsData.findedProducts(value);
                        });
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(26),
                            borderSide:
                                BorderSide(color: Colors.grey.shade200)),
                        hintText: 'Buscar Produto',
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Divider(thickness: 1),
                  ),
                  ProductsOverview(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
