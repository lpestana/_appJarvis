import 'package:flutter/material.dart';
import 'package:jarvisadmin/pages/carrinho/carrinho_controller.dart';
import 'package:jarvis_core/core/model/categoria_model.dart';
import 'package:jarvis_core/core/model/produto_model.dart';
import 'package:jarvis_core/widgets/mp_app_bar.dart';
import 'package:jarvis_core/widgets/mp_list_tile.dart';
import 'package:jarvis_core/widgets/mp_loading.dart';
import 'package:provider/provider.dart';

import 'produto_page.dart';
import 'produtos_por_categoria_controller.dart';

class ProdutosPorCategoria extends StatefulWidget {
  ProdutosPorCategoria(this.categoria, {Key key}) : super(key: key);

  final CategoriaModel categoria;

  @override
  _ProdutosPorCategoriaState createState() => _ProdutosPorCategoriaState();
}

class _ProdutosPorCategoriaState extends State<ProdutosPorCategoria> {
  ProdutosPorCategoriaController _controller = ProdutosPorCategoriaController();
  Future<List<ProdutoModel>> futureProdutos;

  @override
  void initState() {
    futureProdutos = _controller.getProdutosPorCategoria(widget.categoria);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPAppBar(
        title: Text(
          'Produtos da categoria: ${widget.categoria.nome}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        /*withLeading: true,
        actions: [MPButtonIcon(
            iconData: Icons.shopping_cart,
            onTap: () {
              final usuario = Provider.of<UsuarioModel>(context, listen: false);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Provider.value(
                    value: Provider.of<CarrinhoController>(context),
                    child: CarrinhoPage(usuario),
                  ),
                ),
              );
            },
          ),],*/
      ),
      body: FutureBuilder<List<ProdutoModel>>(
          future: futureProdutos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final produtos = snapshot.data;
              return ListView.builder(
                  itemBuilder: (_, i) => MPListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => Provider.value(
                                value: Provider.of<CarrinhoController>(context),
                                child: ProdutoPage(
                                  produtos[i],
                                ),
                              ),
                            ),
                          );
                        },
                        leading: Hero(
                          tag: produtos[i].urlImagem,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(produtos[i].urlImagem),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              produtos[i].preco.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                            Container(
                                width: 16, child: Icon(Icons.chevron_right)),
                          ],
                        ),
                        title: Text(produtos[i].nome),
                      ),
                  itemCount: produtos.length);
            } else {
              return Center(
                child: MPLoading(),
              );
            }
          }),
    );
  }
}
