import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  //final String title;
  //final String imageURL;

  //ProductItem(this.id, this.title, this.imageURL);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false, //if false widget does not rebuild
    );
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return
        //Consumer<Product>(
        //consumer similar as using provider - shown above
        //builder: (ctx, product, child) =>
        ClipRRect(
      borderRadius: BorderRadius.circular(10), //to get rounded corners
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
                      child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ), //to fit the screen boxfit.cover

        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            //consumer similar as using provider - shown above
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              // label: child,
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavoriteStatus(
                  authData.token,
                  authData.userId,
                );
              },
            ),
            // child: Text('Never changes!'),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context)
                  .hideCurrentSnackBar(); //if there is a snack bar already it hides it to show a  new snack bar
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to Cart',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              ); //showing info popup
            },
            color: Theme.of(context).accentColor,
          ), //adding a button to the right of a widget
        ),
      ),
    );
  }
}
