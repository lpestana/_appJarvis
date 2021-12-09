import 'package:flutter/material.dart';
import 'package:jarvisadmin/pages/carrinho/carrinho_controller.dart';
import 'package:jarvis_core/core/model/produto_model.dart';
import 'package:jarvis_core/widgets/mp_app_bar.dart';
import 'package:jarvis_core/widgets/toasts/toast_utils.dart';
import 'package:provider/provider.dart';


class ProdutoPage extends StatelessWidget {
  ProdutoPage(this.produto);

  final ProdutoModel produto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPAppBar(
          title: Text(
        'Produto,',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black,
        ),
      )),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        alignment: Alignment.center,
        child: Column(
          children: [
            Hero(
              tag: produto.urlImagem,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(produto.urlImagem),
              ),
            ),
            SizedBox(height: 16),
            Text(
              produto.descricao,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 4),
            Text(
              produto.preco,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Tempo espera estimado: ${produto.tempoPreparo}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 24),
            RaisedButton.icon(
              onPressed: () async {
                final carrinhoController =
                    Provider.of<CarrinhoController>(context, listen: false);
                await carrinhoController.adicionaProduto(produto);
                showSuccessToast('Produto adicionado ao carrinho!');
              },
              icon: Icon(Icons.add_shopping_cart),
              label: Text(
                'Adicionar ao carrinho',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
