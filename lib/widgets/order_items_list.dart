import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/orders.dart';

class OrdersItemsList extends StatefulWidget {
  final OrderItem order;

  OrdersItemsList(this.order);

  @override
  State<OrdersItemsList> createState() => _OrdersItemsListState();
}

class _OrdersItemsListState extends State<OrdersItemsList> {
  var _expanded = false;
  var _expandedPayments = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Pedido ID: ${widget.order.id}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyy -- hh:mm:ss')
                  .format(widget.order.dateTime!),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                _expanded
                    ? Icons.expand_less_outlined
                    : Icons.expand_more_outlined,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                  print(widget.order.cartAmount);
                });
              },
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 20),

                  Container(
                    height:
                        min(widget.order.products!.length * 20.0 + 200, 300),
                    child: ListView(
                      children: widget.order.products!
                          .map((prod) => ListTile(
                                leading: Image.network(prod.imageUrl),
                                title: Text(prod.title!),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Preço: ${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(prod.price.toString()))} ',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Quant: ${prod.quantity} un',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // TOTAL DA COMPRA
                  const Divider(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Detalhes de Pagamento',
                          style: GoogleFonts.openSans(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _expandedPayments
                                ? Icons.expand_less_outlined
                                : Icons.expand_more_outlined,
                            size: 30,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _expandedPayments = !_expandedPayments;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (_expandedPayments)
                    Column(
                      children: [
                        paymentDetails(
                          'Subtotal',
                          '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(widget.order.cartAmount.toString()))}',
                          false,
                        ),
                        paymentDetails(
                          'Custo de entrega',
                          '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(widget.order.frete.toString()))}',
                          false,
                        ),
                        paymentDetails(
                          'Total',
                          '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(widget.order.amount.toString()))}',
                          true,
                        ),
                        paymentDetails(
                          'Pagamento',
                          '${widget.order.paymentType}',
                          true,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                titleObservation('Nome e Telefone: ',
                                    '${widget.order.nomeTel}'),
                                const SizedBox(height: 8),
                                titleObservation(
                                    'Endereço: ', '${widget.order.address}'),
                                const SizedBox(height: 8),
                                titleObservation(
                                    'CPF Nota Fiscal: ', '${widget.order.cpf}'),
                                const SizedBox(height: 8),
                                titleObservation(
                                  'Troco para Valor: ',
                                  'R\$ ${widget.order.troco.toString().replaceAll('.', ',')}',
                                ),
                                const SizedBox(height: 8),
                                titleObservation('Observações: ',
                                    '${widget.order.description}'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent,
                                ),
                                child: const Text('FINALIZAR PEDIDO'),
                                onPressed: () {
                                  popDialog(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget paymentDetails(String title, String valor, bool color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.openSans(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                valor,
                style: GoogleFonts.openSans(
                  color: color ? Colors.green : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Divider(),
        ],
      ),
    );
  }

  Widget titleObservation(String title, subtitle) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Container(
              child: Expanded(
                child: Text(
                  subtitle,
                  style: GoogleFonts.openSans(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future popDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: AlertDialog(
          title: Center(
            child: Text(
              'FINALIZAR PEDIDO!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Container(
            child: Text(
              'Tem certeza que o pedido foi completado? Continuar irá deletar o pedido do sistema.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  child: Text(
                    'SIM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await Provider.of<Orders>(context, listen: false)
                        .deleteOrder(widget.order.id.toString());
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  child: Text(
                    'NÃO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
