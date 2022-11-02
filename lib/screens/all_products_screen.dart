import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/products_overview.dart';
import '../providers/products_provider.dart';
import '../screens/start_screen.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

enum Filter {
  Todos,
  Bebidas,
  Acougue,
}

class AllProductsScreen extends StatefulWidget {
  static const routeName = '/all-products-screen';

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  var _isInit = true;
  var sendedArg = "todosProdutos";
  String novoSetor = 'Todos';
  String query = '';
  String? find;
  final setores = [
    'Todos',
    'Hortifruti',
    'Açougue',
    'Congelados',
    'Resfriados',
    'Padaria',
    'Pães e Bolos',
    'Mercearia',
    'Matinais',
    'Biscoitos',
    'Bebidas',
    'Limpeza',
    'Perfumaria',
    'Pet Shop',
  ];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ProductsProvider>(context, listen: false).showAll();
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  void searchProduct(String query) {
    setState(() {
      Provider.of<ProductsProvider>(context, listen: false)
          .findedProducts(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popAndPushNamed(StartScreen.routeName);
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
                      .popAndPushNamed(StartScreen.routeName, arguments: '0');
                },
              ),
              title: Text(
                'Todos os Produtos',
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
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Ordernar por: ',
                              style: GoogleFonts.openSans(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Container(
                              width: 130,
                              height: 30,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: novoSetor,
                                  iconSize: 30,
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: Colors.black),
                                  isExpanded: true,
                                  items: setores.map(buildSetoresMenu).toList(),
                                  onChanged: (value) => setState(
                                    () {
                                      this.novoSetor = value.toString();

                                      switch (value.toString()) {
                                        case 'Todos':
                                          productsData.showAll();
                                          break;
                                        case 'Açougue':
                                          productsData.showAcouge();
                                          break;
                                        case 'Hortifruti':
                                          productsData.showHortifruti();
                                          break;
                                        case 'Congelados':
                                          productsData.showCongelados();
                                          break;
                                        case 'Resfriados':
                                          productsData.showResfriados();
                                          break;
                                        case 'Padaria':
                                          productsData.showPadaria();
                                          break;
                                        case 'Pães e Bolos':
                                          productsData.showPaeseBolos();
                                          break;
                                        case 'Mercearia':
                                          productsData.showMercearia();
                                          break;
                                        case 'Matinais':
                                          productsData.showMatinais();
                                          break;
                                        case 'Biscoitos':
                                          productsData.showBiscoitos();
                                          break;
                                        case 'Bebidas':
                                          productsData.showBebidas();
                                          break;
                                        case 'Limpeza':
                                          productsData.showLimpeza();
                                          break;
                                        case 'Perfumaria':
                                          productsData.showPerfumaria();
                                          break;
                                        case 'Pet Shop':
                                          productsData.showPetShop();
                                          break;
                                        default:
                                          productsData.showAll();
                                          break;
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Divider(thickness: 1),
                  ),
                  ProductsOverview(),
                  const SizedBox(height: 80),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildSetoresMenu(String setor) => DropdownMenuItem(
        value: setor,
        child: Text(
          setor,
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
