
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jarvis_core/core/model/pedido_model.dart';
import 'package:jarvis_core/core/model/produto_model.dart';
import 'package:jarvis_core/core/model/usuario_model.dart';
import 'package:jarvis_core/core/preco_utils.dart';

class CarrinhoController {
  CarrinhoController(this.usuario);

  PedidoModel pedido = PedidoModel();
  final UsuarioModel usuario;
  final _carrinhosRef = FirebaseFirestore.instance.collection('carrinhos');
  final _pedidosPendentesRef =
      FirebaseFirestore.instance.collection('pedidos_pendentes');

  Future<void> adicionaProduto(ProdutoModel produto) async {
    final doc =
        _carrinhosRef.doc(usuario.id).collection('produtos').doc(produto.id);
    final docSnapshot = await doc.get();
    if (docSnapshot.exists) {
      final quantidade = docSnapshot.data()['quantidade'] ?? 0;
      doc.set({
        ...produto.toJson(),
        'quantidade': quantidade + 1,
      });
    } else {
      doc.set({
        ...produto.toJson(),
        'quantidade': 1,
      });
    }
  }

  Future<void> removeProduto(ProdutoModel produto) async {
    final doc =
        _carrinhosRef.doc(usuario.id).collection('produtos').doc(produto.id);
    final docSnapshot = await doc.get();
    final quantidade = docSnapshot.data()['quantidade'] ?? 0;
    if (quantidade == 0) {
      return;
    } else if (quantidade == 1) {
      await doc.delete();
    } else {
      doc.set({
        ...produto.toJson(),
        'quantidade': quantidade - 1,
      });
    }
  }

  Future<List<ProdutoModel>> getProdutosCarrinho() async {
    final querySnapshot =
        await _carrinhosRef.doc(usuario.id).collection('produtos').get();
    return querySnapshot.docs
        .map((doc) => ProdutoModel.fromJson(doc.id, doc.data()))
        .toList();
  }

  void onChangeObservacao(String observacao) {
    pedido.observacao = observacao;
  }

  //mesa Cliente
  void onChangeMesa(String mesa) {
    pedido.mesa = mesa;
  }

  double getValorTotalPedido(List<ProdutoModel> produtos) {
    double total = 0;
    produtos.forEach((produto) {
      total += produto.quantidade *
          double.parse(PrecoUtils.limpaStringPreco(produto.preco));
    });
    return total;
  }

  Future<bool> finalizaPedido() async {
    final produtosCarrinho = await getProdutosCarrinho();
    if (produtosCarrinho.isNotEmpty) {
      final valorPedido = getValorTotalPedido(produtosCarrinho);
      pedido.produtos = produtosCarrinho;
      pedido.valorPedido = valorPedido;
      pedido.usuarioId = usuario.id;
      pedido.mesa = pedido.mesa;
      pedido.nomeUsuario = usuario.nome;
      pedido.dataPedido = DateTime.now();

      await deleteCarrinho();
      await _pedidosPendentesRef.add(pedido.toJson());
      return true;
    }
    return false;
  }

  Future<void> deleteCarrinho() async {
    await _carrinhosRef.doc(usuario.id).delete();
    final produtosCarrinho =
        await _carrinhosRef.doc(usuario.id).collection('produtos').get();
    produtosCarrinho.docs.forEach((doc) {
      _carrinhosRef.doc(usuario.id).collection('produtos').doc(doc.id).delete();
    });
  }
}
