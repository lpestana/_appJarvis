import 'package:flutter/material.dart';
import 'package:jarvis_core/core/model/produto_model.dart';
import 'package:jarvis_core/core/preco_utils.dart';

class TotalizadorCarrinho extends StatelessWidget {
  TotalizadorCarrinho(this.produtos);

  final List<ProdutoModel> produtos;

  double getTotalCarrinho() {
    double total = 0;
    produtos.forEach((produto) {
      total += produto.quantidade *
          double.parse(PrecoUtils.limpaStringPreco(produto.preco));
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColor.withOpacity(.1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total: ',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(width: 8),
            Text(
              PrecoUtils.numeroToPreco(getTotalCarrinho().toString()),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
