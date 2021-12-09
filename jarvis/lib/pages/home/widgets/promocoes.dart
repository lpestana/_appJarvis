import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jarvisadmin/pages/carrinho/carrinho_controller.dart';
import 'package:jarvisadmin/pages/produtos_por_categoria/produto_page.dart';
import 'package:jarvis_core/core/model/promocao_model.dart';
import 'package:provider/provider.dart';

import '../home_controller.dart';

class Promocoes extends StatelessWidget {
  Promocoes(this.promocoes, {Key key}) : super(key: key);

  final List<PromocaoModel> promocoes;
  final _homeController = HomeController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Promoções',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            //color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        CarouselSlider(
          items: promocoes
              .map(
                (promocao) => GestureDetector(
                  onTap: () async {
                    final produtoPromocao =
                        await _homeController.getProdutoPromocao(promocao);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Provider.value(
                          value: Provider.of<CarrinhoController>(context,
                              listen: false),
                          child: ProdutoPage(produtoPromocao),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Hero(
                          tag: promocao.urlImagem,
                          child: Image.network(
                            promocao.urlImagem,
                            fit: BoxFit.cover,
                            width: double.maxFinite,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Colors.red[400],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${promocao.desconto.toStringAsFixed(0)}% OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
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
                                promocao.nomeProduto,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
            disableCenter: true,
            autoPlay: true,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            height: 200,
          ),
        ),
      ],
    );
  }
}
