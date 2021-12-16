import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jarvis_core/widgets/mp_button_icon.dart';
import 'package:jarvis_core/widgets/mp_empty.dart';
import 'package:jarvis_core/widgets/mp_list_view.dart';
import 'package:jarvis_core/widgets/mp_loading.dart';
import 'package:jarvisadmin/pages/pedidos_pendentes/pedidos_pendentes_controllerf.dart';
import 'package:jarvisadmin/pages/pedidos_producao/pedidos_producao.dart';
import 'package:jarvis_core/core/model/produto_model.dart';
import 'package:jarvis_core/widgets/mp_app_bar.dart';

class PedidosPendentesPagef extends StatefulWidget {
  PedidosPendentesPagef({Key key}) : super(key: key);

  @override
  _PedidosPendentesPageStatef createState() => _PedidosPendentesPageStatef();
}

class _PedidosPendentesPageStatef extends State<PedidosPendentesPagef> {
  final _controller = PedidosPendentesControlerf();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPAppBar(
        title: Text(
          'Pedidos Pendentes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        withLeading: true,
        actions: [
          MPButtonIcon(
            iconData: Icons.fastfood,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PedidosProducaoPage()),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _controller.pedidosPendentesStream,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              final pedidos =
                  _controller.getPedidosFromDocs(snapshot.data.docs);
              if (pedidos == null || pedidos.length == 0) {
                return MPEmpty();
              }
              return MPListView(
                itemCount: pedidos.length,
                itemBuilder: (_, i) => Dismissible(
                  key: Key(pedidos[i].id),
                  onDismissed: (direction) async {
                    await _controller.produzirPedido(pedidos[i]);
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text('Confirmação'),
                          content: Text(
                            'Tem certeza que deseja produzir pedido?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('SIM'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Não'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    child: ExpansionTile(
                      title: Text(
                        DateFormat("d MMM y 'as' HH:mm", 'pt_br').format(
                          DateFormat('yyyy-MM-dd HH:mm:ss').parse(
                            pedidos[i].dataPedido.toString(),
                          ),
                        ),
                      ),
                      subtitle: Text(
                        'Cliente: ${pedidos[i].nomeUsuario} / Mesa: ${pedidos[i].mesa} Observação: ${pedidos[i].observacao}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      trailing: Text(
                        'R\$ ${pedidos[i].valorPedido.toString()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      children: getProdutos(pedidos[i].produtos),
                    ),
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: MPLoading(),
              );
            } else {
              return MPEmpty();
            }
          }),
    );
  }
}

List<Widget> getProdutos(List<ProdutoModel> produtos) {
  if (produtos != null && produtos.isNotEmpty) {
    return produtos
        .map(
          (produto) => ListTile(
            leading: produto.urlImagem != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(produto.urlImagem),
                  )
                : Icon(Icons.add_box),
            title: Text(produto.nome),
            trailing: Text(produto.quantidade.toString()),
          ),
        )
        .toList();
  }
}
