import 'package:flutter/material.dart';
import 'package:jarvisadmin/pages/carrinho/carrinho_controller.dart';
import 'package:jarvis_core/core/model/produto_model.dart';
import 'package:jarvis_core/core/model/usuario_model.dart';
import 'package:jarvis_core/widgets/mp_app_bar.dart';
import 'package:jarvis_core/widgets/mp_button_icon.dart';
import 'package:jarvis_core/widgets/mp_list_tile.dart';
import 'package:jarvis_core/widgets/mp_loading.dart';
import 'package:jarvis_core/widgets/toasts/toast_utils.dart';
import 'package:provider/provider.dart';


import 'widgets/totalizador_carrinho.dart';

class CarrinhoPage extends StatefulWidget {
  CarrinhoPage(this.usuario, {Key key}) : super(key: key);

  final UsuarioModel usuario;

  @override
  _CarrinhoPageState createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  CarrinhoController _controller;
  Future<List<ProdutoModel>> futureCarrinho;

  @override
  void didChangeDependencies() {
    _controller = Provider.of<CarrinhoController>(context);
    futureCarrinho = _controller.getProdutosCarrinho();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPAppBar(
          title: Text(
        'Seu Pedido',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black,
        ),
      )),
      body: FutureBuilder<List<ProdutoModel>>(
          future: futureCarrinho,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              final produtosCarrinho = snapshot.data;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (_, i) => MPListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(produtosCarrinho[i].nome),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      produtosCarrinho[i].preco,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            width: 40,
                                            height: 30,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                              ),
                                            ),
                                            child: Text(produtosCarrinho[i]
                                                    .quantidade
                                                    ?.toString() ??
                                                '0')),
                                        SizedBox(width: 8),
                                        MPButtonIcon(
                                          iconData: Icons.remove,
                                          iconColor:
                                              Theme.of(context).primaryColor,
                                          withBackgroundColor: true,
                                          size: 30,
                                          onTap: () async {
                                            await _controller.removeProduto(
                                                produtosCarrinho[i]);
                                            futureCarrinho = _controller
                                                .getProdutosCarrinho();
                                            setState(() {});
                                          },
                                        ),
                                        SizedBox(width: 4),
                                        MPButtonIcon(
                                          iconData: Icons.add,
                                          iconColor:
                                              Theme.of(context).primaryColor,
                                          withBackgroundColor: true,
                                          size: 30,
                                          onTap: () async {
                                            await _controller.adicionaProduto(
                                                produtosCarrinho[i]);
                                            futureCarrinho = _controller
                                                .getProdutosCarrinho();
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        separatorBuilder: (context, i) => Divider(height: 1),
                        itemCount: produtosCarrinho.length,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          SizedBox(height: 12),
                          TotalizadorCarrinho(produtosCarrinho),
                          SizedBox(height: 12),
                          TextFormField(
                            onChanged: _controller.onChangeObservacao,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Observação'),
                            minLines: 3,
                            maxLines: 6,
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            onChanged: _controller.onChangeMesa,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(), hintText: 'Mesa'),
                            minLines: 1,
                            maxLines: 1,
                          ),
                          SizedBox(height: 24),
                          RaisedButton.icon(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 18),
                            icon: Icon(Icons.done, size: 32),
                            label: Text(
                              'Finalizar o Pedido',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () async {
                              final pedidoFoiConcluido =
                                  await _controller.finalizaPedido();
                              if (pedidoFoiConcluido) {
                                showSuccessToast(
                                    'Pedido finalizado com sucesso!');
                                Navigator.of(context).pop();
                              } else {
                                showWarningToast('Carrinho está vazio!');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: MPLoading(),
              );
            }
          }),
    );
  }
}
