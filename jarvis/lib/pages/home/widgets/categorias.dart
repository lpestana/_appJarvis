import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jarvisadmin/pages/carrinho/carrinho_controller.dart';
import 'package:jarvisadmin/pages/produtos_por_categoria/produtos_por_categoria_page.dart';
import 'package:jarvis_core/core/model/categoria_model.dart';
import 'package:provider/provider.dart';

class Categorias extends StatelessWidget {
  const Categorias(this.categorias, {Key key}) : super(key: key);

  final List<CategoriaModel> categorias;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Categorias',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        CarouselSlider(
          items: categorias
              .map(
                (categoria) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Provider.value(
                          value: Provider.of<CarrinhoController>(context),
                          child: ProdutosPorCategoria(categoria),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Image.network(
                          categoria.urlImagem,
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              categoria.nome,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
            disableCenter: true,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            height: 200,
          ),
        ),
      ],
    );
  }
}
