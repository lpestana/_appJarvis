import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jarvis_core/core/model/categoria_model.dart';
import 'package:jarvis_core/core/model/pedido_model.dart';
import 'package:jarvis_core/core/model/produto_model.dart';
import 'package:jarvis_core/core/model/promocao_model.dart';
import 'package:jarvis_core/core/preco_utils.dart';

class HomeController {
  final _promocoesRef = FirebaseFirestore.instance.collection('promocoes');
  final _produtosRef = FirebaseFirestore.instance.collection('produtos');
  final _categoriasRef = FirebaseFirestore.instance.collection('categorias');
  

  Future<List<PromocaoModel>> getPromocoes() async {
    final querySnapshot = await _promocoesRef.get();
    return List.generate(
        querySnapshot.docs.length,
        (i) => PromocaoModel.fromJson(
            querySnapshot.docs[i].id, querySnapshot.docs[i].data()));
  }

  Future<List<CategoriaModel>> getCategorias() async {
    final querySnapshot = await _categoriasRef.get();
    return List.generate(
        querySnapshot.docs.length,
        (i) => CategoriaModel.fromJson(
            querySnapshot.docs[i].id, querySnapshot.docs[i].data()));
  }

  Future<ProdutoModel> getProdutoPromocao(PromocaoModel promocao) async {
    final querySnapshot =
        await _produtosRef.where('nome', isEqualTo: promocao.nomeProduto).get();
    final doc = querySnapshot.docs.first;
    final produto = ProdutoModel.fromJson(doc.id, doc.data());
    final preco =
        promocao.valorOriginalProduto * (1 - (promocao.desconto / 100));
    produto.preco = PrecoUtils.numeroToPreco(preco.toString());
    return produto;
  }

  List<PedidoModel> getPedidosFromDocs(List<QueryDocumentSnapshot> docs) {
    return List.generate(docs.length, (i) {
      final pedidoDoc = docs[i];
      return PedidoModel.fromJson(pedidoDoc.id, pedidoDoc.data());
    });
  }

}
