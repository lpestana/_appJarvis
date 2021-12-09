import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jarvis_core/core/model/categoria_model.dart';
import 'package:jarvis_core/core/model/produto_model.dart';

class ProdutosPorCategoriaController {
  final _produtosRef = FirebaseFirestore.instance.collection('produtos');

  Future<List<ProdutoModel>> getProdutosPorCategoria(
      CategoriaModel categoria) async {
    final query = _produtosRef.where('categoria', isEqualTo: categoria.nome);
    final querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => ProdutoModel.fromJson(doc.id, doc.data()))
        .toList();
  }
}
