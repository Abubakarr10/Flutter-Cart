import "package:cart/cart_model.dart";
import "package:cart/cart_provider.dart";
import "package:cart/cart_screen.dart";
import "package:cart/db_helper.dart";
import 'package:badges/badges.dart'as badges;
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  DBHelper? dbHelper = DBHelper();

  List<String> productName = ['Mango','Orange','Grapes','Banana','Chery','Peach','Fruit Basket'];
  List<String> productUnit = ['KG','KG','KG','Dozen','KG','KG','KG'];
  List<int> productPrice = [360,200,260,335,180,210,1800];
  List<String> productImage = [
    "https://www.svz.com/wp-content/uploads/2018/05/Mango.jpg",
    "https://pictures.grocerapps.com/original/grocerapp-orange--5e6d137b35212.png",
    "https://img.imageboss.me/fourwinds/width/425/dpr:2/s/files/1/2336/3219/products/blackmonukka.jpg?v=1538780984",
    "https://pictures.grocerapps.com/original/grocerapp-banana--6279e826254b1.jpeg",
    "https://static.libertyprim.com/files/familles/cerise-large.jpg?1569271737",
    "https://static.libertyprim.com/files/familles/peche-large.jpg?1574630286",
    "https://www.sendgiftbasket.eu/wp-content/uploads/2014/05/FG017.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List', style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
        centerTitle: true, backgroundColor: Colors.blue,
        actions:   [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const CartScreen()));
            },
            child: Center(
              child: badges.Badge(
               badgeContent: Consumer<CartProvider>(
                builder: (context, value, child){
                 return Text(value.getCounter().toString(), style: TextStyle(color: Colors.white));
    },
    ),
               //animationDuration: Duration(milliseconds: 300),
               child: const Icon(Icons.shopping_cart_sharp,size: 32,),
            ),

    ),
          ),
       const SizedBox(width: 20,),
  ]
    ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                itemCount: productName.length,
                  itemBuilder: (context,index){
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image(
                                height:200 , width: 200,
                                image:
                            NetworkImage(productImage[index].toString())),
                            const SizedBox(width: 20,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(productName[index],style: const TextStyle(fontSize: 45,fontWeight: FontWeight.w400),),
                                const SizedBox(height: 10,),
                                Text(productUnit[index]+' '+'Rs: '+productPrice[index].toString(),style: const TextStyle(fontSize: 32,fontWeight: FontWeight.w300),),
                              ],
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: (){
                                dbHelper!.insert(
                                  Cart(id: index,
                                      productID: index.toString(),
                                      productName: productName[index].toString(),
                                      initialPrice: productPrice[index],
                                      quantity: 1,
                                      productPrice: productPrice[index],
                                      unitTag: productUnit[index].toString(),
                                      image: productImage[index].toString())
                                ).then((value){
                                  print('Product is added to Cart');
                                  cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                  cart.addCounter();
                                }).onError((error, stackTrace){
                                  print(error.toString());
                                });
                              },
                              child: Container(
                                height: 60, width: 160,
                                decoration: BoxDecoration(
                                  color: Colors.blue, borderRadius: BorderRadius.circular(10)
                                ),
                                child: const Center(child: Text('Add to cart',style:
                                TextStyle(color: Colors.white,fontSize: 27),)),
                              ),
                            )
                              ],
                        )
                      ],
                    ),
                  ),
                );
              })
          )
        ],
      ),
    );
  }
}


