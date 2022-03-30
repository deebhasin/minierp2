import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';
import '../providers/product_provider.dart';
import '../kwidgets/kcreatebutton.dart';
import '../kwidgets/ktablecellheader.dart';
import '../screens/productcreate.dart';




class ProductsView extends StatefulWidget {
  final double width;

  ProductsView({Key? key,
    this.width = 50}) : super(key: key);

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  late List<Product> productList;
  late double containerWidth;

  final currencyFormat = NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    containerWidth = widget.width * 0.95;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getProductList(),
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
//                  if (snapshot.error is ConnectivityError) {
//                    return NoConnectionScreen();
//                  }
              return Center(child: Text("An error occured.\n$snapshot"));
              // return noData(context);
            } else if (snapshot.hasData) {
              productList = snapshot.data!;

              if(productList.isEmpty){
                return noData(context);
              }
              else {
                return _displayProduct(context);
              }

            } else
              return noData(context);
          }
        },
      );
    });
  }

  Widget noData(context) {
    return Column(
      children: [
        KCreateButton(callFunction: productCreate,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Product",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 2,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Product does Not Exist",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _displayProduct(BuildContext context) {
      return Column(
        children: [
          KCreateButton(callFunction: productCreate,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Product",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 2,
                  textBaseline: TextBaseline.alphabetic,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KTableCellHeader(header: "#",
                context: context,
                cellWidth: containerWidth * .03,),
              KTableCellHeader(header: "Product Name",
                context: context,
                cellWidth: containerWidth * 0.18,),
              KTableCellHeader(header: "Unit",
                context: context,
                cellWidth: containerWidth * 0.14,),
              KTableCellHeader(header: "Price Per Unit",
                context: context,
                cellWidth: containerWidth * 0.14,),
              KTableCellHeader(header: "HSN Code",
                context: context,
                cellWidth: containerWidth * 0.1,),
              KTableCellHeader(header: "GST (%)",
                context: context,
                cellWidth: containerWidth * 0.14,),
              KTableCellHeader(header: "",
                context: context,
                cellWidth: containerWidth * .07,
                isLastPos: true,),
            ],
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children:[
          for(var i = 0; i < productList.length; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KTableCellHeader(header: productList[i].id.toString(),
                  context: context,
                  cellWidth: containerWidth * .03,),
                KTableCellHeader(header: productList[i].name,
                  context: context,
                  cellWidth: containerWidth * 0.18,),
                KTableCellHeader(header: productList[i].unit,
                  context: context,
                  cellWidth: containerWidth * 0.14,),
                KTableCellHeader(header: "\u{20B9} ${currencyFormat.format(productList[i].pricePerUnit)}",
                  context: context,
                  cellWidth: containerWidth * 0.14,),
                KTableCellHeader(header: productList[i].HSN,
                  context: context,
                  cellWidth: containerWidth * 0.1,),
                KTableCellHeader(header: productList[i].GST,
                  context: context,
                  cellWidth: containerWidth * 0.14,),
                KTableCellHeader(header: "",
                  context: context,
                  cellWidth: containerWidth * .07,
                  isLastPos: true,
                  id: productList[i].id,
                  deleteAction: deleteAction,
                  editAction: editAction,
                ),
                //   ],
                // ),
              ],
            ),
        ],
      );
    }

  void productCreate(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProductCreate(product: Product());
        }
    );
  }

  void deleteAction(int id){
    Provider.of<ProductProvider>(context, listen: false).deleteProduct(id);
  }

  Widget editAction(int id){
    Product product;
    return Consumer<ProductProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getProductById(id),
        builder: (context, AsyncSnapshot<Product> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              //                  if (snapshot.error is ConnectivityError) {
              //                    return NoConnectionScreen();
              //                  }
              return Center(child: Text("An error occured.\n$snapshot"));
              // return noData(context);
            } else if (snapshot.hasData) {
              product = snapshot.data!;
              // customer.forEach((row) => print(row));
              // return displayCustomer(context);
              return ProductCreate(product: product);
            } else
              return Container();
          }
        },
      );
    });
  }

}

